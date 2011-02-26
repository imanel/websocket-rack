module Rack
  module WebSocket
    class HandlerFactory

      def self.build(connection, data, debug = false)
        request = Rack::Request.new(data)

        unless request.env['rack.input'].nil?
          request.env['rack.input'].rewind
          remains = request.env['rack.input'].read
        else
          # The whole header has not been received yet.
          return nil
        end

        unless request.get?
          raise HandshakeError, "Must be GET request"
        end

        version = request.env['HTTP_SEC_WEBSOCKET_KEY1'] ? 76 : 75
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
          request.env['HTTP_THIRD_KEY'] = remains
        else
          raise WebSocketError, "Must not happen"
        end

        unless request.env['HTTP_CONNECTION'] == 'Upgrade' and request.env['HTTP_UPGRADE'] == 'WebSocket'
          raise HandshakeError, "Connection and Upgrade headers required"
        end

        # transform headers
        request.env['rack.url_scheme'] = (request.scheme == 'https' ? "wss" : "ws")

        if version = request.env['HTTP_SEC_WEBSOCKET_DRAFT']
          if version == '1' || version == '2' || version == '3'
            # We'll use handler03 - I believe they're all compatible
            Handler03.new(connection, request, debug)
          else
            # According to spec should abort the connection
            raise WebSocketError, "Unknown draft version: #{version}"
          end
        elsif request.env['HTTP_SEC_WEBSOCKET_KEY1']
          Handler76.new(connection, request, debug)
        else
          Handler75.new(connection, request, debug)
        end
      end
    end
  end
end
