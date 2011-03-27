require 'thin'

module Rack
  module WebSocket
    module Handler
      class Thin
        
        autoload :Connection,     "#{ROOT_PATH}/websocket/handler/thin/connection"
        autoload :Debugger,       "#{ROOT_PATH}/websocket/handler/thin/debugger"
        autoload :Framing03,      "#{ROOT_PATH}/websocket/handler/thin/framing03"
        autoload :Framing76,      "#{ROOT_PATH}/websocket/handler/thin/framing76"
        autoload :Handler,        "#{ROOT_PATH}/websocket/handler/thin/handler"
        autoload :Handler03,      "#{ROOT_PATH}/websocket/handler/thin/handler03"
        autoload :Handler75,      "#{ROOT_PATH}/websocket/handler/thin/handler75"
        autoload :Handler76,      "#{ROOT_PATH}/websocket/handler/thin/handler76"
        autoload :HandlerFactory, "#{ROOT_PATH}/websocket/handler/thin/handler_factory"
        autoload :Handshake75,    "#{ROOT_PATH}/websocket/handler/thin/handshake75"
        autoload :Handshake76,    "#{ROOT_PATH}/websocket/handler/thin/handshake76"
        
        def on_open; @parent.on_open(@env); end # Fired when a client is connected.
        def on_message(msg); @parent.on_message(@env, msg); end # Fired when a message from a client is received.
        def on_close; @parent.on_close(@env); end # Fired when a client is disconnected.
        def on_error(error); @parent.on_error(@env, error); end # Fired when error occurs.

        def initialize(parent, options = {})
          @parent = parent
          @options = options
        end

        def call(env)
          if(env['HTTP_CONNECTION'].to_s.downcase == 'upgrade' && env['HTTP_UPGRADE'].to_s.downcase == 'websocket')
            @env = env
            socket = env['async.connection']
            @conn = Connection.new(self, socket, :debug => !!@options[:websocket_debug])
            @conn.dispatch(env) ? async_response : failure_response
          else
            not_found_response
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

        def not_found_response
          [ 404, { "Content-Type" => "text/plain" }, [ 'not found' ] ]
        end
      
      end
    end
  end
end