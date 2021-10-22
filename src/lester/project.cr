struct Lester::Project
  include Hapi::Resource

  getter config : Hash(String, String)?
  getter description : String?
  getter name : String?
  getter used_by : Array(String)?
end
