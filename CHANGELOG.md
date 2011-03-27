# Changelog

## Edge

- prepare for supporting server other that thin
- small changes of API
- change handling backend options
- depend on em-websocket instead of copying source

## 0.1.4 / 2011-03-13

- performance improvements thanks to rbtrace

## 0.1.3 / 2011-03-12

- fixed critical bug that duplicated instance variables

## 0.1.2 / 2011-03-08

- change Rack::WebSocket::Application @connection variable name to @conn - first one is to often used to block it
- allow debugging of WebSocket connection

## 0.1.1 / 2011-03-07

- add missing gem dependencies
- clear connection inactivity timeout for WebSocket connections
- inform about bug in EM < 1.0.0
- add thin-websocket wrapper around thin binary

## 0.1.0 / 2011-03-05

- initial release
