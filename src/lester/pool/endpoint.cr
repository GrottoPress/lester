struct Lester::Pool::Endpoint
  include Lester::Endpoint

  def list(**params)
    yield list(**params)
  end

  def list(**params) : List
    params = URI::Params.encode(@client.recurse **params)
    response = @client.get("#{uri.path}?#{params}")

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
    response = @client.post(
      "#{uri.path}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def delete(name, project = nil)
    yield delete(name, project)
  end

  def delete(name : String, project : String? = nil) : Operation::Item
    response = @client.delete("#{uri.path}/#{name}?project=#{project}")
    Operation::Item.from_json(response.body)
  end

  def fetch(name, **params)
    yield fetch(name, **params)
  end

  def fetch(name : String, **params) : Item
    params = URI::Params.encode(params)
    response = @client.get("#{uri.path}/#{name}?#{params}")

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
    response = @client.patch(
      "#{uri.path}/#{name}?project=#{project}&target=#{target}",
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
    response = @client.put(
      "#{uri.path}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def resources(name, **params)
    yield resources(name, **params)
  end

  def resources(name : String, **params) : Resources::Item
    params = URI::Params.encode(params)
    response = @client.get("#{uri.path}/#{name}/resources?#{params}")

    Resources::Item.from_json(response.body)
  end

  getter uri : URI do
    uri = URI.parse(@client.uri.to_s)
    uri.path += "/storage-pools"
    uri
  end
end
