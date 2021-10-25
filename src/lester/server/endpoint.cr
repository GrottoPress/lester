struct Lester::Server::Endpoint
  include Lester::Endpoint

  def fetch(**params)
    yield fetch(**params)
  end

  def fetch(**params) : Item
    params = URI::Params.encode(params)

    client.get("#{uri.path}?#{params}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def update(target = nil, **params)
    yield update(target, **params)
  end

  def update(target : String? = nil, **params) : Operation::Item
    client.patch(
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
    client.put(
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

    uri = self.uri.dup
    uri.path += "/events?#{params}"

    client.websocket(uri)
  end

  def resources(**params)
    yield resources(**params)
  end

  def resources(**params) : Resources::Item
    params = URI::Params.encode(params)

    client.get("#{uri.path}/resources?#{params}") do |response|
      Resources::Item.from_json(response.body_io)
    end
  end

  def uri : URI
    client.uri
  end
end
