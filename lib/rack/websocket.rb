require 'rack'
require 'em-websocket'

module Rack
  module WebSocket
    ROOT_PATH = ::File.expand_path(::File.dirname(__FILE__))

    autoload :Application, "#{ROOT_PATH}/websocket/application"
    autoload :Extensions,  "#{ROOT_PATH}/websocket/extensions"
    autoload :Handler,    "#{ROOT_PATH}/websocket/handler"
  end
end

Rack::WebSocket::Extensions.apply!
