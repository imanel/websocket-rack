require 'digest/md5'

module Rack
  module WebSocket
    module Handler
      module Thin
        module Handshake76
          def handshake
            challenge_response = solve_challenge(
              request.env['HTTP_SEC_WEBSOCKET_KEY1'],
              request.env['HTTP_SEC_WEBSOCKET_KEY2'],
              request.env['HTTP_THIRD_KEY']
            )

            location  = "#{request.env['rack.url_scheme']}://#{request.host}"
            location << ":#{request.port}" if request.port > 0
            location << request.path

            upgrade =  "HTTP/1.1 101 WebSocket Protocol Handshake\r\n"
            upgrade << "Upgrade: WebSocket\r\n"
            upgrade << "Connection: Upgrade\r\n"
            upgrade << "Sec-WebSocket-Location: #{location}\r\n"
            upgrade << "Sec-WebSocket-Origin: #{request.env['HTTP_ORIGIN']}\r\n"
            if protocol = request.env['HTTP_SEC_WEBSOCKET_PROTOCOL']
              validate_protocol!(protocol)
              upgrade << "Sec-WebSocket-Protocol: #{protocol}\r\n"
            end
            upgrade << "\r\n"
            upgrade << challenge_response

            debug [:upgrade_headers, upgrade]

            return upgrade
          end

          private

          def solve_challenge(first, second, third)
            # Refer to 5.2 4-9 of the draft 76
            sum = [numbers_over_spaces(first)].pack("N*") +
              [numbers_over_spaces(second)].pack("N*") +
              third
            Digest::MD5.digest(sum)
          end

          def numbers_over_spaces(string)
            numbers = string.scan(/[0-9]/).join.to_i

            spaces = string.scan(/ /).size
            # As per 5.2.5, abort the connection if spaces are zero.
            raise HandshakeError, "Websocket Key1 or Key2 does not contain spaces - this is a symptom of a cross-protocol attack" if spaces == 0

            # As per 5.2.6, abort if numbers is not an integral multiple of spaces
            if numbers % spaces != 0
              raise HandshakeError, "Invalid Key #{string.inspect}"
            end

            quotient = numbers / spaces

            if quotient > 2**32-1
              raise HandshakeError, "Challenge computation out of range for key #{string.inspect}"
            end

            return quotient
          end

          def validate_protocol!(protocol)
            raise HandshakeError, "Invalid WebSocket-Protocol: empty" if protocol.empty?
            # TODO: Validate characters
          end
        end
      end
    end
  end
end
