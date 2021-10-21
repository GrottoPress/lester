struct Lester::Cluster::Certificate::Endpoint
  include Hapi::Endpoint

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
    uri.path += "/cluster/certificate"
    uri
  end
end
