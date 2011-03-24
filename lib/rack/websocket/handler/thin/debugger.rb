module Rack
  module WebSocket
    module Handler
      module Thin
        module Debugger

          private

          def debug(*data)
            if @debug
              require 'pp'
              pp data
              puts
            end
          end

        end
      end
    end
  end
end
