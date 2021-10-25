struct Lester::Network::Peer::Endpoint
  include Lester::Endpoint

  def list(network_name, **params)
    yield list(network_name, **params)
  end

  def list(network_name : String, **params) : List
    base_path = uri(network_name).path
    params = URI::Params.encode(client.recurse **params)

    client.get("#{base_path}?#{params}") do |response|
      List.from_json(response.body_io)
    end
  end

  def create(network_name, project = nil, **params)
    yield create(network_name, project, **params)
  end

  def create(
    network_name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(network_name).path

    client.post(
      "#{base_path}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def delete(network_name, name, project = nil)
    yield delete(network_name, name, project)
  end

  def delete(
    network_name : String,
    name : String,
    project : String? = nil
  ) : Operation::Item
    base_path = uri(network_name).path

    client.delete(
      "#{base_path}/#{name}?project=#{project}"
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(network_name, name, **params)
    yield fetch(network_name, name, **params)
  end

  def fetch(network_name : String, name : String, **params) : Item
    base_path = uri(network_name).path
    params = URI::Params.encode(params)

    client.get("#{base_path}/#{name}?#{params}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def update(network_name, name, project = nil, **params)
    yield update(network_name, name, project, **params)
  end

  def update(
    network_name : String,
    name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(network_name).path

    client.patch(
      "#{base_path}/#{name}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def replace(network_name, name, project = nil, **params)
    yield replace(network_name, name, project, **params)
  end

  def replace(
    network_name : String,
    name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(network_name).path

    client.put(
      "#{base_path}/#{name}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri(network_name) : URI
    uri = client.uri.dup
    uri.path += "/networks/#{network_name}/peers"
    uri
  end
end
