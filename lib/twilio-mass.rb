require 'twiliolib'
require 'crack'

module Twilio
  module Mass
    class Sender
      attr_accessor :sid, :token, :caller_id, :logger, :mailer_callback, :response_callbacks, :exception_callback, :error_callback

      def initialize(sid, token, caller_id)
        @sid = sid
        @token = token
        @caller_id = caller_id.to_a
        @response_callbacks = []
      end

      def deliver(message, recipients = [], callback_status = nil)
        account = Twilio::RestAccount.new(@sid, @token)
        text = prepare_text(message)
        send_time = Time.now
        recipients.each do |recipient|
          d = {
              'From' => @caller_id[rand(@caller_id.size)],
              'To' => recipient,
              'Body' => text,
          }
          begin
            resp = account.request("/2008-08-01/Accounts/#{@sid}/SMS/Messages", 'POST', d)
            if resp.kind_of? Net::HTTPSuccess
              begin
                sid = Crack::XML.parse(resp.body)["TwilioResponse"]["SMSMessage"]["Sid"]
              rescue => ex
                exception_callback.call(ex, "Could not parse Twilio response body. #{resp.body}") if @exception_callback
              end
              logger.info("Sent #{message} to #{recipient} Sid: #{sid}") if logger

              response_callbacks.each do |response_callback|
                response_callback.call(:recipient => recipient, :twilio_claimcheck => sid)
              end
            else
              logger.error("Could not send message to #{recipient}. Error: #{resp.body}") if logger
              mailer_callback.call("Error in Twilio SMS", "#{resp.body}") if @mailer_callback
              error_callback.call("Error in Twilio SMS. #{resp.body}") if @error_callback
            end
          rescue => ex
            exception_callback.call(ex, "#{d}") if @exception_callback
          end        
        end
      end

      def prepare_text(message)
        strip_unicode(message)[0..159]
      end

      def strip_unicode(message)
        message.unpack("c*").reject {|c| c <0 || c>255}.pack("c*")
      end
    end
  end
end
