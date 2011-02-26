module Rack
  module WebSocket
    VERSION = "0.0.1"
    ROOT_PATH = ::File.expand_path(::File.dirname(__FILE__))

    autoload :Application,    "#{ROOT_PATH}/websocket/application"
    autoload :Client,         "#{ROOT_PATH}/websocket/client"
    autoload :HandlerFactory, "#{ROOT_PATH}/websocket/handler_factory"

    module Extensions
      autoload :Thin,         "#{ROOT_PATH}/websocket/extensions/thin"
    end

  end
end

::Thin.send(:include, ::Rack::WebSocket::Extensions::Thin) if defined?(Thin)