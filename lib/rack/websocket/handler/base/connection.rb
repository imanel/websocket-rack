require 'addressable/uri'

module Rack
  module WebSocket
    module Handler
      class Base
        class Connection < ::EventMachine::WebSocket::Connection

          # Overwrite new from EventMachine
          def self.new(*args)
            instance = allocate
            instance.__send__(:initialize, *args)
            instance
          end

          def trigger_on_message(msg)
            @app.on_message(msg)
          end
          def trigger_on_open
            @app.on_open
          end
          def trigger_on_close
            @app.on_close
          end
          def trigger_on_error(error)
            @app.on_error(error)
            true
          end

          def initialize(app, socket, options = {})
            @app = app
            @socket = socket
            @options = options
            @debug = options[:debug] || false
            @ssl = socket.backend.respond_to?(:ssl?) && socket.backend.ssl?

            socket.websocket = self
            socket.comm_inactivity_timeout = 0

            if socket.comm_inactivity_timeout != 0
              puts "WARNING: You are using old EventMachine version. " +
                   "Please consider updating to EM version >= 1.0.0 " +
                   "or running Thin using thin-websocket."
            end

            debug [:initialize]
          end

          def dispatch(data)
            return false if data.nil?
            debug [:inbound_headers, data]
            @handler = EventMachine::WebSocket::HandlerFactory.build_with_request(self, data, data['Body'], @ssl, @debug)
            unless @handler
              # The whole header has not been received yet.
              return false
            end
            @handler.run
            return true
          end

          # Overwrite send_data from EventMachine
          def send_data(*args)
            @socket.send_data(*args)
          end

          # Overwrite close_connection from EventMachine
          def close_connection(*args)
            @socket.close_connection(*args)
          end

        end
      end
    end
  end
end
