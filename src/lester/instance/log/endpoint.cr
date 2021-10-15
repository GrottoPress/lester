struct Lester::Instance::Log::Endpoint
  include Hapi::Endpoint

  def list(instance_name, **params)
    yield list(instance_name, **params)
  end

  def list(instance_name : String, **params) : List
    @client.get(
      "#{uri(instance_name).path}?#{URI::Params.encode(params)}"
    ) do |response|
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
    @client.delete(
      "#{uri(instance_name).path}/#{filename}?project=#{project}"
    ) do |response|
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
    @client.get(
      "#{uri(instance_name).path}/#{filename}?#{URI::Params.encode(params)}"
    ) do |response|
      return Item.from_json(response.body_io) unless response.status.success?

      ::File.write(destination, response.body_io, mode: "wb")

      Item.from_json({
        type: "sync",
        status: "Success",
        status_code: 200
      }.to_json)
    end
  end

  def uri(instance_name) : URI
    uri = @client.uri.dup
    uri.path += "/instances/#{instance_name}/logs"
    uri
  end
end
