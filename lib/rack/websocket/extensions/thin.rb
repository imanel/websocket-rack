module Rack
  module WebSocket
    module Extensions
      module Thin

        autoload :Connection, "#{::File.dirname(__FILE__)}/thin/connection"

        def self.apply!
          ::Thin::Connection.send(:include, ::Rack::WebSocket::Extensions::Common)
          ::Thin::Connection.send(:include, ::Rack::WebSocket::Extensions::Thin::Connection)
        end

      end
    end
  end
end