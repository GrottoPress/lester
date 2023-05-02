struct Lester::Certificate
  include Lester::Resource

  enum Type
    Client
  end

  getter certificate : String?
  getter fingerprint : String?
  getter name : String?
  getter projects : Array(String)?
  getter? restricted : Bool?
  getter type : Type?
end
