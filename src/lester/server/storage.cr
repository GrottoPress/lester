struct Lester::Server::Storage
  include Hapi::Resource

  getter disks : Array(Disk)?
  getter total : Int32?
end
