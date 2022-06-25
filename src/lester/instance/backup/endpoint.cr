struct Lester::Instance::Backup::Endpoint
  include Lester::Endpoint

  def list(instance_name, **params)
    yield list(instance_name, **params)
  end

  def list(instance_name : String, **params) : List
    base_path = uri(instance_name).path
    params = URI::Params.encode(client.recurse **params)
    response = client.get("#{base_path}?#{params}")

    List.from_json(response.body)
  end

  def create(instance_name, project = nil, **params)
    yield create(instance_name, project, **params)
  end

  def create(
    instance_name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(instance_name).path

    response = client.post(
      "#{base_path}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def delete(instance_name, name, project = nil)
    yield delete(instance_name, name, project)
  end

  def delete(
    instance_name : String,
    name : String,
    project : String? = nil
  ) : Operation::Item
    base_path = uri(instance_name).path
    response = client.delete("#{base_path}/#{name}?project=#{project}")

    Operation::Item.from_json(response.body)
  end

  def fetch(instance_name, name, **params)
    yield fetch(instance_name, name, **params)
  end

  def fetch(instance_name : String, name : String, **params) : Item
    base_path = uri(instance_name).path
    params = URI::Params.encode(params)
    response = client.get("#{base_path}/#{name}?#{params}")

    Item.from_json(response.body)
  end

  def rename(instance_name, name, new_name, project = nil)
    yield rename(instance_name, name, new_name, project)
  end

  def rename(
    instance_name : String,
    name : String,
    new_name : String,
    project : String? = nil
  ) : Operation::Item
    base_path = uri(instance_name).path

    response = client.post(
      "#{base_path}/#{name}?project=#{project}",
      body: {name: new_name}.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def export(instance_name, name, destination, **params)
    yield export(instance_name, name, destination, **params)
  end

  def export(
    instance_name : String,
    name : String,
    destination,
    **params
  ) : Operation::Item
    base_path = uri(instance_name).path
    params = URI::Params.encode(params)

    client.get("#{base_path}/#{name}/export?#{params}") do |response|
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

  def uri(instance_name) : URI
    uri = URI.parse(client.instances.uri.to_s)
    uri.path += "/#{instance_name}/backups"
    uri
  end
end
