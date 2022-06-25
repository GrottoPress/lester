struct Lester::Certificate::Endpoint
  include Lester::Endpoint

  def list
    yield list
  end

  def list : List
    params = URI::Params.encode(client.recurse)
    response = client.get("#{uri.path}?#{params}")

    List.from_json(response.body)
  end

  def add(**params)
    yield add(**params)
  end

  def add(**params) : Operation::Item
    uri_path = uri.path
    uri_path += "?public" if params[:password]?
    response = client.post(uri_path, body: params.to_json)

    Operation::Item.from_json(response.body)
  end

  def delete(fingerprint)
    yield delete(fingerprint)
  end

  def delete(fingerprint : String) : Operation::Item
    response = client.delete("#{uri.path}/#{fingerprint}")
    Operation::Item.from_json(response.body)
  end

  def fetch(fingerprint)
    yield fetch(fingerprint)
  end

  def fetch(fingerprint : String) : Item
    response = client.get("#{uri.path}/#{fingerprint}")
    Item.from_json(response.body)
  end

  def update(fingerprint, **params)
    yield update(fingerprint, **params)
  end

  def update(fingerprint : String, **params) : Operation::Item
    response = client.patch("#{uri.path}/#{fingerprint}", body: params.to_json)
    Operation::Item.from_json(response.body)
  end

  def replace(fingerprint, **params)
    yield replace(fingerprint, **params)
  end

  def replace(fingerprint : String, **params) : Operation::Item
    response = client.put("#{uri.path}/#{fingerprint}", body: params.to_json)
    Operation::Item.from_json(response.body)
  end

  def uri : URI
    uri = URI.parse(client.uri.to_s)
    uri.path += "/certificates"
    uri
  end
end
