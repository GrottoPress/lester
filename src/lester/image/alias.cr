require "./type_field"

struct Lester::Image::Alias
  include Lester::Resource
  include TypeField

  getter description : String?
  getter name : String?
  getter target : String?
end
