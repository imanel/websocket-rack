require 'thin'

module Rack
  module WebSocket
    module Handler
      class Thin < Base

        autoload :Connection,     "#{ROOT_PATH}/websocket/handler/thin/connection"

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
          request['path']   = env['REQUEST_PATH'].to_s
          request['method'] = env['REQUEST_METHOD']
          request['query']  = env['QUERY_STRING'].to_s
          request['Body']   = env['rack.input'].read
          
          env.each do |key, value|
            if key.match(/HTTP_(.+)/)
              request[$1.downcase.gsub('_','-')] ||= value
            end
          end
          
          request
        end

      end
    end
  end
end