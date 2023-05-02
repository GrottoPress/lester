struct Lester::Server::Pci::Device
  include Lester::Resource

  getter driver : String?
  getter driver_version : String?
  getter iommu_group : Int32?
  getter numa_node : Int32?
  getter pci_address : String?
  getter product : String?
  getter product_id : String?
  getter vendor : String?
  getter vendor_id : String?
end
