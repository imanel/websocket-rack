module Rack
  module WebSocket
    module Handlers
      module Thin
        class Handler75 < Handler
          include Handshake75
          include Framing76
        end
      end
    end
  end
end
