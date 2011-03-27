module Rack
  module WebSocket
    module Handler
      class Thin
        module Handshake75
          def handshake
            location  = "#{request.env['rack.url_scheme']}://#{request.host}"
            location << ":#{request.port}" if request.port > 0
            location << request.path

            upgrade =  "HTTP/1.1 101 Web Socket Protocol Handshake\r\n"
            upgrade << "Upgrade: WebSocket\r\n"
            upgrade << "Connection: Upgrade\r\n"
            upgrade << "WebSocket-Origin: #{request.env['HTTP_ORIGIN']}\r\n"
            upgrade << "WebSocket-Location: #{location}\r\n\r\n"

            debug [:upgrade_headers, upgrade]

            return upgrade
          end
        end
      end
    end
  end
end
