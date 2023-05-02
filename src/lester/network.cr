struct Lester::Network
  include Lester::Resource

  getter config : Hash(String, String)?
  getter description : String?
  getter locations : Array(String)?
  getter? managed : Bool?
  getter name : String?
  getter status : String?
  getter type : Type?
  getter used_by : Array(String)?
end
