module Rack
  module WebSocket
    module Handler
      class Base
                
        def on_open; @parent.on_open(@env); end # Fired when a client is connected.
        def on_message(msg); @parent.on_message(@env, msg); end # Fired when a message from a client is received.
        def on_close; @parent.on_close(@env); end # Fired when a client is disconnected.
        def on_error(error); @parent.on_error(@env, error); end # Fired when error occurs.

        def initialize(parent, options = {})
          @parent = parent
          @options = options[:backend]
        end

        def call(env)
          raise 'Not implemented'
        end

        def send_data(data)
          raise 'Not implemented'
        end

        def close_websocket
          raise 'Not implemented'
        end

        protected

        def async_response
          [-1, {}, []]
        end

        def failure_response
          [ 400, { "Content-Type" => "text/plain" }, [ 'invalid data' ] ]
        end

      end
    end
  end
end