module Rack
  module WebSocket
    VERSION = "0.0.1"
    ROOT_PATH = ::File.expand_path(::File.dirname(__FILE__))

    module Extensions
      autoload :Thin, "#{ROOT_PATH}/websocket/extensions/thin"
    end

  end
end

::Thin.send(:include, ::Rack::WebSocket::Extensions::Thin) if defined?(Thin)