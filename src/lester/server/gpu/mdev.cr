struct Lester::Server::Gpu::MDev
  include Lester::Resource

  getter api : String?
  getter available : Int32?
  getter description : String?
  getter devices : Array(String)?
  getter name : String?
end
