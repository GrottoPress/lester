struct Lester::Instance::Backup::Endpoint
  include Hapi::Endpoint

  def list(instance_name, **params)
    yield list(instance_name, **params)
  end

  def list(instance_name : String, **params) : List
    params = @client.recurse(**params)

    @client.get(
      "#{uri(instance_name).path}?#{URI::Params.encode(params)}"
    ) do |response|
      List.from_json(response.body_io)
    end
  end

  def create(instance_name, project = nil, **params)
    yield create(instance_name, project, **params)
  end

  def create(
    instance_name : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    @client.post(
      "#{uri(instance_name).path}?project=#{project}",
      body: params.to_json,
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def delete(instance_name, name, project = nil)
    yield delete(instance_name, name, project)
  end

  def delete(
    instance_name : String,
    name : String,
    project : String? = nil
  ) : Operation::Item
    @client.delete(
      "#{uri(instance_name).path}/#{name}?project=#{project}"
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(instance_name, name, **params)
    yield fetch(instance_name, name, **params)
  end

  def fetch(instance_name : String, name : String, **params) : Item
    @client.get(
      "#{uri(instance_name).path}/#{name}?#{URI::Params.encode(params)}"
    ) do |response|
      Item.from_json(response.body_io)
    end
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
    @client.post(
      "#{uri(instance_name).path}/#{name}?project=#{project}",
      body: {name: new_name}.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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
    @client.get(
      "#{uri(instance_name).path}/#{name}/export?#{URI::Params.encode(params)}"
    ) do |response|
      unless response.status.success?
        return Operation::Item.from_json(response.body_io)
      end

      File.write(destination, response.body_io, mode: "wb")

      Operation::Item.from_json({
        type: "sync",
        status: "Success",
        status_code: 200
      }.to_json)
    end
  end

  def uri(instance_name) : URI
    uri = @client.uri.dup
    uri.path += "/instances/#{instance_name}/backups"
    uri
  end
end
