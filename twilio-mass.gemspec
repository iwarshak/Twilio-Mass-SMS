# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "twilio-mass/version"

Gem::Specification.new do |s|
  s.name        = "twilio-mass"
  s.version     = Twilio::Mass::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian Warshak"]
  s.email       = ["iwarshak@stripey.net"]
  s.homepage    = ""
  s.summary     = %q{Sending mass text messages through Twilio}
  s.description = %q{Send mass text messages via Twilio}

  s.rubyforge_project = "twilio-mass"
  
  s.add_runtime_dependency "twiliolib", [">=2.0.7"]
  s.add_runtime_dependency "crack", [">= 0.1.8"]
  
  s.add_development_dependency "mocha"
  s.add_development_dependency "shoulda"
  
  s.add_development_dependency "ruby-debug19"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
