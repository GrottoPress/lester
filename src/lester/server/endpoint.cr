struct Lester::Server::Endpoint
  include Lester::Endpoint

  def fetch(**params)
    yield fetch(**params)
  end

  def fetch(**params) : Item
    params = URI::Params.encode(params)
    response = @client.get("#{uri.path}?#{params}")

    Item.from_json(response.body)
  end

  def update(target = nil, **params)
    yield update(target, **params)
  end

  def update(target : String? = nil, **params) : Operation::Item
    response = @client.patch(
      "#{uri.path}?target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def replace(target = nil, **params)
    yield replace(target, **params)
  end

  def replace(target : String? = nil, **params) : Operation::Item
    response = @client.put(
      "#{uri.path}?target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def events(**params)
    yield events(**params)
  end

  def events(**params) : HTTP::WebSocket
    params = URI::Params.encode(params)

    uri = URI.parse(self.uri.to_s)
    uri.path += "/events?#{params}"

    @client.websocket(uri)
  end

  def resources(**params)
    yield resources(**params)
  end

  def resources(**params) : Resources::Item
    params = URI::Params.encode(params)
    response = @client.get("#{uri.path}/resources?#{params}")

    Resources::Item.from_json(response.body)
  end

  getter uri : URI do
    URI.parse(@client.uri.to_s)
  end
end
