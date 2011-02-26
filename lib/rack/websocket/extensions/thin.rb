module Rack
  module WebSocket
    module Extensions
      module Thin

        autoload :Connection, "#{::File.dirname(__FILE__)}/thin/connection"

        def self.included(thin)
          thin_connection = thin.const_get(:Connection)
          thin_connection.send(:include, Thin.const_get(:Connection))
        end

      end
    end
  end
end