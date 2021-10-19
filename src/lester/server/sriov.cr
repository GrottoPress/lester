struct Lester::Server::Sriov
  include Hapi::Resource

  getter current_vfs : Int32?
  getter maximum_vfs : Int32?
  getter vfs : Array(Hash(String, JSON::Any))?
end
