struct Lester::Instance::Metadata::Endpoint
  include Hapi::Endpoint

  def fetch(instance_name, **params)
    yield fetch(instance_name, **params)
  end

  def fetch(instance_name : String, **params) : Item
    uri_path = uri(instance_name).path
    params = URI::Params.encode(params)

    @client.get("#{uri_path}?#{params}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def update(instance_name, project = nil, **params)
    yield update(instance_name, project, **params)
  end

  def update(
    instance_name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    uri_path = uri(instance_name).path

    @client.patch(
      "#{uri_path}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def replace(instance_name, project = nil, **params)
    yield replace(instance_name, project, **params)
  end

  def replace(
    instance_name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    uri_path = uri(instance_name).path

    @client.put(
      "#{uri_path}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri(instance_name) : URI
    uri = @client.uri.dup
    uri.path += "/instances/#{instance_name}/metadata"
    uri
  end
end
