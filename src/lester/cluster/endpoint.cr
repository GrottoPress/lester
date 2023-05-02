struct Lester::Cluster::Endpoint
  include Lester::Endpoint

  getter certificate : Certificate::Endpoint do
    Certificate::Endpoint.new(@client)
  end

  getter members : Member::Endpoint do
    Member::Endpoint.new(@client)
  end

  def fetch
    yield fetch
  end

  def fetch : Item
    response = @client.get(uri.path)
    Item.from_json(response.body)
  end

  def replace(**params)
    yield replace(**params)
  end

  def replace(**params) : Operation::Item
    response = @client.put(uri.path, body: params.to_json)
    Operation::Item.from_json(response.body)
  end

  getter uri : URI do
    uri = URI.parse(@client.uri.to_s)
    uri.path += "/cluster"
    uri
  end
end
