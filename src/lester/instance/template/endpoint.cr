struct Lester::Instance::Template::Endpoint
  include Lester::Endpoint

  def list(instance_name, **params)
    yield list(instance_name, **params)
  end

  def list(instance_name : String, **params) : List
    base_path = uri(instance_name).path
    params = URI::Params.encode(params)
    response = client.get("#{base_path}?#{params}")

    List.from_json(response.body)
  end

  def create(instance_name, path, content, project = nil)
    yield create(instance_name, path, content, project)
  end

  def create(
    instance_name : String,
    path : String,
    content,
    project : String? = nil
  ) : Operation::Item
    base_path = uri(instance_name).path

    response = client.post(
      "#{base_path}?path=#{path}&project=#{project}",
      body: content
    )

    Operation::Item.from_json(response.body)
  end

  def delete(instance_name, path, project = nil)
    yield delete(instance_name, path, project)
  end

  def delete(
    instance_name : String,
    path : String,
    project : String? = nil
  ) : Operation::Item
    base_path = uri(instance_name).path
    response = client.delete("#{base_path}?path=#{path}&project=#{project}")

    Operation::Item.from_json(response.body)
  end

  def fetch(instance_name, path, destination, **params)
    yield fetch(instance_name, path, destination, **params)
  end

  def fetch(instance_name : String, path : String, destination, **params) : Item
    base_path = uri(instance_name).path
    params = URI::Params.encode params.merge({path: path})

    client.get("#{base_path}?#{params}") do |response|
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
    uri = URI.parse(client.instances.uri.to_s)
    uri.path += "/#{instance_name}/metadata/templates"
    uri
  end
end
