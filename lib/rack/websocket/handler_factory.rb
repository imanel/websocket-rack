module Rack
  module WebSocket
    class HandlerFactory

      def self.build(connection, data, secure = false, debug = false)
        data.rewind
        remains = data['rack.input'].read

        unless data["REQUEST_METHOD"] == "GET"
          raise HandshakeError, "Must be GET request"
        end

        version = request['Sec-WebSocket-Key1'] ? 76 : 75
        case version
        when 75
          if !remains.empty?
            raise HandshakeError, "Extra bytes after header"
          end
        when 76
          if remains.length < 8
            # The whole third-key has not been received yet.
            return nil
          elsif remains.length > 8
            raise HandshakeError, "Extra bytes after third key"
          end
          request['Third-Key'] = remains
        else
          raise WebSocketError, "Must not happen"
        end

        unless request['Connection'] == 'Upgrade' and request['Upgrade'] == 'WebSocket'
          raise HandshakeError, "Connection and Upgrade headers required"
        end

        # transform headers
        protocol = (secure ? "wss" : "ws")
        request['Host'] = Addressable::URI.parse("#{protocol}://"+request['Host'])

        if version = request['Sec-WebSocket-Draft']
          if version == '1' || version == '2' || version == '3'
            # We'll use handler03 - I believe they're all compatible
            Handler03.new(connection, request, debug)
          else
            # According to spec should abort the connection
            raise WebSocketError, "Unknown draft version: #{version}"
          end
        elsif request['Sec-WebSocket-Key1']
          Handler76.new(connection, request, debug)
        else
          Handler75.new(connection, request, debug)
        end
      end
    end
  end
end
