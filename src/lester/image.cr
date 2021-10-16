require "./image/type_field"

struct Lester::Image
  include Hapi::Resource
  include TypeField

  getter aliases : Array(Alias)?
  getter architecture : String?
  getter? auto_update : Bool?
  getter? cached : Bool?
  getter created_at : Time?
  getter expires_at : Time?
  getter filename : String?
  getter fingerprint : String?
  getter last_used_at : Time?
  getter profiles : Array(String)?
  getter properties : Properties?
  getter? public : Bool?
  getter size : Int64?
  getter update_source : UpdateSource?
  getter uploaded_at : Time?
end
