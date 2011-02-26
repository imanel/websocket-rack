module Rack
  module WebSocket
    class HandlerFactory

      def self.build(connection, data, secure = false, debug = false)
        data.rewind
        remains = data['rack.input'].read

        unless data["REQUEST_METHOD"] == "GET"
          raise HandshakeError, "Must be GET request"
        end

        version = data['HTTP_SEC_WEBSOCKET_KEY1'] ? 76 : 75
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
          data['HTTP_THIRD_KEY'] = remains
        else
          raise WebSocketError, "Must not happen"
        end

        unless data['HTTP_CONNECTION'] == 'Upgrade' and data['HTTP_UPGRADE'] == 'WebSocket'
          raise HandshakeError, "Connection and Upgrade headers required"
        end

        # transform headers
        protocol = (secure ? "wss" : "ws")
        data['Host'] = Addressable::URI.parse("#{protocol}://"+data['Host'])

        if version = data['HTTP_SEC_WEBSOCKET_DRAFT']
          if version == '1' || version == '2' || version == '3'
            # We'll use handler03 - I believe they're all compatible
            Handler03.new(connection, data, debug)
          else
            # According to spec should abort the connection
            raise WebSocketError, "Unknown draft version: #{version}"
          end
        elsif data['HTTP_SEC_WEBSOCKET_KEY1']
          Handler76.new(connection, data, debug)
        else
          Handler75.new(connection, data, debug)
        end
      end
    end
  end
end
