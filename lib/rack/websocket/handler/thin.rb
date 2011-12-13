require 'thin'

module Rack
  module WebSocket
    module Handler
      class Thin < Base

        # Build request from Rack env
        def call(env)
          @env = env
          socket = env['async.connection']
          request = request_from_env(env)
          @connection = Connection.new(self, socket, :debug => @options[:debug])
          @connection.dispatch(request) ? async_response : failure_response
        end

        # Forward send_data to server
        def send_data(data)
          if @connection
            @connection.send data
          else
            raise WebSocketError, "WebSocket not opened"
          end
        end

        # Forward close_websocket to server
        def close_websocket
          if @connection
            @connection.close_websocket
          else
            raise WebSocketError, "WebSocket not opened"
          end
        end

        private

        # Parse Rack env to em-websocket-compatible format
        # this probably should be moved to Base in future
        def request_from_env(env)
          request = {}
          request['path']   = env['REQUEST_URI'].to_s
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