struct Lester::Volume::Snapshot::Endpoint
  include Lester::Endpoint

  def list(pool_name, volume_name, volume_type, **params)
    yield list(pool_name, volume_name, volume_type, **params)
  end

  def list(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    **params
  ) : List
    base_path = uri(pool_name, volume_name, volume_type).path
    params = URI::Params.encode(@client.recurse **params)
    response = @client.get("#{base_path}?#{params}")

    List.from_json(response.body)
  end

  def create(
    pool_name,
    volume_name,
    volume_type,
    project = nil,
    target = nil,
    **params
  )
    yield create(pool_name, volume_name, volume_type, project, target, **params)
  end

  def create(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(pool_name, volume_name, volume_type).path

    response = @client.post(
      "#{base_path}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def delete(
    pool_name,
    volume_name,
    volume_type,
    name,
    project = nil,
    target = nil
  )
    yield delete(pool_name, volume_name, volume_type, name, project, target)
  end

  def delete(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    name : String,
    project : String? = nil,
    target : String? = nil
  ) : Operation::Item
    base_path = uri(pool_name, volume_name, volume_type).path

    response = @client.delete(
      "#{base_path}/#{name}?project=#{project}&target=#{target}"
    )

    Operation::Item.from_json(response.body)
  end

  def fetch(pool_name, volume_name, volume_type, name, **params)
    yield fetch(pool_name, volume_name, volume_type, name, **params)
  end

  def fetch(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    name : String,
    **params
  ) : Item
    base_path = uri(pool_name, volume_name, volume_type).path
    params = URI::Params.encode(params)
    response = @client.get("#{base_path}/#{name}?#{params}")

    Item.from_json(response.body)
  end

  def update(
    pool_name,
    volume_name,
    volume_type,
    name,
    project = nil,
    target = nil,
    **params
  )
    yield update(
      pool_name,
      volume_name,
      volume_type,
      name,
      project,
      target,
      **params
    )
  end

  def update(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    name : String,
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(pool_name, volume_name, volume_type).path

    response = @client.patch(
      "#{base_path}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def rename(
    pool_name,
    volume_name,
    volume_type,
    name,
    new_name,
    project = nil,
    target = nil
  )
    yield rename(
      pool_name,
      volume_name,
      volume_type,
      name,
      new_name,
      project,
      target
    )
  end

  def rename(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    name : String,
    new_name : String,
    project : String? = nil,
    target : String? = nil
  ) : Operation::Item
    base_path = uri(pool_name, volume_name, volume_type).path
    params = {name: new_name}

    response = @client.post(
      "#{base_path}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def replace(
    pool_name,
    volume_name,
    volume_type,
    name,
    project = nil,
    target = nil,
    **params
  )
    yield replace(
      pool_name,
      volume_name,
      volume_type,
      name,
      project,
      target,
      **params
    )
  end

  def replace(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    name : String,
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(pool_name, volume_name, volume_type).path

    response = @client.put(
      "#{base_path}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def uri(pool_name, volume_name, volume_type) : URI
    uri = URI.parse @client.volumes.uri(pool_name).to_s
    uri.path += "/#{volume_type}/#{volume_name}/snapshots"
    uri
  end
end
