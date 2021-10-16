struct Lester::Instance
  include Hapi::Resource
  include Image::TypeField

  getter architecture : String?
  getter config : Hash(String, String)?
  getter devices : Hash(String, Hash(String, String))?
  getter? ephemeral : Bool?
  getter expires_at : Time?
  getter profiles : Array(String)?
  getter? stateful : Bool?
  getter description : String?
  getter created_at : Time?
  getter expanded_config : Hash(String, String)?
  getter expanded_devices : Hash(String, Hash(String, String))?
  getter name : String?
  getter status : String?
  getter status_code : Int32?
  getter last_used_at : Time?
  getter location : String?
  getter size : Int64?
end
