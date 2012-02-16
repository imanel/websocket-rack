require 'addressable/uri'

module Rack
  module WebSocket
    module Handler
      class Base
        class Connection < ::EventMachine::WebSocket::Connection

          #########################
          ### EventMachine part ###
          #########################

          # Overwrite new from EventMachine
          # we need to skip standard procedure called
          # when socket is created - this is just a stub
          def self.new(*args)
            instance = allocate
            instance.__send__(:initialize, *args)
            instance
          end

          # Overwrite send_data from EventMachine
          # delegate send_data to rack server
          def send_data(*args)
            EM.next_tick do
              @socket.send_data(*args)
            end
          end

          # Overwrite close_connection from EventMachine
          # delegate close_connection to rack server
          def close_connection(*args)
            EM.next_tick do
              @socket.close_connection(*args)
            end
          end

          #########################
          ### EM-WebSocket part ###
          #########################

          # Overwrite triggers from em-websocket
          def trigger_on_message(msg); @app.on_message(msg); end
          def trigger_on_open; @app.on_open; end
          def trigger_on_close; @app.on_close; end
          def trigger_on_error(error); @app.on_error(error); true; end

          # Overwrite initialize from em-websocket
          # set all standard options and disable
          # EM connection inactivity timeout
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

          # Overwrite dispath from em-websocket
          # we already have request headers parsed so
          # we can skip it and call build_with_request
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

        end
      end
    end
  end
end
