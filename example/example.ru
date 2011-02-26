require 'lib/rack/websocket'

class MyApp < Rack::WebSocket::Application
  def on_open(client)
    puts "client connected"
  end

  def on_message(client, msg)
    puts "message received: " + msg
  end

  def on_close(client)
    puts "client disconnected"
  end
end

use Rack::CommonLogger

map '/' do
  use MyApp

  run Rack::File.new(File.expand_path(File.dirname(__FILE__)) + '/html')
end
