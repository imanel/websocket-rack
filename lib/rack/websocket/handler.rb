module Rack
  module WebSocket
    module Handler
      
      autoload :Thin, "#{ROOT_PATH}/websocket/handler/thin"
      
      def self.detect(env)
        server_software = env['SERVER_SOFTWARE']
        if server_software.match(/\Athin /i)
          Thin
        else
          nil # TODO: stub handler
        end
      end
      
    end
  end
end