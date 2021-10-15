struct Lester::Instance::Endpoint
  include Hapi::Endpoint

  def backups : Backup::Endpoint
    Backup::Endpoint.new(@client)
  end

  def console : Console::Endpoint
    Console::Endpoint.new(@client)
  end

  def directories : Directory::Endpoint
    Directory::Endpoint.new(@client)
  end

  def files : File::Endpoint
    File::Endpoint.new(@client)
  end

  def logs : Log::Endpoint
    Log::Endpoint.new(@client)
  end

  def list(**params)
    yield list(**params)
  end

  def list(**params) : List
    params = URI::Params.encode(@client.recurse **params)

    @client.get("#{uri.path}?#{params}") do |response|
      List.from_json(response.body_io)
    end
  end

  def create(project = nil, target = nil, backup = nil, **params)
    yield create(project, target, backup, **params)
  end

  def create(
    project : String? = nil,
    target : String? = nil,
    backup = nil,
    **params
  ) : Operation::Item
    body = backup ? ::File.open(backup, "rb") : params.to_json

    @client.post(
      "#{uri.path}?project=#{project}&target=#{target}",
      body: body,
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def delete(name, project = nil)
    yield delete(name, project)
  end

  def delete(name : String, project : String? = nil) : Operation::Item
    @client.delete(
      "#{uri.path}/#{name}?project=#{project}"
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(name, **params)
    yield fetch(name, **params)
  end

  def fetch(name : String, **params) : Item
    params = URI::Params.encode(params)

    @client.get("#{uri.path}/#{name}?#{params}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def update(name, project = nil, **params)
    yield update(name, project, **params)
  end

  def update(
    name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    @client.patch(
      "#{uri.path}/#{name}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def rename(name, new_name, project = nil, **params)
    yield rename(name, new_name, **params)
  end

  def rename(
    name : String,
    new_name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    @client.post(
      "#{uri.path}/#{name}?project=#{project}",
      body: params.merge({name: new_name}).to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def replace(project = nil, **params)
    yield replace(project, **params)
  end

  def replace(project : String? = nil, **params) : Operation::Item
    @client.put(
      "#{uri.path}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def replace(name : String, project = nil, **params)
    yield replace(name, project, **params)
  end

  def replace(
    name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    @client.put(
      "#{uri.path}/#{name}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def exec(name, project = nil, **params)
    yield exec(name, project, **params)
  end

  def exec(name : String, project : String? = nil, **params) : Operation::Item
    @client.post(
      "#{uri.path}/#{name}/exec?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri : URI
    uri = @client.uri.dup
    uri.path += "/instances"
    uri
  end
end
