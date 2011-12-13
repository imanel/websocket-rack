# Changelog

## 0.3.2 / 2011-12-13

- fix bug that resulted in 'location mismatch' error on Safari and iOS

## 0.3.1 / 2011-07-29

- support for WebSocket drafts 07 and 08

## 0.3.0 / 2011-05-10

- support for WebSocket drafts 05 and 06
- fix tests in Ruby 1.9.2
- better documentation

## 0.2.1 / 2011-04-01

- bugfix: env passed to callbacks should be valid now

## 0.2.0 / 2011-04-01

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
