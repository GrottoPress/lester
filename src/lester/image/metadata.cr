struct Lester::Image::Metadata
  include Hapi::Resource

  struct Template
    include Hapi::Resource

    getter? create_only : Bool?
    getter properties : Hash(String, String)?
    getter template : String?
    getter when : Array(String)?
  end

  getter architecture : String?
  getter creation_date : Int64?
  getter expiry_date : Int64?
  getter properties : Properties?
  getter templates : Hash(String, Template)
end
