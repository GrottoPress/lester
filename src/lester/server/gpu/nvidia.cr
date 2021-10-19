struct Lester::Server::Gpu::Nvidia
  include Hapi::Resource

  getter architecture : String?
  getter brand : String?
  getter card_device : String?
  getter card_name : String?
  getter cuda_version : String?
  getter model : String?
  getter nvrm_version : String?
  getter uuid : String?
end
