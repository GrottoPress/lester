struct Lester::Image::Properties
  include Lester::Resource

  getter architecture : String?
  getter description : String?
  getter name : String?
  getter os : String?
  getter release : String?
  getter serial : String?
  getter type : String?
  getter variant : String?
end
