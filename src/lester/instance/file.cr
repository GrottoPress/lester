struct Lester::Instance::File
  include Hapi::Resource

  getter content : Array(String)?
  getter group_id : Int32?
  getter permissions : String?
  getter type : Type?
  getter user_id : Int32?
end
