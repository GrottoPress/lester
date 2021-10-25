struct Lester::Instance::Console::Endpoint
  include Lester::Endpoint

  def connect(instance_name, project = nil, **params)
    yield connect(instance_name, project, **params)
  end

  def connect(
    instance_name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(instance_name).path

    client.post(
      "#{base_path}?project=#{project}",
      body: params.to_json,
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def output(instance_name, destination, **params)
    yield output(instance_name, destination, **params)
  end

  def output(instance_name : String, destination, **params) : Operation::Item
    base_path = uri(instance_name).path
    params = URI::Params.encode(params)

    client.get("#{base_path}?#{params}") do |response|
      unless response.status.success?
        return Operation::Item.from_json(response.body_io)
      end

      client.copy(response.body_io, destination)

      Operation::Item.from_json({
        type: "sync",
        status: "Success",
        status_code: 200
      }.to_json)
    end
  end

  def clear(instance_name, project = nil)
    yield clear(instance_name, project)
  end

  def clear(instance_name : String, project : String? = nil) : Operation::Item
    base_path = uri(instance_name).path

    client.delete("#{base_path}?project=#{project}") do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri(instance_name) : URI
    uri = client.uri.dup
    uri.path += "/instances/#{instance_name}/console"
    uri
  end
end
