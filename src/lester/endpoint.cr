module Lester::Endpoint
  macro included
    def initialize(@client : Lester)
    end
  end
end
