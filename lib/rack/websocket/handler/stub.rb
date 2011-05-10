module Rack
  module WebSocket
    module Handler
      class Stub < Base

        # Always close socket
        def call(env)
          raise 'Unknown handler!'
          close_websocket
        end

      end
    end
  end
end