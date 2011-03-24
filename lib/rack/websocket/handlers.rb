module Rack
  module WebSocket
    module Handlers
      
      autoload :Thin, "#{ROOT_PATH}/websocket/handlers/thin"
      
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