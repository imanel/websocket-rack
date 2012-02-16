require 'timeout'
shared_examples_for 'all drafts' do
  it "should accept incoming connection" do
    conn = new_server_connection
    conn.write(handshake_request)
    timeout(1) { conn.read(handshake_response.length).should eql(handshake_response) }
  end
  it "should call 'on_open' on new connection" do
    TestApp.any_instance.expects(:on_open)
    conn = new_server_connection
    conn.write(handshake_request)
  end
  it "should call 'on_open' on new connection with proper env" do
    TestApp.any_instance.expects(:on_open).once.with { |env| env.class == Hash && !env.keys.empty? }
    conn = new_server_connection
    conn.write(handshake_request)
  end
  it "should call 'on_close' on connection close" do
    TestApp.any_instance.expects(:on_close)
    conn = new_server_connection
    conn.write(handshake_request)
    conn.close
  end
  it "should call 'on_close' on connection close with proper env" do
    TestApp.any_instance.expects(:on_close).once.with { |env| env.class == Hash && !env.keys.empty? }
    conn = new_server_connection
    conn.write(handshake_request)
    conn.close
  end
  it "should call 'on_message' on connection sending data" do
    TestApp.any_instance.expects(:on_message)
    conn = new_server_connection
    conn.write(handshake_request)
    timeout(1) { conn.read(handshake_response.length) }
    conn.write(message)
  end
  it "should call 'on_message' on connection sending data with proper env and message" do
    TestApp.any_instance.expects(:on_message).once.with { |env, message| env.class == Hash && !env.keys.empty? && message == 'Hello' }
    conn = new_server_connection
    conn.write(handshake_request)
    timeout(1) { conn.read(handshake_response.length) }
    conn.write(message)
  end
end
