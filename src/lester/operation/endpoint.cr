struct Lester::Operation::Endpoint
  include Lester::Endpoint

  def list
    yield list
  end

  def list : List
    client.get(uri.path) do |response|
      List.from_json(response.body_io)
    end
  end

  def delete(id)
    yield delete(id)
  end

  def delete(id : String) : Item
    client.delete("#{uri.path}/#{id}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def fetch(id)
    yield fetch(id)
  end

  def fetch(id : String) : Item
    client.get("#{uri.path}/#{id}") do |response|
      Item.from_json(response.body_io)
    end
  end

  def wait(id, secret = nil, timeout = -1)
    yield wait(id, secret, timeout)
  end

  def wait(id : String, secret : String? = nil, timeout : Int32 = -1) : Item
    uri_path = "#{uri.path}/#{id}/wait?timeout=#{timeout}"
    uri_path += "&public&secret=#{secret}" if secret

    client.get(uri_path) do |response|
      Item.from_json(response.body_io)
    end
  end

  def websocket(id, secret = nil)
    yield websocket(id, secret)
  end

  def websocket(id : String, secret : String? = nil) : HTTP::WebSocket
    uri = self.uri.dup
    uri.path += "/#{id}/websocket"
    uri.path += "?public&secret=#{secret}" if secret

    client.websocket(uri)
  end

  def uri : URI
    uri = client.uri.dup
    uri.path += "/operations"
    uri
  end
end
