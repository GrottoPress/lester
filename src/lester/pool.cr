struct Lester::Pool
  include Hapi::Resource

  getter config : Hash(String, String)?
  getter description : String?
  getter driver : Driver?
  getter locations : Array(String)?
  getter name : String?
  getter status : Status?
  getter used_by : Array(String)?
end
