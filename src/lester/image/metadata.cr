struct Lester::Image::Metadata
  include Lester::Resource

  struct Template
    include Lester::Resource

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
