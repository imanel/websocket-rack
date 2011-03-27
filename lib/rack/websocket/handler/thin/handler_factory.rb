module Rack
  module WebSocket
    module Handler
      class Thin
        class HandlerFactory < ::EventMachine::WebSocket::HandlerFactory

          # Bottom half of em-websocket HandlerFactory
          # Taken from http://github.com/dj2/em-websocket
          # This method is also used in experimental branch of Goliath
          def self.build_with_request(connection, request, remains, secure = false, debug = false)
            version = request['Sec-WebSocket-Key1'] ? 76 : 75
            case version
            when 75
              if !remains.empty?
                raise ::EventMachine::WebSocket::HandshakeError, "Extra bytes after header"
              end
            when 76
              if remains.length < 8
                # The whole third-key has not been received yet.
                return nil
              elsif remains.length > 8
                raise ::EventMachine::WebSocket::HandshakeError, "Extra bytes after third key"
              end
              request['Third-Key'] = remains
            else
              raise ::EventMachine::WebSocket::WebSocketError, "Must not happen"
            end

            unless request['Connection'] == 'Upgrade' and request['Upgrade'] == 'WebSocket'
              raise ::EventMachine::WebSocket::HandshakeError, "Connection and Upgrade headers required"
            end

            # transform headers
            protocol = (secure ? "wss" : "ws")
            request['Host'] = Addressable::URI.parse("#{protocol}://"+request['Host'])

            if version = request['Sec-WebSocket-Draft']
              if version == '1' || version == '2' || version == '3'
                # We'll use handler03 - I believe they're all compatible
                ::EventMachine::WebSocket::Handler03.new(connection, request, debug)
              else
                # According to spec should abort the connection
                raise ::EventMachine::WebSocket::WebSocketError, "Unknown draft version: #{version}"
              end
            elsif request['Sec-WebSocket-Key1']
              ::EventMachine::WebSocket::Handler76.new(connection, request, debug)
            else
              ::EventMachine::WebSocket::Handler75.new(connection, request, debug)
            end
          end

        end
      end
    end
  end
end
