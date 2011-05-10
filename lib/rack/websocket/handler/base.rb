module Rack
  module WebSocket
    module Handler
      class Base
                
        autoload :Connection,     "#{ROOT_PATH}/websocket/handler/base/connection"

        def on_open; @parent.on_open(@env); end # Fired when a client is connected.
        def on_message(msg); @parent.on_message(@env, msg); end # Fired when a message from a client is received.
        def on_close; @parent.on_close(@env); end # Fired when a client is disconnected.
        def on_error(error); @parent.on_error(@env, error); end # Fired when error occurs.

        # Set application as parent and forward options
        def initialize(parent, options = {})
          @parent = parent
          @options = options[:backend] || {}
        end

        # Implemented in subclass
        def call(env)
          raise 'Not implemented'
        end

        # Implemented in subclass
        def send_data(data)
          raise 'Not implemented'
        end

        # Implemented in subclass
        def close_websocket
          raise 'Not implemented'
        end

        protected

        # Standard async response
        def async_response
          [-1, {}, []]
        end

        # Standard 400 response
        def failure_response
          [ 400, {'Content-Type' => 'text/plain'}, [ 'Bad request' ] ]
        end

      end
    end
  end
end