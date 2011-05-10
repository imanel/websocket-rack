module Rack
  module WebSocket
    class Application

      DEFAULT_OPTIONS = {}

      class << self
        attr_accessor :websocket_handler
      end

      # Standard WebSocket calls
      def on_open(env); end
      def on_message(env, msg); end
      def on_close(env); end
      def on_error(env, error); end

      # Initializer
      def initialize(options = {})
        @options = DEFAULT_OPTIONS.merge(options)
      end

      # Detect handler and duplicate it's instance
      def call(env)
        detect_handler(env)
        dup._call(env)
      end

      # Forward call to duplicated handler
      def _call(env)
        websocket_handler.call(env)
      end

      # Forward all missing methods to handler
      def method_missing(sym, *args, &block)
        if websocket_handler && websocket_handler.respond_to?(sym)
          websocket_handler.send sym, *args, &block
        else
          super
        end
      end

      private

      # Detect handler
      def detect_handler(env)
        self.class.websocket_handler ||= Handler.detect(env)
      end

      # Create and cache handler for current server
      def websocket_handler
        @websocket_handler ||= self.class.websocket_handler.new(self, @options || {})
      end
      
    end
  end
end