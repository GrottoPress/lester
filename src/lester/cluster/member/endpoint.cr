struct Lester::Cluster::Member::Endpoint
  include Lester::Endpoint

  def list
    yield list
  end

  def list : List
    params = URI::Params.encode(@client.recurse)
    response = @client.get("#{uri.path}?#{params}")

    List.from_json(response.body)
  end

  def add(**params)
    yield add(**params)
  end

  def add(**params) : Operation::Item
    response = @client.post(uri.path, body: params.to_json)
    Operation::Item.from_json(response.body)
  end

  def delete(name)
    yield delete(name)
  end

  def delete(name : String) : Operation::Item
    response = @client.delete("#{uri.path}/#{name}")
    Operation::Item.from_json(response.body)
  end

  def fetch(name)
    yield fetch(name)
  end

  def fetch(name : String) : Item
    response = @client.get("#{uri.path}/#{name}")
    Item.from_json(response.body)
  end

  def update(name, **params)
    yield update(name, **params)
  end

  def update(name : String, **params) : Operation::Item
    response = @client.patch("#{uri.path}/#{name}", body: params.to_json)
    Operation::Item.from_json(response.body)
  end

  def rename(name, new_name)
    yield rename(name, new_name)
  end

  def rename(name : String, new_name : String) : Operation::Item
    params = {server_name: new_name}
    response = @client.post("#{uri.path}/#{name}", body: params.to_json)

    Operation::Item.from_json(response.body)
  end

  def replace(name, **params)
    yield replace(name, **params)
  end

  def replace(name : String, **params) : Operation::Item
    response = @client.put("#{uri.path}/#{name}", body: params.to_json)
    Operation::Item.from_json(response.body)
  end

  def state(name, **params)
    yield state(name, **params)
  end

  def state(name : String, **params) : Operation::Item
    response = @client.post("#{uri.path}/#{name}/state", body: params.to_json)
    Operation::Item.from_json(response.body)
  end

  getter uri : URI do
    uri = URI.parse(@client.cluster.uri.to_s)
    uri.path += "/members"
    uri
  end
end
