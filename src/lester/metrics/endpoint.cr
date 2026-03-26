struct Lester::Metrics::Endpoint
  include Lester::Endpoint

  def fetch(**params)
    yield fetch(**params)
  end

  def fetch(**params) : String
    params = URI::Params.encode(params)
    response = @client.get("#{uri.path}?#{params}")

    unless response.status.success?
      raise Error.new("Could not retrieve metrics. \
        Remote server returned status code #{response.status_code}")
    end

    response.body
  end

  getter uri : URI do
    clone_uri(@client.uri).tap { |uri| uri.path += "/metrics" }
  end
end
