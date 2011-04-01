shared_examples_for 'all drafts' do
  it "should accept incoming connection" do
    conn = new_server_connection
    conn.write(handshake_request)
    conn.read(handshake_response.length).should eql(handshake_response)
  end
  it "should call 'on_open' on new connection" do
    TestApp.any_instance.expects(:on_open)
    conn = new_server_connection
    conn.write(handshake_request)
  end
  it "should call 'on_close' on connection close" do
    TestApp.any_instance.expects(:on_close)
    conn = new_server_connection
    conn.write(handshake_request)
    conn.close
  end
  it "should call 'on_message' on connection sending data" do
    TestApp.any_instance.expects(:on_message).once.with { |env, message| message == 'some message' }
    conn = new_server_connection
    conn.write(handshake_request)
    conn.read(handshake_response.length)
    conn.write(message)
  end
end