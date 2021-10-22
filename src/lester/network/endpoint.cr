struct Lester::Network::Endpoint
  include Hapi::Endpoint

  def acls : Acl::Endpoint
    @acls ||= Acl::Endpoint.new(@client)
  end

  def forwards : Forward::Endpoint
    @forwards ||= Forward::Endpoint.new(@client)
  end

  def peers : Peer::Endpoint
    @peers ||= Peer::Endpoint.new(@client)
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

  def create(project = nil, target = nil, **params)
    yield create(project, target, **params)
  end

  def create(
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    @client.post(
      "#{uri.path}?project=#{project}&target=#{target}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def delete(name, project = nil)
    yield delete(name, project)
  end

  def delete(name : String, project : String? = nil) : Operation::Item
    @client.delete("#{uri.path}/#{name}?project=#{project}") do |response|
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

  def update(name, project = nil, target = nil, **params)
    yield update(name, project, target, **params)
  end

  def update(
    name : String,
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    @client.patch(
      "#{uri.path}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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

    @client.post(
      "#{uri.path}/#{name}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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
    @client.put(
      "#{uri.path}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def leases(name, **params)
    yield leases(name, **params)
  end

  def leases(name : String, **params) : Lease::List
    params = URI::Params.encode(params)

    @client.get("#{uri.path}/#{name}/leases?#{params}") do |response|
      Lease::List.from_json(response.body_io)
    end
  end

  def state(name, **params)
    yield state(name, **params)
  end

  def state(name : String, **params) : State::Item
    params = URI::Params.encode(params)

    @client.get("#{uri.path}/#{name}/state?#{params}") do |response|
      State::Item.from_json(response.body_io)
    end
  end

  def uri : URI
    uri = @client.uri.dup
    uri.path += "/networks"
    uri
  end
end
