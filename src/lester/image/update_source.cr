struct Lester::Image::UpdateSource
  include Lester::Resource

  enum Protocol
    Simplestreams
  end

  getter alias : String?
  getter certificate : String?
  getter image_type : String?
  getter protocol : Protocol?
  getter server : String?
end
