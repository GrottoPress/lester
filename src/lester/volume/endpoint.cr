struct Lester::Volume::Endpoint
  include Lester::Endpoint

  getter backups : Backup::Endpoint do
    Backup::Endpoint.new(client)
  end

  getter snapshots : Snapshot::Endpoint do
    Snapshot::Endpoint.new(client)
  end

  def list(pool_name, **params)
    yield list(pool_name, **params)
  end

  def list(pool_name : String, **params) : List
    base_path = uri(pool_name).path
    params = URI::Params.encode(client.recurse **params)
    response = client.get("#{base_path}?#{params}")

    List.from_json(response.body)
  end

  def list(pool_name : String, type, **params)
    yield list(pool_name, type, **params)
  end

  def list(pool_name : String, type : String, **params) : List
    base_path = uri(pool_name).path
    params = URI::Params.encode(client.recurse **params)
    response = client.get("#{base_path}/#{type}?#{params}")

    List.from_json(response.body)
  end

  def create(pool_name, project = nil, target = nil, **params)
    yield create(pool_name, project, target, **params)
  end

  def create(
    pool_name : String,
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(pool_name).path

    response = client.post(
      "#{base_path}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def create(pool_name : String, type, project = nil, target = nil, **params)
    yield create(pool_name, type, project, target, **params)
  end

  def create(
    pool_name : String,
    type : String,
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(pool_name).path

    response = client.post(
      "#{base_path}/#{type}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def delete(pool_name, name, type, project = nil, target = nil)
    yield delete(pool_name, name, type, project, target)
  end

  def delete(
    pool_name : String,
    name : String,
    type : String,
    project : String? = nil,
    target : String? = nil
  ) : Operation::Item
    base_path = uri(pool_name).path

    response = client.delete(
      "#{base_path}/#{type}/#{name}?project=#{project}&target=#{target}"
    )

    Operation::Item.from_json(response.body)
  end

  def fetch(pool_name, name, type, **params)
    yield fetch(pool_name, name, type, **params)
  end

  def fetch(
    pool_name : String,
    name : String,
    type : String,
    **params
  ) : Item
    base_path = uri(pool_name).path
    params = URI::Params.encode(params)
    response = client.get("#{base_path}/#{type}/#{name}?#{params}")

    Item.from_json(response.body)
  end

  def update(pool_name, name, type, project = nil, target = nil, **params)
    yield update(pool_name, name, type, project, target, **params)
  end

  def update(
    pool_name : String,
    name : String,
    type : String,
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(pool_name).path

    response = client.patch(
      "#{base_path}/#{type}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def rename(
    pool_name,
    name,
    new_name,
    type,
    project = nil,
    target = nil,
    **params
  )
    yield rename(pool_name, name, new_name, type, project, target, **params)
  end

  def rename(
    pool_name : String,
    name : String,
    new_name : String,
    type : String,
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(pool_name).path
    params = params.merge({name: new_name})

    response = client.post(
      "#{base_path}/#{type}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def replace(pool_name, name, type, project = nil, target = nil, **params)
    yield replace(pool_name, name, type, project, target, **params)
  end

  def replace(
    pool_name : String,
    name : String,
    type : String,
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(pool_name).path

    response = client.put(
      "#{base_path}/#{type}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def state(pool_name, name, type, **params)
    yield state(pool_name, name, type, **params)
  end

  def state(
    pool_name : String,
    name : String,
    type : String,
    **params
  ) : State::Item
    base_path = uri(pool_name).path
    params = URI::Params.encode(params)
    response = client.get("#{base_path}/#{type}/#{name}/state?#{params}")

    State::Item.from_json(response.body)
  end

  def uri(pool_name) : URI
    uri = client.uri.dup
    uri.path += "/storage-pools/#{pool_name}/volumes"
    uri
  end
end
