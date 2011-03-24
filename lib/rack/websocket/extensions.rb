module Rack
  module WebSocket
    module Extensions
      
      autoload :Thin, "#{ROOT_PATH}/websocket/extensions/thin"
      
      def self.apply!
        Thin.apply! if defined?(::Thin)
      end
      
    end
  end
end