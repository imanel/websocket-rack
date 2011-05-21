# WebSocket Rack

Rack-based WebSocket server

## Usage

Create sample rack config file, and inside build app basing on Rack::WebSocket::Application.

``` ruby
require 'rack/websocket'

class MyApp < Rack::WebSocket::Application
end

map '/' do
  run MyApp.new
end
```

After that just run Rack config from Rack server:

``` bash
thin -R config.ru start
```

Done.

## Configuration

Rack::WebSocket::Application make following methods available:

### initialize

Called once after server is started. This is place for application configuration so each instance variables from here will be available in whole application.

Example:

``` ruby
class MyApp < Rack::WebSocket::Application
  def initialize(options = {})
    super
    @myvar = 4
  end
end
```

It is important to include 'super' in initialize function, so application will be properly configured.

Please notice that in some servers, when 'initialize' is called, EventMachine reactor is not running yet. If you would like to configure EventMachine-based software, then you need to put it inside 'EM.next_tick' block, so this function will be called in first cycle of reactor.

Example:

``` ruby
class MyWebSocket < Rack::WebSocket::Application
  def initialize
    EM.next_tick { @redis = EM::Hiredis.connect }
  end
end
```

### on_open(env)

Called after client is connected. Rack env of client is passed as attribute.

Example:

``` ruby
class MyApp < Rack::WebSocket::Application
  def on_open(env)
    puts "Clien connected"
  end
end
```

### on_close(env)

Called after client is disconnected. Rack env of client is passed as attribute.

Example:

``` ruby
class MyApp < Rack::WebSocket::Application
  def on_close(env)
    puts "Clien disconnected"
  end
end
```

### on_message(env, msg)

Called after server receive message. Rack env of client is passed as attribute.

Example:

``` ruby
class MyApp < Rack::WebSocket::Application
  def on_message(env, msg)
    puts "Received message: " + msg
  end
end
```

### on_error(env, error)

Called after server catch error. Variable passed is instance of Ruby Exception class.

Example:

``` ruby
class MyApp < Rack::WebSocket::Application
  def on_error(env, error)
    puts "Error occured: " + error.message
  end
end
```

### send_data(data)

Sends data do client.

Example:

``` ruby
class MyApp < Rack::WebSocket::Application
  def on_open(env)
    send_data "Hello to you!"
  end
end
```

### close_websocket

Closes connection.

Example:

``` ruby
class MyApp < Rack::WebSocket::Application
  def on_open(env)
    close_websocket if env['REQUEST_PATH'] != '/websocket'
  end
end
```

## Available variables:

### @options

Options passed to app on initialize.

Example:

``` ruby
# In config.ru
map '/' do
  run MyApp.new :some => :variable
end

# In application instance
@options # => { :some => :variable }
```

## FAQ

### Which Rack servers are supported?

Currently we are supporting following servers:

- Thin

### How to enable debugging?

Just use :backend => { :debug => true } option when initializing your app.

### How to enable wss/SSL support?

Thin v1.2.8 have --ssl option - just use that! :)

### How to use function xxx?

Check [Thin](http://code.macournoyer.com/thin/) config - any option supported by Thin(like demonizing, SSL etc.) is supported by WebSocket-Rack.

### Why (using Thin) user is disconnected after 30 seconds?

This is bug in EventMachine < 1.0.0. Please consider updating to newer version or use thin-websocket wrapper around thin binary.

## About

Author: Bernard Potocki <<bernard.potocki@imanel.org>>

Released under MIT license.