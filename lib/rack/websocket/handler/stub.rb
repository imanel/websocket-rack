module Rack
  module WebSocket
    module Handler
      class Stub < Base

        def call(env)
          raise 'Unknown handler!'
          close_websocket
        end

      end
    end
  end
end