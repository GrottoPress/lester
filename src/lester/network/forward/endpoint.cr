struct Lester::Network::Forward::Endpoint
  include Hapi::Endpoint

  def list(network_name, **params)
    yield list(network_name, **params)
  end

  def list(network_name : String, **params) : List
    base_path = uri(network_name).path
    params = URI::Params.encode(@client.recurse **params)

    @client.get("#{base_path}?#{params}") do |response|
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

    @client.post(
      "#{base_path}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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

    @client.delete(
      "#{base_path}/#{listen_address}?project=#{project}"
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(network_name, listen_address, **params)
    yield fetch(network_name, listen_address, **params)
  end

  def fetch(network_name : String, listen_address : String, **params) : Item
    base_path = uri(network_name).path
    params = URI::Params.encode(params)

    @client.get("#{base_path}/#{listen_address}?#{params}") do |response|
      Item.from_json(response.body_io)
    end
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

    @client.patch(
      "#{base_path}/#{listen_address}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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

    @client.put(
      "#{base_path}/#{listen_address}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri(network_name) : URI
    uri = @client.uri.dup
    uri.path += "/networks/#{network_name}/forwards"
    uri
  end
end
