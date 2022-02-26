struct Lester::Cluster::Endpoint
  include Lester::Endpoint

  def certificate : Certificate::Endpoint
    @certificate ||= Certificate::Endpoint.new(client)
  end

  def members : Member::Endpoint
    @members ||= Member::Endpoint.new(client)
  end

  def fetch
    yield fetch
  end

  def fetch : Item
    response = client.get(uri.path)
    Item.from_json(response.body)
  end

  def replace(**params)
    yield replace(**params)
  end

  def replace(**params) : Operation::Item
    response = client.put(uri.path, body: params.to_json)
    Operation::Item.from_json(response.body)
  end

  def uri : URI
    uri = client.uri.dup
    uri.path += "/cluster"
    uri
  end
end
