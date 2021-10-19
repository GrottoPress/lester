struct Lester::Volume::Endpoint
  include Hapi::Endpoint

  def backups : Backup::Endpoint
    @backups ||= Backup::Endpoint.new(@client)
  end

  def list(pool_name, **params)
    yield list(pool_name, **params)
  end

  def list(pool_name : String, **params) : List
    base_path = uri(pool_name).path
    params = URI::Params.encode(@client.recurse **params)

    @client.get("#{base_path}?#{params}") do |response|
      List.from_json(response.body_io)
    end
  end

  def list(pool_name : String, type, **params)
    yield list(pool_name, type, **params)
  end

  def list(pool_name : String, type : String, **params) : List
    base_path = uri(pool_name).path
    params = URI::Params.encode(@client.recurse **params)

    @client.get("#{base_path}/#{type}?#{params}") do |response|
      List.from_json(response.body_io)
    end
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

    @client.post(
      "#{base_path}?project=#{project}&target=#{target}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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

    @client.post(
      "#{base_path}/#{type}?project=#{project}&target=#{target}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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

    @client.delete(
      "#{base_path}/#{type}/#{name}?project=#{project}&target=#{target}"
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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

    @client.get("#{base_path}/#{type}/#{name}?#{params}") do |response|
      Item.from_json(response.body_io)
    end
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

    @client.patch(
      "#{base_path}/#{type}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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

    @client.post(
      "#{base_path}/#{type}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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

    @client.put(
      "#{base_path}/#{type}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri(pool_name) : URI
    uri = @client.uri.dup
    uri.path += "/storage-pools/#{pool_name}/volumes"
    uri
  end
end
