shared_examples_for 'draft with masked messages' do
  it "should call 'on_message' on connection sending masked data with proper env and message" do
    TestApp.any_instance.expects(:on_message).once.with { |env, message| env.class == Hash && !env.keys.empty? && message == 'Hello' }
    conn = new_server_connection
    conn.write(handshake_request)
    conn.read(handshake_response.length)
    conn.write(masked_message)
  end
end