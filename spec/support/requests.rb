def flash_policy_request
  "<policy-file-request/>\000"
end

def flash_policy_response
  '<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*" to-ports="*"/></cross-domain-policy>'
end

def spec75_handshake_request
  <<-EOF
GET /demo HTTP/1.1\r
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
WebSocket-Location: ws://localhost:#{TEST_PORT}/demo\r
\r
EOF
end

def spec75_message
  "\x00Hello\xff"
end

def spec76_handshake_request
  request = <<-EOF
GET /demo HTTP/1.1\r
Host: localhost:#{TEST_PORT}\r
Connection: Upgrade\r
Sec-WebSocket-Key2: 12998 5 Y3 1  .P00\r
Sec-WebSocket-Protocol: sample\r
Upgrade: WebSocket\r
Sec-WebSocket-Key1: 4 @1  46546xW%0l 1 5\r
Origin: http://localhost:#{TEST_PORT}\r
\r
^n:ds[4U
EOF
  request.rstrip
end

def spec76_handshake_response
  response = <<-EOF
HTTP/1.1 101 WebSocket Protocol Handshake\r
Upgrade: WebSocket\r
Connection: Upgrade\r
Sec-WebSocket-Location: ws://localhost:#{TEST_PORT}/demo\r
Sec-WebSocket-Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Protocol: sample\r
\r
8jKS'y:G*Co,Wxa-
EOF
  response.rstrip
end

def spec76_message
  "\x00Hello\xff"
end

def spec03_handshake_request
  request = <<-EOF
GET /demo HTTP/1.1\r
Host: localhost:#{TEST_PORT}\r
Connection: Upgrade\r
Sec-WebSocket-Key2: 12998 5 Y3 1  .P00\r
Sec-WebSocket-Protocol: sample\r
Upgrade: WebSocket\r
Sec-WebSocket-Key1: 4 @1  46546xW%0l 1 5\r
Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Draft: 3\r
\r
^n:ds[4U
EOF
  request.rstrip
end

def spec03_handshake_response
  response = <<-EOF
HTTP/1.1 101 WebSocket Protocol Handshake\r
Upgrade: WebSocket\r
Connection: Upgrade\r
Sec-WebSocket-Location: ws://localhost:#{TEST_PORT}/demo\r
Sec-WebSocket-Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Protocol: sample\r
\r
8jKS'y:G*Co,Wxa-
EOF
  response.rstrip
end

def spec03_message
  "\x04\x05Hello"
end

def spec05_handshake_request
  <<-EOF
GET /chat HTTP/1.1\r
Host: localhost:#{TEST_PORT}\r
Upgrade: websocket\r
Connection: Upgrade\r
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r
Sec-WebSocket-Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Protocol: chat, superchat\r
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
GET /chat HTTP/1.1\r
Host: localhost:#{TEST_PORT}\r
Upgrade: websocket\r
Connection: Upgrade\r
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r
Sec-WebSocket-Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Protocol: chat, superchat\r
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

def spec07_handshake_request
  <<-EOF
GET /chat HTTP/1.1\r
Host: localhost:#{TEST_PORT}\r
Upgrade: websocket\r
Connection: Upgrade\r
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r
Sec-WebSocket-Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Protocol: chat, superchat\r
Sec-WebSocket-Version: 7\r
\r
EOF
end

def spec07_handshake_response
  <<-EOF
HTTP/1.1 101 Switching Protocols\r
Upgrade: websocket\r
Connection: Upgrade\r
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=\r
EOF
end

def spec07_unmasked_message
  "\x81\x05\x48\x65\x6c\x6c\x6f"
end

def spec07_masked_message
  "\x81\x85\x37\xfa\x21\x3d\x7f\x9f\x4d\x51\x58"
end

def spec08_handshake_request
  <<-EOF
GET /chat HTTP/1.1\r
Host: localhost:#{TEST_PORT}\r
Upgrade: websocket\r
Connection: Upgrade\r
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r
Sec-WebSocket-Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Protocol: chat, superchat\r
Sec-WebSocket-Version: 8\r
\r
EOF
end

def spec08_handshake_response
  <<-EOF
HTTP/1.1 101 Switching Protocols\r
Upgrade: websocket\r
Connection: Upgrade\r
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=\r
EOF
end

def spec08_unmasked_message
  "\x81\x05\x48\x65\x6c\x6c\x6f"
end

def spec08_masked_message
  "\x81\x85\x37\xfa\x21\x3d\x7f\x9f\x4d\x51\x58"
end

def spec13_handshake_request
  <<-EOF
GET /chat HTTP/1.1\r
Host: localhost:#{TEST_PORT}\r
Upgrade: websocket\r
Connection: Upgrade\r
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r
Origin: http://localhost:#{TEST_PORT}\r
Sec-WebSocket-Protocol: chat, superchat\r
Sec-WebSocket-Version: 13\r
\r
EOF
end

def spec13_handshake_response
  <<-EOF
HTTP/1.1 101 Switching Protocols\r
Upgrade: websocket\r
Connection: Upgrade\r
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=\r
EOF
end

def spec13_unmasked_message
  "\x81\x05\x48\x65\x6c\x6c\x6f"
end

def spec13_masked_message
  "\x81\x85\x37\xfa\x21\x3d\x7f\x9f\x4d\x51\x58"
end
