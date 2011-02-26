module Rack
  module WebSocket
    class Client

      attr_accessor :app, :env

      def initialize(app)
        @app = app
      end

      def call(env)
        @env = env
        @connection = env['async.connection']

        if @handler = HandlerFactory.build(env)
          @connection.websocket = self
          trigger_on_open
          @handler.handshake
        else
          puts "!!! invalid websocket data"
          @app.bad_request
        end
      end

      def receive_data(data)
      end

      def unbind
        trigger_on_close
      end

      def trigger_on_open
        @app.on_open(self)
      end

      def trigger_on_message(msg)
        @app.on_message(self, msg)
      end

      def trigger_on_close
        @app.on_close(self)
      end

    end
  end
end