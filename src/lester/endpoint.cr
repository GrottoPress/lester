module Lester::Endpoint
  macro included
    include Hapi::Endpoint

    private def client
      @client.as(Lester)
    end
  end
end
