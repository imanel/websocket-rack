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
  "\x00Hello\xff"
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
  "\x00Hello\xff"
end

def spec03_handshake_request
  request = <<-EOF
GET / HTTP/1.1\r
Upgrade: WebSocket\r
Connection: Upgrade\r
Host: localhost:#{TEST_PORT}\r
Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Key1: 18x 6]8vM;54 *(5:  {   U1]8  z [  8\r
Sec-WebSocket-Key2: 1_ tx7X d  <  nw  334J702) 7]o}` 0\r
Sec-WebSocket-Protocol: sample\r
Sec-WebSocket-Draft: 3\r
\r
Tm[K T2u
EOF
  request.rstrip
end

def spec03_handshake_response
  response = <<-EOF
HTTP/1.1 101 WebSocket Protocol Handshake\r
Upgrade: WebSocket\r
Connection: Upgrade\r
Sec-WebSocket-Location: ws://localhost:#{TEST_PORT}/\r
Sec-WebSocket-Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Protocol: sample\r
\r
fQJ,fN/4F4!~K~MH
EOF
  response.rstrip
end

def spec03_message
  "\x04\x05Hello"
end

def spec05_handshake_request
  <<-EOF
GET / HTTP/1.1\r
Upgrade: websocket\r
Connection: Upgrade\r
Host: localhost:#{TEST_PORT}\r
Sec-WebSocket-Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r
Sec-WebSocket-Protocol: sample\r
Sec-WebSocket-Version: 5\r
\r
EOF
end

def spec05_handshake_response
  <<-EOF
HTTP/1.1 101 Switching Protocols\r
Upgrade: websocket\r
Connection: Upgrade\r
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=\r
EOF
end

def spec05_message
  "\x00\x00\x01\x00\x84\x05Ielln"
end

def spec06_handshake_request
  <<-EOF
GET / HTTP/1.1\r
Upgrade: websocket\r
Connection: Upgrade\r
Host: localhost:#{TEST_PORT}\r
Sec-WebSocket-Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r
Sec-WebSocket-Protocol: sample\r
Sec-WebSocket-Version: 6\r
\r
EOF
end

def spec06_handshake_response
  <<-EOF
HTTP/1.1 101 Switching Protocols\r
Upgrade: websocket\r
Connection: Upgrade\r
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=\r
EOF
end

def spec06_message
  "\x00\x00\x01\x00\x84\x05Ielln"
end
