require 'addressable/uri'

module Rack
  module WebSocket
    module Handler
      module Thin
        class Connection
          include Debugger

          def initialize(app, socket, options = {})
            @app = app
            @socket = socket
            @options = options
            @debug = options[:debug] || false

            socket.websocket = self
            socket.comm_inactivity_timeout = 0

            if socket.comm_inactivity_timeout != 0
              puts "WARNING: You are using old EventMachine version. " +
                   "Please consider updating to EM version >= 1.0.0 " +
                   "or running Thin using thin-websocket."
            end

            debug [:initialize]
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
          end

          def method_missing(sym, *args, &block)
            @socket.send sym, *args, &block
          end

          # Use this method to close the websocket connection cleanly
          # This sends a close frame and waits for acknowlegement before closing
          # the connection
          def close_websocket
            if @handler
              @handler.close_websocket
            else
              # The handshake hasn't completed - should be safe to terminate
              close_connection
            end
          end

          def receive_data(data)
            debug [:receive_data, data]

            @handler.receive_data(data)
          end

          def unbind
            debug [:unbind, :connection]

            @handler.unbind if @handler
          end

          def dispatch(data)
            debug [:inbound_headers, data.inspect] if @debug
            @handler = HandlerFactory.build(self, data, @debug)
            unless @handler
              # The whole header has not been received yet.
              return false
            end
            @handler.run
            return true
          rescue => e
            debug [:error, e]
            process_bad_request(e)
            return false
          end

          def process_bad_request(reason)
            trigger_on_error(reason)
            send_data "HTTP/1.1 400 Bad request\r\n\r\n"
            close_connection_after_writing
          end

          def send(data)
            debug [:send, data]

            if @handler
              @handler.send_text_frame(data)
            else
              raise WebSocketError, "Cannot send data before onopen callback"
            end
          end

          def close_with_error(message)
            trigger_on_error(message)
            close_connection_after_writing
          end

          def request
            @handler ? @handler.request : {}
          end

          def state
            @handler ? @handler.state : :handshake
          end
        end
      end
    end
  end
end
