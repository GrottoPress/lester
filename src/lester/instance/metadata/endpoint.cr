struct Lester::Instance::Metadata::Endpoint
  include Lester::Endpoint

  def fetch(instance_name, **params)
    yield fetch(instance_name, **params)
  end

  def fetch(instance_name : String, **params) : Item
    base_path = uri(instance_name).path
    params = URI::Params.encode(params)
    response = @client.get("#{base_path}?#{params}")

    Item.from_json(response.body)
  end

  def update(instance_name, project = nil, **params)
    yield update(instance_name, project, **params)
  end

  def update(
    instance_name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(instance_name).path

    response = @client.patch(
      "#{base_path}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def replace(instance_name, project = nil, **params)
    yield replace(instance_name, project, **params)
  end

  def replace(
    instance_name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(instance_name).path

    response = @client.put(
      "#{base_path}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def uri(instance_name) : URI
    uri = URI.parse(@client.instances.uri.to_s)
    uri.path += "/#{instance_name}/metadata"
    uri
  end
end
