struct Lester::Instance::File::Endpoint
  include Lester::Endpoint

  def create(
    instance_name,
    path,
    content,
    user_id = nil,
    group_id = nil,
    permissions = nil,
    type = nil,
    write_mode = nil,
    project = nil
  )
    yield create(
      instance_name,
      path,
      content,
      user_id,
      group_id,
      permissions,
      type,
      write_mode,
      project
    )
  end

  def create(
    instance_name : String,
    path : String,
    content,
    user_id : Int32? = nil,
    group_id : Int32? = nil,
    permissions : Int32? = nil,
    type : Type? = nil,
    write_mode : WriteMode? = nil,
    project : String? = nil
  ) : Operation::Item
    base_path = uri(instance_name).path
    headers = HTTP::Headers.new

    headers["Content-Type"] = "application/octet-stream"
    headers["X-LXD-uid"] = user_id.to_s if user_id
    headers["X-LXD-gid"] = group_id.to_s if group_id
    headers["X-LXD-mode"] = permissions.to_s if permissions
    headers["X-LXD-type"] = type.to_s.downcase if type
    headers["X-LXD-write"] = write_mode.to_s.downcase if write_mode

    client.post(
      "#{base_path}?path=#{path}&project=#{project}",
      body: content,
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

    client.delete("#{base_path}?path=#{path}&project=#{project}") do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(instance_name, path, destination = nil, **params)
    yield fetch(instance_name, path, destination, **params)
  end

  def fetch(
    instance_name : String,
    path : String,
    destination = nil,
    **params
  ) : Item
    base_path = uri(instance_name).path
    params = URI::Params.encode params.merge({path: path})

    client.get("#{base_path}?#{params}") do |response|
      item(response, destination)
    end
  end

  def uri(instance_name) : URI
    uri = client.uri.dup
    uri.path += "/instances/#{instance_name}/files"
    uri
  end

  private def item(response, destination)
    return Item.from_json(response.body_io) unless response.status.success?

    file = {
      group_id: response.headers["X-Lxd-Gid"]?.try(&.to_i),
      permissions: response.headers["X-Lxd-Mode"]?,
      type: response.headers["X-Lxd-Type"]?,
      user_id: response.headers["X-Lxd-Uid"]?.try(&.to_i),
    }

    if file[:type] == "directory"
      body = JSON.parse(response.body_io).as_h
      file = file.merge({content: body["metadata"]?})
      body["metadata"] = JSON.parse(file.to_json)
    else
      client.copy(response.body_io, destination) if destination
      body = {type: "sync", status: "Success", status_code: 200, metadata: file}
    end

    Item.from_json(body.to_json)
  end
end
