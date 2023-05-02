struct Lester::Server::Memory::Node
  include Lester::Resource

  getter hugepages_total : Int64?
  getter hugepages_used : Int64?
  getter numa_node : Int32?
  getter total : Int64?
  getter used : Int64?
end
