module Rack
  module WebSocket
    module Handler
      class Thin
        class Handler03 < Handler
          include Handshake76
          include Framing03

          def close_websocket
            # TODO: Should we send data and check the response matches?
            send_frame(:close, '')
            @state = :closing
          end
        end
      end
    end
  end
end
