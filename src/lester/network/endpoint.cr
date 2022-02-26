struct Lester::Network::Endpoint
  include Lester::Endpoint

  def acls : Acl::Endpoint
    @acls ||= Acl::Endpoint.new(client)
  end

  def forwards : Forward::Endpoint
    @forwards ||= Forward::Endpoint.new(client)
  end

  def peers : Peer::Endpoint
    @peers ||= Peer::Endpoint.new(client)
  end

  def list(**params)
    yield list(**params)
  end

  def list(**params) : List
    params = URI::Params.encode(client.recurse **params)
    response = client.get("#{uri.path}?#{params}")

    List.from_json(response.body)
  end

  def create(project = nil, target = nil, **params)
    yield create(project, target, **params)
  end

  def create(
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    response = client.post(
      "#{uri.path}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def delete(name, project = nil)
    yield delete(name, project)
  end

  def delete(name : String, project : String? = nil) : Operation::Item
    response = client.delete("#{uri.path}/#{name}?project=#{project}")
    Operation::Item.from_json(response.body)
  end

  def fetch(name, **params)
    yield fetch(name, **params)
  end

  def fetch(name : String, **params) : Item
    params = URI::Params.encode(params)
    response = client.get("#{uri.path}/#{name}?#{params}")

    Item.from_json(response.body)
  end

  def update(name, project = nil, target = nil, **params)
    yield update(name, project, target, **params)
  end

  def update(
    name : String,
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    response = client.patch(
      "#{uri.path}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def rename(name, new_name, project = nil)
    yield rename(name, new_name, project)
  end

  def rename(
    name : String,
    new_name : String,
    project : String? = nil
  ) : Operation::Item
    params = {name: new_name}

    response = client.post(
      "#{uri.path}/#{name}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def replace(name, project = nil, target = nil, **params)
    yield replace(name, project, target, **params)
  end

  def replace(
    name : String,
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    response = client.put(
      "#{uri.path}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def leases(name, **params)
    yield leases(name, **params)
  end

  def leases(name : String, **params) : Lease::List
    params = URI::Params.encode(params)
    response = client.get("#{uri.path}/#{name}/leases?#{params}")

    Lease::List.from_json(response.body)
  end

  def state(name, **params)
    yield state(name, **params)
  end

  def state(name : String, **params) : State::Item
    params = URI::Params.encode(params)
    response = client.get("#{uri.path}/#{name}/state?#{params}")

    State::Item.from_json(response.body)
  end

  def uri : URI
    uri = client.uri.dup
    uri.path += "/networks"
    uri
  end
end
