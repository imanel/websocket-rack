module Rack
  module WebSocket
    class Application

      DEFAULT_OPTIONS = {}
      attr_accessor :options

      def on_open(client); end # Fired when a client is connected.
      def on_message(client, msg); end # Fired when a message from a client is received.
      def on_close(client); end # Fired when a client is disconnected.

      def initialize(*args)
        app, options = args[0], args[1]
        app, options = nil, app if app.is_a?(Hash)
        @options = DEFAULT_OPTIONS.merge(options || {})
        @app = app
      end

      def call(env)
        if(env['HTTP_CONNECTION'].to_s.downcase == 'upgrade' && env['HTTP_UPGRADE'].to_s.downcase == 'websocket')
          instance = Client.new(self)
          instance.call(env)
        elsif @app
          @app.call(env)
        else
          [ 404, { "Content-Type" => "text/plain" }, [ 'not found' ] ]
        end
      end

    end
  end
end