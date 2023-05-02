struct Lester::Instance::Endpoint
  include Lester::Endpoint

  getter backups : Backup::Endpoint do
    Backup::Endpoint.new(@client)
  end

  getter console : Console::Endpoint do
    Console::Endpoint.new(@client)
  end

  getter files : File::Endpoint do
    File::Endpoint.new(@client)
  end

  getter logs : Log::Endpoint do
    Log::Endpoint.new(@client)
  end

  getter metadata : Metadata::Endpoint do
    Metadata::Endpoint.new(@client)
  end

  getter snapshots : Snapshot::Endpoint do
    Snapshot::Endpoint.new(@client)
  end

  getter state : State::Endpoint do
    State::Endpoint.new(@client)
  end

  getter templates : Template::Endpoint do
    Template::Endpoint.new(@client)
  end

  def list(**params)
    yield list(**params)
  end

  def list(**params) : List
    params = URI::Params.encode(@client.recurse **params)
    response = @client.get("#{uri.path}?#{params}")

    List.from_json(response.body)
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

    response = @client.post(
      "#{uri.path}?project=#{project}&target=#{target}",
      body: body,
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

  def update(name, project = nil, **params)
    yield update(name, project, **params)
  end

  def update(
    name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    response = @client.patch(
      "#{uri.path}/#{name}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
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
    response = @client.post(
      "#{uri.path}/#{name}?project=#{project}",
      body: params.merge({name: new_name}).to_json
    )

    Operation::Item.from_json(response.body)
  end

  def replace(project = nil, **params)
    yield replace(project, **params)
  end

  def replace(project : String? = nil, **params) : Operation::Item
    response = @client.put(
      "#{uri.path}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def replace(name : String, project = nil, **params)
    yield replace(name, project, **params)
  end

  def replace(
    name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    response = @client.put(
      "#{uri.path}/#{name}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def exec(name, project = nil, **params)
    yield exec(name, project, **params)
  end

  def exec(name : String, project : String? = nil, **params) : Operation::Item
    response = @client.post(
      "#{uri.path}/#{name}/exec?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  getter uri : URI do
    uri = URI.parse(@client.uri.to_s)
    uri.path += "/instances"
    uri
  end
end
