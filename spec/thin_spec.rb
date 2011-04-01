require 'thin'
require 'spec_helper'

describe 'Thin handler' do
  let(:app) { TestApp.new }
  
  before(:all) { silent_thin }
  before { start_thin_server(app) }
  after  { stop_thin_server }
  
  it "should include extensions" do
    ::Thin::Connection.include?(::Rack::WebSocket::Extensions::Common).should be_true
    ::Thin::Connection.include?(::Rack::WebSocket::Extensions::Thin::Connection).should be_true
  end
  
  it_should_behave_like 'all handlers'
end

def start_thin_server(app, options = {})
  @server = Thin::Server.new('0.0.0.0', TEST_PORT, options, app)
  @server.ssl = options[:ssl]
  # @server.threaded = options[:threaded]
  # @server.timeout = 3

  @thread = Thread.new { @server.start }
  sleep 1 until @server.running?
end

def stop_thin_server
  sleep 0.1
  @server.stop!
  @thread.kill
  raise "Reactor still running, wtf?" if EventMachine.reactor_running?
end

def silent_thin
  ::Thin::Logging.silent = true
  if EM::VERSION < "1.0.0"
    begin
      old_verbose, $VERBOSE = $VERBOSE, nil
      ::Thin::Server.const_set 'DEFAULT_TIMEOUT', 0
    ensure
      $VERBOSE = old_verbose
    end
  end
end