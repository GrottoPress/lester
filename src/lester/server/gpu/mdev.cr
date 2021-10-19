struct Lester::Server::Gpu::MDev
  include Hapi::Resource

  getter api : String?
  getter available : Int32?
  getter description : String?
  getter devices : Array(String)?
  getter name : String?
end
