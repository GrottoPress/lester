struct Lester::Network::Forward::Endpoint
  include Lester::Endpoint

  def list(network_name, **params)
    yield list(network_name, **params)
  end

  def list(network_name : String, **params) : List
    base_path = uri(network_name).path
    params = URI::Params.encode(client.recurse **params)
    response = client.get("#{base_path}?#{params}")

    List.from_json(response.body)
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

    response = client.post(
      "#{base_path}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def delete(network_name, listen_address, project = nil)
    yield delete(network_name, listen_address, project)
  end

  def delete(
    network_name : String,
    listen_address : String,
    project : String? = nil
  ) : Operation::Item
    base_path = uri(network_name).path

    response = client.delete(
      "#{base_path}/#{listen_address}?project=#{project}"
    )

    Operation::Item.from_json(response.body)
  end

  def fetch(network_name, listen_address, **params)
    yield fetch(network_name, listen_address, **params)
  end

  def fetch(network_name : String, listen_address : String, **params) : Item
    base_path = uri(network_name).path
    params = URI::Params.encode(params)
    response = client.get("#{base_path}/#{listen_address}?#{params}")

    Item.from_json(response.body)
  end

  def update(network_name, listen_address, project = nil, **params)
    yield update(network_name, listen_address, project, **params)
  end

  def update(
    network_name : String,
    listen_address : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(network_name).path

    response = client.patch(
      "#{base_path}/#{listen_address}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def replace(network_name, listen_address, project = nil, **params)
    yield replace(network_name, listen_address, project, **params)
  end

  def replace(
    network_name : String,
    listen_address : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(network_name).path

    response = client.put(
      "#{base_path}/#{listen_address}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def uri(network_name) : URI
    uri = URI.parse(client.networks.uri.to_s)
    uri.path += "/#{network_name}/forwards"
    uri
  end
end
