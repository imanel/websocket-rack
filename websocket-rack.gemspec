# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack/websocket/version"

Gem::Specification.new do |s|
  s.name        = "websocket-rack"
  s.version     = Rack::WebSocket::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bernard Potocki"]
  s.email       = ["bernard.potocki@imanel.org"]
  s.homepage    = "http://github.com/imanel/websocket-rack"
  s.summary     = %q{Rack-based WebSocket server}
  s.description = %q{Rack-based WebSocket server}

  s.add_dependency 'rack'
  s.add_dependency 'em-websocket', '~> 0.3.6'
  s.add_dependency 'eventmachine', '~> 1.0.0.beta.4'
  s.add_dependency 'thin' # Temporary until we support more servers
  s.add_development_dependency 'rspec', '~> 2.4.0'
  s.add_development_dependency 'mocha'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
