require "hapi"

require "./lester/version"
require "./lester/**"

class Lester
  include Hapi::Client

  getter :uri
  private getter :http_client

  def initialize(base_uri : URI, tls : OpenSSL::SSL::Context::Client)
    @uri = base_uri
    @uri.path = @uri.path.rchop("/").rchop("/1.0")
    @uri.path += "/1.0"
    @uri.fragment = nil
    @uri.query = nil

    @http_client = HTTP::Client.new(@uri, configure_tls(tls))
    set_headers
  end

  def initialize(socket : UNIXSocket)
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

  def certificates : Certificate::Endpoint
    @certificates ||= Certificate::Endpoint.new(self)
  end

  def images : Image::Endpoint
    @images ||= Image::Endpoint.new(self)
  end

  def instances : Instance::Endpoint
    @instances ||= Instance::Endpoint.new(self)
  end

  protected def recurse(**params)
    params.merge({recursion: "1"})
  end

  private def configure_tls(tls)
    tls.cipher_suites = OpenSSL::SSL::Context::CIPHER_SUITES_MODERN

    tls.add_options(
      OpenSSL::SSL::Options::NO_SSL_V2 |
      OpenSSL::SSL::Options::NO_SSL_V3 |
      OpenSSL::SSL::Options::NO_TLS_V1 |
      OpenSSL::SSL::Options::NO_TLS_V1_1
    )

    tls
  end

  private def set_headers
    http_client.before_request do |request|
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
end
