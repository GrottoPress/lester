struct Lester::Certificate::Endpoint
  include Hapi::Endpoint

  def list
    yield list
  end

  def list : List
    params = URI::Params.encode(@client.recurse)

    @client.get("#{uri.path}?#{params}") do |response|
      List.from_json(response.body_io)
    end
  end

  def add(**params)
    yield add(**params)
  end

  def add(**params) : Operation::Item
    uri_path = uri.path
    uri_path += "?public" if params[:password]?

    @client.post(uri_path, body: params.to_json) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def delete(fingerprint)
    yield delete(fingerprint)
  end

  def delete(fingerprint : String) : Operation::Item
    @client.delete("#{uri.path}/#{fingerprint}") do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def fetch(fingerprint)
    yield fetch(fingerprint)
  end

  def fetch(fingerprint : String) : Item
    @client.get("#{uri.path}/#{fingerprint}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def update(fingerprint, **params)
    yield update(fingerprint, **params)
  end

  def update(fingerprint : String, **params) : Operation::Item
    @client.patch(
      "#{uri.path}/#{fingerprint}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def replace(fingerprint, **params)
    yield replace(fingerprint, **params)
  end

  def replace(fingerprint : String, **params) : Operation::Item
    @client.put(
      "#{uri.path}/#{fingerprint}",
      body: params.to_json
    ) do |response|
      Operation::Item.from_json(response.body_io)
    end
  end

  def uri : URI
    uri = @client.uri.dup
    uri.path += "/certificates"
    uri
  end
end
