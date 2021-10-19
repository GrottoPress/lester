struct Lester::Server::Memory
  include Hapi::Resource

  getter hugepages_size : Int64?
  getter hugepages_total : Int64?
  getter hugepages_used : Int64?
  getter nodes : Array(Node)?
  getter total : Int64?
  getter used : Int64?
end
