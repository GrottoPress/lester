struct Lester::Profile
  include Lester::Resource

  getter config : Hash(String, String)?
  getter description : String?
  getter devices : Hash(String, Hash(String, String))?
  getter name : String?
  getter used_by : Array(String)?
end
