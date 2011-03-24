module Rack
  module WebSocket
    module Handler
      module Thin
        class Handler75 < Handler
          include Handshake75
          include Framing76
        end
      end
    end
  end
end
