require 'thin'

module Rack
  module WebSocket
    module Handler
      class Thin < Base

        autoload :Connection,     "#{ROOT_PATH}/websocket/handler/thin/connection"
        autoload :HandlerFactory, "#{ROOT_PATH}/websocket/handler/thin/handler_factory"

        def call(env)
          @env = env
          socket = env['async.connection']
          request = request_from_env(env)
          @conn = Connection.new(self, socket, :debug => @options[:debug])
          @conn.dispatch(request) ? async_response : failure_response
        end

        def send_data(data)
          if @conn
            @conn.send data
          else
            raise WebSocketError, "WebSocket not opened"
          end
        end

        def close_websocket
          if @conn
            @conn.close_websocket
          else
            raise WebSocketError, "WebSocket not opened"
          end
        end
        
        private
        
        def request_from_env(env)
          request = {}
          request['Path']   = env['REQUEST_PATH'].to_s
          request['Method'] = env['REQUEST_METHOD']
          request['Query']  = env['QUERY_STRING'].to_s
          request['body']   = env['rack.input'].read
          
          request['Sec-WebSocket-Draft']    = env['HTTP_SEC_WEBSOCKET_DRAFT']
          request['Sec-WebSocket-Key1']     = env['HTTP_SEC_WEBSOCKET_KEY1']
          request['Sec-WebSocket-Key2']     = env['HTTP_SEC_WEBSOCKET_KEY2']
          request['Sec-WebSocket-Protocol'] = env['HTTP_SEC_WEBSOCKET_PROTOCOL']
          
          env.each do |key, value|
            if key.match(/HTTP_(.+)/)
              request[$1.capitalize.gsub('_','-')] ||= value
            end
          end
          
          request
        end

      end
    end
  end
end