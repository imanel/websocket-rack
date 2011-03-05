# WebSocket Rack

Rack-based WebSocket server

## Usage

Create sample rack config file, and inside build app basing on Rack::WebSocket::Application.

    require 'rack/websocket'

    class MyApp < Rack::WebSocket::Application
    end

    map '/' do
      run MyApp
    end

After that just run Rack config from Rack server:

    thin -R config.ru start

Done.

## Configuration

Rack::WebSocket::Application make following methods available:

### on_open

Called after client is connected.

Example:

    class MyApp < Rack::WebSocket::Application
      def on_open
        puts "Clien connected"
      end
    end

### on_close

Called after client is disconnected

Example:

    class MyApp < Rack::WebSocket::Application
      def on_close
        puts "Clien disconnected"
      end
    end

### on_message(msg)

Called after server receive message

Example:

    class MyApp < Rack::WebSocket::Application
      def on_message(msg)
        puts "Received message: " + msg
      end
    end

### on_error(error)

Called after server catch error. Variable passed is instance of Ruby Exception class.

Example:

    class MyApp < Rack::WebSocket::Application
      def on_error(error)
        puts "Error occured: " + error.message
      end
    end

### send_data(data)

Sends data do client.

Example:

    class MyApp < Rack::WebSocket::Application
      def on_open
        send_data "Hello to you!"
      end
    end

## Available variables:

### @env

Rack env - contain all data sent by client when connectind.

### @connection

Thin wrapper between client and EventMachine::Connection


## About

Author: Bernard Potocki <<bernard.potocki@imanel.org>>

Most source taken from [em-websocket](http://github.com/igrigorik/em-websocket)

Released under MIT license.