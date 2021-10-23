struct Lester::Volume::Backup::Endpoint
  include Hapi::Endpoint

  def list(pool_name, volume_name, volume_type, **params)
    yield list(pool_name, volume_name, volume_type, **params)
  end

  def list(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    **params
  ) : List
    base_path = uri(pool_name, volume_name, volume_type).path
    params = URI::Params.encode(@client.recurse **params)

    @client.get("#{base_path}?#{params}") do |response|
      List.from_json(response.body_io)
    end
  end

  def create(
    pool_name,
    volume_name,
    volume_type,
    project = nil,
    target = nil,
    **params
  )
    yield create(pool_name, volume_name, volume_type, project, target, **params)
  end

  def create(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    project : String? = nil,
    target : String? = nil,
    **params
  ) : Operation::Item
    base_path = uri(pool_name, volume_name, volume_type).path

    @client.post(
      "#{base_path}?project=#{project}&target=#{target}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def delete(
    pool_name,
    volume_name,
    volume_type,
    name,
    project = nil,
    target = nil
  )
    yield delete(pool_name, volume_name, volume_type, name, project, target)
  end

  def delete(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    name : String,
    project : String? = nil,
    target : String? = nil
  ) : Operation::Item
    base_path = uri(pool_name, volume_name, volume_type).path

    @client.delete(
      "#{base_path}/#{name}?project=#{project}&target=#{target}"
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(pool_name, volume_name, volume_type, name, **params)
    yield fetch(pool_name, volume_name, volume_type, name, **params)
  end

  def fetch(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    name : String,
    **params
  ) : Item
    base_path = uri(pool_name, volume_name, volume_type).path
    params = URI::Params.encode(params)

    @client.get("#{base_path}/#{name}?#{params}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def rename(
    pool_name,
    volume_name,
    volume_type,
    name,
    new_name,
    project = nil,
    target = nil
  )
    yield rename(
      pool_name,
      volume_name,
      volume_type,
      name,
      new_name,
      project,
      target
    )
  end

  def rename(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    name : String,
    new_name : String,
    project : String? = nil,
    target : String? = nil
  ) : Operation::Item
    base_path = uri(pool_name, volume_name, volume_type).path
    params = {name: new_name}

    @client.post(
      "#{base_path}/#{name}?project=#{project}&target=#{target}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def export(pool_name, volume_name, volume_type, name, destination, **params)
    yield export(
      pool_name,
      volume_name,
      volume_type,
      name,
      destination,
      **params
    )
  end

  def export(
    pool_name : String,
    volume_name : String,
    volume_type : String,
    name : String,
    destination,
    **params
  ) : Operation::Item
    base_path = uri(pool_name, volume_name, volume_type).path
    params = URI::Params.encode(params)

    @client.get("#{base_path}/#{name}/export?#{params}") do |response|
      unless response.status.success?
        return Operation::Item.from_json(response.body_io)
      end

      @client.copy(response.body_io, destination)

      Operation::Item.from_json({
        type: "sync",
        status: "Success",
        status_code: 200
      }.to_json)
    end
  end

  def uri(pool_name, volume_name, volume_type) : URI
    uri = @client.uri.dup

    uri.path += "/storage-pools/#{pool_name}/volumes/#{volume_type}/\
      #{volume_name}/backups"

    uri
  end
end
