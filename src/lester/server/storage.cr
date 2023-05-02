struct Lester::Server::Storage
  include Lester::Resource

  getter disks : Array(Disk)?
  getter total : Int32?
end
