struct Lester::Instance::Log::Endpoint
  include Lester::Endpoint

  def list(instance_name, **params)
    yield list(instance_name, **params)
  end

  def list(instance_name : String, **params) : List
    base_path = uri(instance_name).path
    params = URI::Params.encode(params)

    client.get("#{base_path}?#{params}") do |response|
      List.from_json(response.body_io)
    end
  end

  def delete(instance_name, filename, project = nil)
    yield delete(instance_name, filename, project)
  end

  def delete(
    instance_name : String,
    filename : String,
    project : String? = nil
  ) : Operation::Item
    base_path = uri(instance_name).path

    client.delete("#{base_path}/#{filename}?project=#{project}") do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(instance_name, filename, destination, **params)
    yield fetch(instance_name, filename, destination, **params)
  end

  def fetch(
    instance_name : String,
    filename : String,
    destination,
    **params
  ) : Item
    base_path = uri(instance_name).path
    params = URI::Params.encode(params)

    client.get("#{base_path}/#{filename}?#{params}") do |response|
      return Item.from_json(response.body_io) unless response.status.success?

      client.copy(response.body_io, destination)

      Item.from_json({
        type: "sync",
        status: "Success",
        status_code: 200
      }.to_json)
    end
  end

  def uri(instance_name) : URI
    uri = client.uri.dup
    uri.path += "/instances/#{instance_name}/logs"
    uri
  end
end
