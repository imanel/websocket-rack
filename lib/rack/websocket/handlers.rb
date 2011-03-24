module Rack
  module WebSocket
    module Handlers
      
      autoload :Thin, "#{ROOT_PATH}/websocket/handlers/thin"
      
    end
  end
end