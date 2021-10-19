struct Lester::Server::Endpoint
  include Hapi::Endpoint

  def fetch(**params)
    yield fetch(**params)
  end

  def fetch(**params) : Item
    params = URI::Params.encode(params)

    @client.get("#{uri.path}?#{params}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def update(target = nil, **params)
    yield update(target, **params)
  end

  def update(target : String? = nil, **params) : Operation::Item
    @client.patch(
      "#{uri.path}?target=#{target}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def replace(target = nil, **params)
    yield replace(target, **params)
  end

  def replace(target : String? = nil, **params) : Operation::Item
    @client.put(
      "#{uri.path}?target=#{target}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def events(**params)
    yield events(**params)
  end

  def events(**params) : HTTP::WebSocket
    params = URI::Params.encode(params)
    headers = HTTP::Headers.new
    uri_path = "#{uri.path}/events?#{params}"

    if websocket = websocket_for_unix_socket(uri_path, headers)
      return websocket
    end

    @client.set_content_type(headers)
    @client.set_user_agent(headers)

    HTTP::WebSocket.new(uri.host.to_s, uri_path, headers: headers, tls: true)
  end

  def resources(**params)
    yield resources(**params)
  end

  def resources(**params) : Resources::Item
    params = URI::Params.encode(params)

    @client.get("#{uri.path}/resources?#{params}") do |response|
      Resources::Item.from_json(response.body_io)
    end
  end

  def uri : URI
    @client.uri
  end

  # Adapted from `HTTP::Websocket::Protocol.new`
  private def websocket_for_unix_socket(uri_path, headers)
    @client.socket.try do |socket|
      key = Random::Secure.base64(16)

      headers["Host"] = "#{@client.host}:#{@client.port}"
      headers["Connection"] = "Upgrade"
      headers["Upgrade"] = "websocket"
      headers["Sec-WebSocket-Version"] = HTTP::WebSocket::Protocol::VERSION
      headers["Sec-WebSocket-Key"] = key

      HTTP::Request.new("GET", uri_path, headers).to_io(socket)
      socket.flush

      response = HTTP::Client::Response.from_io(socket, ignore_body: true)

      unless response.status.switching_protocols?
        raise Socket::Error.new(
          "Handshake got denied. Status code was #{response.status.code}."
        )
      end

      challenge_response = HTTP::WebSocket::Protocol.key_challenge(key)

      unless response.headers["Sec-WebSocket-Accept"]? == challenge_response
        raise Socket::Error.new(
          "Handshake got denied. Server did not verify WebSocket challenge."
        )
      end

      HTTP::WebSocket.new(socket)
    rescue error
      socket.close
      raise error
    end
  end
end
