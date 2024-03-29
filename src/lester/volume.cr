struct Lester::Volume
  include Lester::Resource

  getter config : Hash(String, String)?
  getter content_type : ContentType?
  getter description : String?
  getter expires_at : Time?
  getter location : String?
  getter name : String?
  getter restore : String?
  getter type : String?
  getter used_by : Array(String)?
end
