struct Lester::Cluster::Endpoint
  include Hapi::Endpoint

  def members : Member::Endpoint
    @members ||= Member::Endpoint.new(@client)
  end

  def fetch
    yield fetch
  end

  def fetch : Item
    @client.get(uri.path) do |response|
      Item.from_json(response.body_io)
    end
  end

  def replace(**params)
    yield replace(**params)
  end

  def replace(**params) : Operation::Item
    @client.put(uri.path, body: params.to_json) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri : URI
    uri = @client.uri.dup
    uri.path += "/cluster"
    uri
  end
end
