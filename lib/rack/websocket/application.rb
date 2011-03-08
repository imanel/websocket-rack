module Rack
  module WebSocket
    class Application

      DEFAULT_OPTIONS = {}
      attr_accessor :options

      def on_open; end # Fired when a client is connected.
      def on_message(msg); end # Fired when a message from a client is received.
      def on_close; end # Fired when a client is disconnected.
      def on_error(error); end # Fired when error occurs.

      def initialize(*args)
        app, options = args[0], args[1]
        app, options = nil, app if app.is_a?(Hash)
        @options = DEFAULT_OPTIONS.merge(options || {})
        @app = app
      end

      def call(env)
        if(env['HTTP_CONNECTION'].to_s.downcase == 'upgrade' && env['HTTP_UPGRADE'].to_s.downcase == 'websocket')
          @env = env
          socket = env['async.connection']
          @conn = Connection.new(self, socket)
          @conn.dispatch(env) ? async_response : failure_response
        elsif @app
          @app.call(env)
        else
          not_fount_response
        end
      end

      def close_websocket
        if @conn
          @conn.close_websocket
        else
          raise WebSocketError, "WebSocket not opened"
        end
      end

      def send_data(data)
        if @conn
          @conn.send data
        else
          raise WebSocketError, "WebSocket not opened"
        end
      end

      protected

      def async_response
        [-1, {}, []]
      end

      def failure_response
        [ 400, { "Content-Type" => "text/plain" }, [ 'invalid data' ] ]
      end

      def not_fount_response
        [ 404, { "Content-Type" => "text/plain" }, [ 'not found' ] ]
      end

    end
  end
end