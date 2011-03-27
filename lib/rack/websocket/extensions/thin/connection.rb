module Rack
  module WebSocket
    module Extensions
      module Thin
        module Connection

          def self.included(base)
            base.class_eval do
              alias :pre_process_without_websocket :pre_process
              alias :pre_process :pre_process_with_websocket
            end
          end

          def pre_process_with_websocket
            @request.env['async.connection'] = self
            pre_process_without_websocket
          end

        end
      end
    end
  end
end