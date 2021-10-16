struct Lester::Image::Endpoint
  include Hapi::Endpoint

  def aliases : Alias::Endpoint
    @aliases ||= Alias::Endpoint.new(@client)
  end

  def list(**params)
    yield list(**params)
  end

  def list(**params) : List
    params = URI::Params.encode(@client.recurse **params)

    @client.get("#{uri.path}?#{params}") do |response|
      List.from_json(response.body_io)
    end
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

    @client.post(
      "#{uri.path}?project=#{project}",
      body: body,
      headers: headers
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def delete(fingerprint, project = nil)
    yield delete(fingerprint, project)
  end

  def delete(fingerprint : String, project : String? = nil) : Operation::Item
    @client.delete(
      "#{uri.path}/#{fingerprint}?project=#{project}"
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(fingerprint, **params)
    yield fetch(fingerprint, **params)
  end

  def fetch(fingerprint : String, **params) : Item
    params = URI::Params.encode(params)

    @client.get("#{uri.path}/#{fingerprint}?#{params}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def update(fingerprint, project = nil, **params)
    yield update(fingerprint, project, **params)
  end

  def update(
    fingerprint : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    @client.patch(
      "#{uri.path}/#{fingerprint}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def replace(fingerprint, project = nil, **params)
    yield replace(fingerprint, project, **params)
  end

  def replace(fingerprint : String, project = nil, **params) : Operation::Item
    @client.put(
      "#{uri.path}/#{fingerprint}?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def export(fingerprint, destination, **params)
    yield export(fingerprint, destination, **params)
  end

  def export(fingerprint : String, destination, **params) : Operation::Item
    params = URI::Params.encode(params)

    @client.get("#{uri.path}/#{fingerprint}/export?#{params}") do |response|
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

  def push(fingerprint, project = nil, **params)
    yield push(fingerprint, project, **params)
  end

  def push(
    fingerprint : String,
    project : String? = nil,
    **params
  ) : Operation::Item
    @client.post(
      "#{uri.path}/#{fingerprint}/export?project=#{project}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def refresh(fingerprint, project = nil)
    yield refresh(fingerprint, project)
  end

  def refresh(fingerprint : String, project : String? = nil) : Operation::Item
    @client.post(
      "#{uri.path}/#{fingerprint}/refresh?project=#{project}",
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def generate_secret(fingerprint, project = nil)
    yield generate_secret(fingerprint, project)
  end

  def generate_secret(
    fingerprint : String,
    project : String? = nil
  ) : Operation::Item
    @client.post(
      "#{uri.path}/#{fingerprint}/secret?project=#{project}",
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri : URI
    uri = @client.uri.dup
    uri.path += "/images"
    uri
  end
end
