struct Lester::Operation::Endpoint
  include Lester::Endpoint

  def list
    yield list
  end

  def list : List
    response = @client.get(uri.path)
    List.from_json(response.body)
  end

  def delete(id)
    yield delete(id)
  end

  def delete(id : String) : Item
    response = @client.delete("#{uri.path}/#{id}")
    Item.from_json(response.body)
  end

  def fetch(id)
    yield fetch(id)
  end

  def fetch(id : String) : Item
    response = @client.get("#{uri.path}/#{id}")
    Item.from_json(response.body)
  end

  def wait(id, secret = nil, timeout = -1)
    yield wait(id, secret, timeout)
  end

  def wait(id : String, secret : String? = nil, timeout : Int32 = -1) : Item
    uri_path = "#{uri.path}/#{id}/wait?timeout=#{timeout}"
    uri_path += "&public&secret=#{secret}" if secret
    response = @client.get(uri_path)

    Item.from_json(response.body)
  end

  def websocket(id, secret = nil)
    yield websocket(id, secret)
  end

  def websocket(id : String, secret : String? = nil) : HTTP::WebSocket
    uri = URI.parse(self.uri.to_s)
    uri.path += "/#{id}/websocket"
    uri.path += "?public&secret=#{secret}" if secret

    @client.websocket(uri)
  end

  getter uri : URI do
    uri = URI.parse(@client.uri.to_s)
    uri.path += "/operations"
    uri
  end
end
