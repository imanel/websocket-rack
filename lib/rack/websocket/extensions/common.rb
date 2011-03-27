module Rack
  module WebSocket
    module Extensions
        module Common

        def self.included(base)
          base.class_eval do
            alias :receive_data_without_websocket :receive_data
            alias :receive_data :receive_data_with_websocket

            alias :unbind_without_websocket :unbind
            alias :unbind :unbind_with_websocket

            alias :receive_data_without_flash_policy_file :receive_data
            alias :receive_data :receive_data_with_flash_policy_file
          end
        end

        attr_accessor :websocket

        def websocket?
          !self.websocket.nil?
        end

        def receive_data_with_websocket(data)
          if self.websocket?
            self.websocket.receive_data(data)
          else
            receive_data_without_websocket(data)
          end
        end

        def unbind_with_websocket
          if self.websocket?
            self.websocket.unbind
          else
            unbind_without_websocket
          end
        end

        def receive_data_with_flash_policy_file(data)
          # thin require data to be proper http request - in it's not
          # then @request.parse raises exception and data isn't parsed
          # by futher methods. Here we only check if it is flash
          # policy file request ("<policy-file-request/>\000") and
          # if so then flash policy file is returned. if not then
          # rest of request is handled.
          if (data == "<policy-file-request/>\000")
            file =  '<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*" to-ports="*"/></cross-domain-policy>'
            # ignore errors - we will close this anyway
            send_data(file) rescue nil
            close_connection_after_writing
          else
            receive_data_without_flash_policy_file(data)
          end
        end

      end
    end
  end
end
