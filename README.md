# WebSocket Rack

- [![Build Status](https://travis-ci.org/imanel/websocket-rack.png)](http://travis-ci.org/imanel/websocket-rack)
- [![Dependency Status](https://gemnasium.com/imanel/websocket-rack.png)](http://gemnasium.com/imanel/websocket-rack)
- [![Code Climate](https://codeclimate.com/github/imanel/websocket-rack.png)](https://codeclimate.com/github/imanel/websocket-rack)

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
    puts "Client connected"
  end
end
```

### on_close(env)

Called after client is disconnected. Rack env of client is passed as attribute.

Example:

``` ruby
class MyApp < Rack::WebSocket::Application
  def on_close(env)
    puts "Client disconnected"
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

### Which WebSocket drafts are supported:

Currently we support drafts -75 and -76 form old(hixie) numeration and all drafts from -00 to -13 from current(ietf-hybi) numeration.
Please note that ietf-hybi-13 is currently proposed as final standard.

### Which Rack servers are supported?

Currently we are supporting following servers:

- Thin

### How to enable debugging?

Just use :backend => { :debug => true } option when initializing your app.

### How to enable wss/SSL support?

Thin v1.2.8 has an --ssl option - just use that! :)

### How to use function xxx?

Check [Thin](http://code.macournoyer.com/thin/) config - any option supported by Thin(like demonizing, SSL etc.) is supported by WebSocket-Rack.

## About

Author: Bernard Potocki <bernard.potocki@imanel.org>

Released under MIT license.

## Support

If you like my work then consider supporting me:

[![Donate with Bitcoin](https://en.cryptobadges.io/badge/small/bc1qmxfc703ezscvd4qv0dvp7hwy7vc4kl6currs5e)](https://en.cryptobadges.io/donate/bc1qmxfc703ezscvd4qv0dvp7hwy7vc4kl6currs5e)

[![Donate with Ethereum](https://en.cryptobadges.io/badge/small/0xA7048d5F866e2c3206DC95ebFa988fF987c0BccB)](https://en.cryptobadges.io/donate/0xA7048d5F866e2c3206DC95ebFa988fF987c0BccB)
