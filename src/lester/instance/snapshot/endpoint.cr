struct Lester::Instance::Snapshot::Endpoint
  include Lester::Endpoint

  def list(instance_name, **params)
    yield list(instance_name, **params)
  end

  def list(instance_name : String, **params) : List
    base_path = uri(instance_name).path
    params = URI::Params.encode(client.recurse **params)
    response = client.get("#{base_path}?#{params}")

    List.from_json(response.body)
  end

  def create(instance_name, project = nil, **params)
    yield create(instance_name, project, **params)
  end

  def create(
    instance_name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(instance_name).path

    response = client.post(
      "#{base_path}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def delete(instance_name, name, project = nil)
    yield delete(instance_name, name, project)
  end

  def delete(
    instance_name : String,
    name : String,
    project : String? = nil
  ) : Operation::Item
    base_path = uri(instance_name).path
    response = client.delete("#{base_path}/#{name}?project=#{project}")

    Operation::Item.from_json(response.body)
  end

  def fetch(instance_name, name, **params)
    yield fetch(instance_name, name, **params)
  end

  def fetch(instance_name : String, name : String, **params) : Item
    base_path = uri(instance_name).path
    params = URI::Params.encode(params)
    response = client.get("#{base_path}/#{name}?#{params}")

    Item.from_json(response.body)
  end

  def update(instance_name, name, project = nil, **params)
    yield update(instance_name, name, project, **params)
  end

  def update(
    instance_name : String,
    name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(instance_name).path

    response = client.patch(
      "#{base_path}/#{name}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def rename(instance_name, name, new_name, project = nil, **params)
    yield rename(instance_name, name, new_name, project, **params)
  end

  def rename(
    instance_name : String,
    name : String,
    new_name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(instance_name).path
    params = params.merge({name: new_name})

    response = client.post(
      "#{base_path}/#{name}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def replace(instance_name, name, project = nil, **params)
    yield replace(instance_name, name, project, **params)
  end

  def replace(
    instance_name : String,
    name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(instance_name).path

    response = client.put(
      "#{base_path}/#{name}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def uri(instance_name) : URI
    uri = URI.parse(client.instances.uri.to_s)
    uri.path += "/#{instance_name}/snapshots"
    uri
  end
end
