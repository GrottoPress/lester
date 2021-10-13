struct Lester::Image::Alias
  include Hapi::Resource

  getter description : String?
  getter name : String?
  getter target : String?
  getter type : String?
end
