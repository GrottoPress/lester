struct Lester::Warning::Endpoint
  include Lester::Endpoint

  def list(**params)
    yield list(**params)
  end

  def list(**params) : List
    params = URI::Params.encode(client.recurse **params)

    client.get("#{uri.path}?#{params}") do |response|
      List.from_json(response.body_io)
    end
  end

  def delete(uuid)
    yield delete(uuid)
  end

  def delete(uuid : String) : Operation::Item
    client.delete("#{uri.path}/#{uuid}") do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(uuid)
    yield fetch(uuid)
  end

  def fetch(uuid : String) : Item
    client.get("#{uri.path}/#{uuid}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def update(uuid, **params)
    yield update(uuid, **params)
  end

  def update(uuid : String, **params) : Operation::Item
    client.patch("#{uri.path}/#{uuid}", body: params.to_json) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def replace(uuid, **params)
    yield replace(uuid, **params)
  end

  def replace(uuid : String, **params) : Operation::Item
    client.put("#{uri.path}/#{uuid}", body: params.to_json) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri : URI
    uri = client.uri.dup
    uri.path += "/warnings"
    uri
  end
end
