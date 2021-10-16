struct Lester::Instance::Snapshot::Endpoint
  include Hapi::Endpoint

  def list(instance_name, **params)
    yield list(instance_name, **params)
  end

  def list(instance_name : String, **params) : List
    base_path = uri(instance_name).path
    params = URI::Params.encode(@client.recurse **params)

    @client.get("#{base_path}?#{params}") do |response|
      List.from_json(response.body_io)
    end
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

    @client.post(
      "#{base_path}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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

    @client.delete("#{base_path}/#{name}?project=#{project}") do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(instance_name, name, **params)
    yield fetch(instance_name, name, **params)
  end

  def fetch(instance_name : String, name : String, **params) : Item
    base_path = uri(instance_name).path
    params = URI::Params.encode(params)

    @client.get("#{base_path}/#{name}?#{params}") do |response|
      Item.from_json(response.body_io)
    end
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

    @client.patch(
      "#{base_path}/#{name}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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

    @client.post(
      "#{base_path}/#{name}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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

    @client.put(
      "#{base_path}/#{name}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri(instance_name) : URI
    uri = @client.uri.dup
    uri.path += "/instances/#{instance_name}/snapshots"
    uri
  end
end
