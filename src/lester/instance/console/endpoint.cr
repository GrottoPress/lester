struct Lester::Instance::Console::Endpoint
  include Hapi::Endpoint

  def connect(instance_name, project = nil, **params)
    yield connect(instance_name, project, **params)
  end

  def connect(
    instance_name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    uri_path = uri(instance_name).path

    @client.post(
      "#{uri_path}?project=#{project}",
      body: params.to_json,
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def output(instance_name, outfile, **params)
    yield output(instance_name, outfile, **params)
  end

  def output(instance_name : String, outfile, **params) : Operation::Item
    uri_path = uri(instance_name).path
    params = URI::Params.encode(params)

    @client.get("#{uri_path}?#{params}") do |response|
      unless response.status.success?
        return Operation::Item.from_json(response.body_io)
      end

      ::File.write(outfile, response.body_io, mode: "wb")

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
    uri_path = uri(instance_name).path

    @client.delete("#{uri_path}?project=#{project}") do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri(instance_name) : URI
    uri = @client.uri.dup
    uri.path += "/instances/#{instance_name}/console"
    uri
  end
end
