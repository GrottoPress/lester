struct Lester::Network::Acl::Endpoint
  include Lester::Endpoint

  def list(**params)
    yield list(**params)
  end

  def list(**params) : List
    params = URI::Params.encode(client.recurse **params)
    response = client.get("#{uri.path}?#{params}")

    List.from_json(response.body)
  end

  def create(project = nil, **params)
    yield create(project, **params)
  end

  def create(project : String? = nil, **params) : Operation::Item
    response = client.post(
      "#{uri.path}?project=#{project}",
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

  def update(name, project = nil, **params)
    yield update(name, project, **params)
  end

  def update(
    name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    response = client.patch(
      "#{uri.path}/#{name}?project=#{project}",
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

  def replace(name, project = nil, **params)
    yield replace(name, project, **params)
  end

  def replace(
    name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    response = client.put(
      "#{uri.path}/#{name}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def uri : URI
    uri = client.uri.dup
    uri.path += "/network-acls"
    uri
  end
end
