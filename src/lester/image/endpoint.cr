struct Lester::Image::Endpoint
  include Lester::Endpoint

  def aliases : Alias::Endpoint
    @aliases ||= Alias::Endpoint.new(client)
  end

  def list(**params)
    yield list(**params)
  end

  def list(**params) : List
    params = URI::Params.encode(client.recurse **params)
    response = client.get("#{uri.path}?#{params}")

    List.from_json(response.body)
  end

  def add(fingerprint = nil, secret = nil, project = nil, file = nil, **params)
    yield add(fingerprint, secret, project, file, **params)
  end

  def add(
    fingerprint : String? = nil,
    secret : String? = nil,
    project : String? = nil,
    file = nil,
    **params
  ) : Operation::Item
    headers = HTTP::Headers.new

    headers["X-LXD-secret"] = secret if secret
    headers["X-LXD-fingerprint"] = fingerprint if fingerprint

    body = file ? File.open(file, "rb") : params.to_json
    uri_path = "#{uri.path}?project=#{project}"
    uri_path += "&public" if secret

    response = client.post(uri_path, body: body, headers: headers)
    Operation::Item.from_json(response.body)
  end

  def delete(fingerprint, project = nil)
    yield delete(fingerprint, project)
  end

  def delete(fingerprint : String, project : String? = nil) : Operation::Item
    response = client.delete("#{uri.path}/#{fingerprint}?project=#{project}")
    Operation::Item.from_json(response.body)
  end

  def fetch(fingerprint, **params)
    yield fetch(fingerprint, **params)
  end

  def fetch(fingerprint : String, **params) : Item
    params = URI::Params.encode(params)
    response = client.get("#{uri.path}/#{fingerprint}?#{params}")

    Item.from_json(response.body)
  end

  def update(fingerprint, project = nil, **params)
    yield update(fingerprint, project, **params)
  end

  def update(
    fingerprint : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    response = client.patch(
      "#{uri.path}/#{fingerprint}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def replace(fingerprint, project = nil, **params)
    yield replace(fingerprint, project, **params)
  end

  def replace(fingerprint : String, project = nil, **params) : Operation::Item
    response = client.put(
      "#{uri.path}/#{fingerprint}?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def export(fingerprint, destination, **params)
    yield export(fingerprint, destination, **params)
  end

  def export(fingerprint : String, destination, **params) : Operation::Item
    params = URI::Params.encode(params)

    client.get("#{uri.path}/#{fingerprint}/export?#{params}") do |response|
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

  def push(fingerprint, project = nil, **params)
    yield push(fingerprint, project, **params)
  end

  def push(
    fingerprint : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    response = client.post(
      "#{uri.path}/#{fingerprint}/export?project=#{project}",
      body: params.to_json
    )

    Operation::Item.from_json(response.body)
  end

  def refresh(fingerprint, project = nil)
    yield refresh(fingerprint, project)
  end

  def refresh(fingerprint : String, project : String? = nil) : Operation::Item
    response = client.post(
      "#{uri.path}/#{fingerprint}/refresh?project=#{project}",
    )

    Operation::Item.from_json(response.body)
  end

  def secret(fingerprint, project = nil)
    yield secret(fingerprint, project)
  end

  def secret(
    fingerprint : String,
    project : String? = nil
  ) : Operation::Item
    response = client.post(
      "#{uri.path}/#{fingerprint}/secret?project=#{project}",
    )

    Operation::Item.from_json(response.body)
  end

  def uri : URI
    uri = client.uri.dup
    uri.path += "/images"
    uri
  end
end
