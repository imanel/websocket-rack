module Rack
  module WebSocket
    VERSION = "0.0.1"
    ROOT_PATH = ::File.expand_path(::File.dirname(__FILE__))

    autoload :Application,    "#{ROOT_PATH}/websocket/application"
    autoload :Client,         "#{ROOT_PATH}/websocket/client"
    autoload :Connection,     "#{ROOT_PATH}/websocket/connection"
    autoload :Debugger,       "#{ROOT_PATH}/websocket/debugger"
    autoload :Framing03,      "#{ROOT_PATH}/websocket/framing03"
    autoload :Framing76,      "#{ROOT_PATH}/websocket/framing76"
    autoload :Handler,        "#{ROOT_PATH}/websocket/handler"
    autoload :Handler03,      "#{ROOT_PATH}/websocket/handler03"
    autoload :Handler75,      "#{ROOT_PATH}/websocket/handler75"
    autoload :Handler76,      "#{ROOT_PATH}/websocket/handler76"
    autoload :HandlerFactory, "#{ROOT_PATH}/websocket/handler_factory"
    autoload :Handshake75,    "#{ROOT_PATH}/websocket/handshake75"
    autoload :Handshake76,    "#{ROOT_PATH}/websocket/handshake76"

    module Extensions
      autoload :Thin,         "#{ROOT_PATH}/websocket/extensions/thin"
    end

  end
end

::Thin.send(:include, ::Rack::WebSocket::Extensions::Thin) if defined?(Thin)