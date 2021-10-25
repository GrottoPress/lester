struct Lester::Metrics::Endpoint
  include Lester::Endpoint

  def fetch(**params)
    yield fetch(**params)
  end

  def fetch(**params) : String
    params = URI::Params.encode(params)

    client.get("#{uri.path}?#{params}") do |response|
      unless response.status.success?
        raise Error.new("Could not retrieve metrics. \
          Remote server returned status code #{response.status_code}")
      end

      response.body_io.gets_to_end
    end
  end

  def uri : URI
    uri = client.uri.dup
    uri.path += "/metrics"
    uri
  end
end
