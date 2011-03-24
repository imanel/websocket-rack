require 'thin'

module Rack
  module WebSocket
    module Handlers
      module Thin
        
        autoload :Application,    "#{ROOT_PATH}/websocket/handlers/thin/application"
        autoload :Connection,     "#{ROOT_PATH}/websocket/handlers/thin/connection"
        autoload :Debugger,       "#{ROOT_PATH}/websocket/handlers/thin/debugger"
        autoload :Framing03,      "#{ROOT_PATH}/websocket/handlers/thin/framing03"
        autoload :Framing76,      "#{ROOT_PATH}/websocket/handlers/thin/framing76"
        autoload :Handler,        "#{ROOT_PATH}/websocket/handlers/thin/handler"
        autoload :Handler03,      "#{ROOT_PATH}/websocket/handlers/thin/handler03"
        autoload :Handler75,      "#{ROOT_PATH}/websocket/handlers/thin/handler75"
        autoload :Handler76,      "#{ROOT_PATH}/websocket/handlers/thin/handler76"
        autoload :HandlerFactory, "#{ROOT_PATH}/websocket/handlers/thin/handler_factory"
        autoload :Handshake75,    "#{ROOT_PATH}/websocket/handlers/thin/handshake75"
        autoload :Handshake76,    "#{ROOT_PATH}/websocket/handlers/thin/handshake76"
        
        def self.new(*args)
          Application.new *args
        end
      
      end
    end
  end
end