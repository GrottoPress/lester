struct Lester::Instance::Directory::Endpoint
  include Hapi::Endpoint

  def create(
    instance_name,
    path,
    user_id = nil,
    group_id = nil,
    permissions = nil,
    write_mode = nil,
    project = nil
  )
    yield create(
      instance_name,
      path,
      user_id,
      group_id,
      permissions,
      write_mode,
      project
    )
  end

  def create(
    instance_name : String,
    path : String,
    user_id : Int32? = nil,
    group_id : Int32? = nil,
    permissions : Int32? = nil,
    write_mode : File::WriteMode? = nil,
    project : String? = nil
  ) : Operation::Item
    base_path = uri(instance_name).path

    headers = HTTP::Headers.new

    headers["X-LXD-uid"] = user_id.to_s if user_id
    headers["X-LXD-gid"] = group_id.to_s if group_id
    headers["X-LXD-mode"] = permissions.to_s if permissions
    headers["X-LXD-type"] = "directory"
    headers["X-LXD-write"] = write_mode.to_s.downcase if write_mode

    @client.post(
      "#{base_path}?path=#{path}&project=#{project}",
      headers: headers
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
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

    @client.delete("#{base_path}?path=#{path}&project=#{project}") do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(instance_name, path, **params)
    yield fetch(instance_name, path, **params)
  end

  def fetch(instance_name : String, path : String, **params) : Item
    base_path = uri(instance_name).path
    params = URI::Params.encode params.merge({path: path})

    @client.get("#{base_path}?#{params}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def uri(instance_name) : URI
    uri = @client.uri.dup
    uri.path += "/instances/#{instance_name}/files"
    uri
  end
end
