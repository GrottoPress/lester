struct Lester::Warning::Endpoint
  include Lester::Endpoint

  def list(**params)
    yield list(**params)
  end

  def list(**params) : List
    params = URI::Params.encode(client.recurse **params)
    response = client.get("#{uri.path}?#{params}")

    List.from_json(response.body)
  end

  def delete(uuid)
    yield delete(uuid)
  end

  def delete(uuid : String) : Operation::Item
    response = client.delete("#{uri.path}/#{uuid}")
    Operation::Item.from_json(response.body)
  end

  def fetch(uuid)
    yield fetch(uuid)
  end

  def fetch(uuid : String) : Item
    response = client.get("#{uri.path}/#{uuid}")
    Item.from_json(response.body)
  end

  def update(uuid, **params)
    yield update(uuid, **params)
  end

  def update(uuid : String, **params) : Operation::Item
    response = client.patch("#{uri.path}/#{uuid}", body: params.to_json)
    Operation::Item.from_json(response.body)
  end

  def replace(uuid, **params)
    yield replace(uuid, **params)
  end

  def replace(uuid : String, **params) : Operation::Item
    response = client.put("#{uri.path}/#{uuid}", body: params.to_json)
    Operation::Item.from_json(response.body)
  end

  getter uri : URI do
    uri = URI.parse(client.uri.to_s)
    uri.path += "/warnings"
    uri
  end
end
