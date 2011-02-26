module Rack
  module WebSocket
    class HandlerFactory

      def self.build(env)
        env['rack.input'].rewind unless env['rack.input'].nil?
        remains = env['rack.input'].read

        raise HandshakeError, "Must be GET request" unless env['REQUEST_METHOD'] == 'GET'

        version = env['HTTP_SEC_WEBSOCKET_KEY1'] ? 76 : 75
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
        else
          raise WebSocketError, "Must not happen"
        end

        unless env['HTTP_CONNECTION'].to_s.downcase == 'upgrade' and env['HTTP_UPGRADE'].to_s.downcase == 'websocket'
          raise HandshakeError, "Connection and Upgrade headers required"
        end

        if version = env['HTTP_SEC_WEBSOCKET_DRAFT']
          if version == '1' || version == '2' || version == '3'
            # We'll use handler03 - I believe they're all compatible
            Handler03.new(env)
          else
            # According to spec should abort the connection
            raise WebSocketError, "Unknown draft version: #{version}"
          end
        elsif env['HTTP_SEC_WEBSOCKET_KEY1']
          Handler76.new(env)
        else
          Handler75.new(env)
        end

        return nil
      end

    end
  end
end