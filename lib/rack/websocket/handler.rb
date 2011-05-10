module Rack
  module WebSocket
    module Handler

      autoload :Base, "#{ROOT_PATH}/websocket/handler/base"
      autoload :Stub, "#{ROOT_PATH}/websocket/handler/stub"
      autoload :Thin, "#{ROOT_PATH}/websocket/handler/thin"

      # Detect current server using software Rack string
      def self.detect(env)
        server_software = env['SERVER_SOFTWARE']
        if server_software.match(/\Athin /i)
          Thin
        else
          Stub
        end
      end
      
    end
  end
end