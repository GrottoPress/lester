struct Lester::Server::Gpu::Drm
  include Lester::Resource

  getter card_device : String?
  getter card_name : String?
  getter control_device : String?
  getter control_name : String?
  getter id : Int32?
  getter render_device : String?
  getter render_name : String?
end
