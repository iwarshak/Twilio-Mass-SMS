require 'rubygems'
require 'test/unit'
require 'twilio-mass'
require 'mocha'
require 'shoulda'
require 'ruby-debug'

class TestTwilioMass < Test::Unit::TestCase
  
  class DummyResponse < Net::HTTPSuccess; 
    def initialize
    end  
  end
  
  context "normal case" do
    should "work" do
      @client = Twilio::Mass::Sender.new('a','b',['2105555555'])
      @numbers = ['2105555555']
      response_handler = Object.new
      response_handler.expects(:call).times(1).with({:recipient => "2105555555", :twilio_claimcheck => "foo"})
      @client.response_callbacks << response_handler
      http_response = DummyResponse.new
      http_response.expects(:body).returns(good_response)
      Twilio::RestAccount.any_instance.expects(:request).returns(http_response)
      @client.deliver("hello", @numbers)
    end
  end
  
private
  def good_response
    "<?xml version=\"1.0\"?>\n<TwilioResponse><SMSMessage><Sid>foo</Sid><DateCreated>Mon, 31 Jan 2011 12:45:54 -0800</DateCreated><DateUpdated>Mon, 31 Jan 2011 12:45:54 -0800</DateUpdated><DateSent/><AccountSid>12345</AccountSid><To>2105555555</To><From>2107047913</From><Body>foo</Body><Status>queued</Status><Flags>4</Flags><Price/></SMSMessage></TwilioResponse>\n"
  end
  
end