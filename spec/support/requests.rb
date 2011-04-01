def new_server_connection
  TCPSocket.new('localhost', TEST_PORT)
end

def flash_policy_request
  "<policy-file-request/>\000"
end

def flash_policy_response
  '<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*" to-ports="*"/></cross-domain-policy>'
end

def spec75_handshake_request
  <<-EOF
GET / HTTP/1.1\r
Upgrade: WebSocket\r
Connection: Upgrade\r
Host: localhost:#{TEST_PORT}\r
Origin: http://localhost:#{TEST_PORT}\r
\r
EOF
end

def spec75_handshake_response
  <<-EOF
HTTP/1.1 101 Web Socket Protocol Handshake\r
Upgrade: WebSocket\r
Connection: Upgrade\r
WebSocket-Origin: http://localhost:#{TEST_PORT}\r
WebSocket-Location: ws://localhost:#{TEST_PORT}/\r
\r
EOF
end

def spec75_message
  "\x00some message\xff"
end

def spec76_handshake_request
  request = <<-EOF
GET / HTTP/1.1\r
Upgrade: WebSocket\r
Connection: Upgrade\r
Host: localhost:#{TEST_PORT}\r
Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Key1: 18x 6]8vM;54 *(5:  {   U1]8  z [  8\r
Sec-WebSocket-Key2: 1_ tx7X d  <  nw  334J702) 7]o}` 0\r
\r
Tm[K T2u
EOF
  request.rstrip
end

def spec76_handshake_response
  response = <<-EOF
HTTP/1.1 101 WebSocket Protocol Handshake\r
Upgrade: WebSocket\r
Connection: Upgrade\r
Sec-WebSocket-Location: ws://localhost:#{TEST_PORT}/\r
Sec-WebSocket-Origin: http://localhost:#{TEST_PORT}\r
\r
fQJ,fN/4F4!~K~MH
EOF
  response.rstrip
end

def spec76_message
  "\x00some message\xff"
end
