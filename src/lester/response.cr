module Lester::Response
  macro included
    include Hapi::Resource

    @error : String?
    @error_code : Int32?
    @status : String?
    @status_code : Int32?

    getter type : Lester::Response::Type

    def code : Int32
      (success? ? @status_code : @error_code).not_nil!
    end

    def message : String
      (success? ? @status : @error).not_nil!
    end

    def success? : Bool
      !type.error?
    end
  end
end
