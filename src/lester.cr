require "http"
require "http/web_socket"
require "json"

require "./lester/version"
require "./lester/endpoint"
require "./lester/resource"
require "./lester/**"

class Lester
  getter :uri

  getter socket : UNIXSocket?

  def initialize(base_uri : URI, tls : OpenSSL::SSL::Context::Client)
    @uri = base_uri
    @uri.scheme = "https"
    @uri.path = @uri.path.rchop("/").rchop("/1.0")
    @uri.path += "/1.0"
    @uri.fragment = nil
    @uri.query = nil

    @http_client = HTTP::Client.new(@uri, configure_tls(tls))
    set_headers
  end

  def initialize(@socket)
    @uri = URI.new("http+unix", socket.path, path: "/1.0")
    @http_client = HTTP::Client.new(socket)

    set_headers
  end

  def self.new(base_uri : String, tls : OpenSSL::SSL::Context::Client)
    new URI.parse(base_uri), tls
  end

  def self.new(
    base_uri : String,
    private_key : String,
    certificate : String,
    ca_certificates : String? = nil,
    verify_mode : String = "none"
  )
    new(
      URI.parse(base_uri),
      private_key,
      certificate,
      ca_certificates,
      verify_mode
    )
  end

  def self.new(
    base_uri : URI,
    private_key : String,
    certificate : String,
    ca_certificates : String? = nil,
    verify_mode : String = "none"
  )
    tls = OpenSSL::SSL::Context::Client.from_hash({
      "key" => private_key,
      "cert" => certificate,
      "ca" => ca_certificates,
      "verify_mode" => verify_mode
    })

    new(base_uri, tls)
  end

  def self.new(socket : String)
    uri = URI.parse(socket)
    new UNIXSocket.new(uri.path)
  end

  forward_missing_to @http_client

  getter certificates : Certificate::Endpoint do
    Certificate::Endpoint.new(self)
  end

  getter cluster : Cluster::Endpoint do
    Cluster::Endpoint.new(self)
  end

  getter images : Image::Endpoint do
    Image::Endpoint.new(self)
  end

  getter instances : Instance::Endpoint do
    Instance::Endpoint.new(self)
  end

  getter metrics : Metrics::Endpoint do
    Metrics::Endpoint.new(self)
  end

  getter networks : Network::Endpoint do
    Network::Endpoint.new(self)
  end

  getter operations : Operation::Endpoint do
    Operation::Endpoint.new(self)
  end

  getter pools : Pool::Endpoint do
    Pool::Endpoint.new(self)
  end

  getter profiles : Profile::Endpoint do
    Profile::Endpoint.new(self)
  end

  getter projects : Project::Endpoint do
    Project::Endpoint.new(self)
  end

  getter server : Server::Endpoint do
    Server::Endpoint.new(self)
  end

  getter volumes : Volume::Endpoint do
    Volume::Endpoint.new(self)
  end

  getter warnings : Warning::Endpoint do
    Warning::Endpoint.new(self)
  end

  protected def recurse(**params)
    params.merge({recursion: "1"})
  end

  protected def websocket(uri, headers = HTTP::Headers.new)
    if websocket = websocket_for_unix_socket(uri, headers)
      return websocket
    end

    set_content_type(headers)
    set_user_agent(headers)

    HTTP::WebSocket.new(uri, headers: headers)
  end

  protected def copy(source, destination) : Nil
    case destination
    when IO
      IO.copy(source, destination)
    else
      File.write(destination, source, mode: "wb")
    end
  end

  private def configure_tls(tls)
    tls.tap do |_tls|
      _tls.set_modern_ciphers

      _tls.add_options(
        OpenSSL::SSL::Options::NO_SSL_V2 |
        OpenSSL::SSL::Options::NO_SSL_V3 |
        OpenSSL::SSL::Options::NO_TLS_V1 |
        OpenSSL::SSL::Options::NO_TLS_V1_1
      )
    end
  end

  private def set_headers
    @http_client.before_request do |request|
      set_content_type(request.headers)
      set_user_agent(request.headers)
    end
  end

  private def set_content_type(headers)
    headers["Content-Type"] = "application/json; charset=UTF-8"
  end

  private def set_user_agent(headers)
    headers["User-Agent"] = "Lester/#{Lester::VERSION} \
      (+https://github.com/GrottoPress/lester)"
  end

  # Adapted from `HTTP::Websocket::Protocol.new`
  private def websocket_for_unix_socket(uri, headers)
    socket.try do |socket|
      key = Random::Secure.base64(16)

      headers["Host"] = "#{uri.host}:#{uri.port}"
      headers["Connection"] = "Upgrade"
      headers["Upgrade"] = "websocket"
      headers["Sec-WebSocket-Version"] = HTTP::WebSocket::Protocol::VERSION
      headers["Sec-WebSocket-Key"] = key

      HTTP::Request.new("GET", uri.path, headers).to_io(socket)
      socket.flush

      response = HTTP::Client::Response.from_io(socket, ignore_body: true)

      unless response.status.switching_protocols?
        raise Socket::Error.new(
          "Handshake got denied. Status code was #{response.status.code}."
        )
      end

      challenge_response = HTTP::WebSocket::Protocol.key_challenge(key)

      unless response.headers["Sec-WebSocket-Accept"]? == challenge_response
        raise Socket::Error.new(
          "Handshake got denied. Server did not verify WebSocket challenge."
        )
      end

      HTTP::WebSocket.new(socket)
    rescue error
      socket.close
      raise error
    end
  end
end
