struct Lester::Cluster::Certificate::Endpoint
  include Lester::Endpoint

  def replace(**params)
    yield replace(**params)
  end

  def replace(**params) : Operation::Item
    response = client.put(uri.path, body: params.to_json)
    Operation::Item.from_json(response.body)
  end

  def uri : URI
    uri = URI.parse(client.cluster.uri.to_s)
    uri.path += "/certificate"
    uri
  end
end
