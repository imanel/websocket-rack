require 'rack'

module Rack
  module WebSocket
    VERSION = "0.1.4"
    ROOT_PATH = ::File.expand_path(::File.dirname(__FILE__))

    class WebSocketError < RuntimeError; end
    class HandshakeError < WebSocketError; end
    class DataError < WebSocketError; end

    autoload :Application, "#{ROOT_PATH}/websocket/application"
    autoload :Extensions,  "#{ROOT_PATH}/websocket/extensions"
    autoload :Handler,    "#{ROOT_PATH}/websocket/handler"
  end
end

Rack::WebSocket::Extensions.apply!

unless ''.respond_to?(:getbyte)
  class String
    def getbyte(i)
      self[i]
    end
  end
end
