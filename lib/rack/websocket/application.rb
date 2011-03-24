module Rack
  module WebSocket
    class Application
      
      DEFAULT_OPTIONS = {}
      
      class << self
        attr_accessor :websocket_handler
      end
      
      def on_open(env); end
      def on_message(env, msg); end
      def on_close(env); end
      def on_error(env, error); end
      
      def initialize(*args)
        app, options = args[0], args[1]
        app, options = nil, app if app.is_a?(Hash)
        @options = DEFAULT_OPTIONS.merge(options || {})
        @app = app
      end
      
      def call(env)
        detect_handler(env)
        dup._call(env)
      end
      
      def _call(env)
        websocket_handler.call(env)
      end
      
      def method_missing(sym, *args, &block)
        if websocket_handler && websocket_handler.respond_to?(sym)
          websocket_handler.send sym, *args, &block
        else
          super
        end
      end
      
      private
      
      def detect_handler(env)
        self.class.websocket_handler ||= Handlers.detect(env)
      end
      
      def websocket_handler
        @websocket_handler ||= self.class.websocket_handler.new(self, @app, @options)
      end
      
    end
  end
end