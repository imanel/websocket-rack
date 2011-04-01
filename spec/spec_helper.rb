require 'rubygems'
require 'rspec'

require 'rack/websocket'
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :mocha
end

class TestApp < Rack::WebSocket::Application
end

TEST_PORT = 8081

def new_server_connection
  TCPSocket.new('localhost', TEST_PORT)
end
