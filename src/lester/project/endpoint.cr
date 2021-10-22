struct Lester::Project::Endpoint
  include Hapi::Endpoint

  def list
    yield list
  end

  def list : List
    params = URI::Params.encode(@client.recurse)

    @client.get("#{uri.path}?#{params}") do |response|
      List.from_json(response.body_io)
    end
  end

  def create(**params)
    yield create(**params)
  end

  def create(**params) : Operation::Item
    @client.post(uri.path, body: params.to_json) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def delete(name)
    yield delete(name)
  end

  def delete(name : String) : Operation::Item
    @client.delete("#{uri.path}/#{name}") do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(name)
    yield fetch(name)
  end

  def fetch(name : String) : Item
    @client.get("#{uri.path}/#{name}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def update(name, **params)
    yield update(name, **params)
  end

  def update(name : String, **params) : Operation::Item
    @client.patch("#{uri.path}/#{name}", body: params.to_json) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def rename(name, new_name)
    yield rename(name, new_name)
  end

  def rename(name : String, new_name : String) : Operation::Item
    params = {name: new_name}

    @client.post("#{uri.path}/#{name}", body: params.to_json) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def replace(name, **params)
    yield replace(name, **params)
  end

  def replace(name : String, **params) : Operation::Item
    @client.put("#{uri.path}/#{name}", body: params.to_json) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def state(name)
    yield state(name)
  end

  def state(name : String) : State::Item
    @client.get("#{uri.path}/#{name}/state") do |response|
      State::Item.from_json(response.body_io)
    end
  end

  def uri : URI
    uri = @client.uri.dup
    uri.path += "/projects"
    uri
  end
end
