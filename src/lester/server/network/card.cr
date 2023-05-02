struct Lester::Server::Network::Card
  include Lester::Resource

  getter driver : String?
  getter driver_version : String?
  getter firmware_version : String?
  getter numa_node : Int32?
  getter pci_address : String?
  getter ports : Array(Port)?
  getter product : String?
  getter product_id : String?
  getter sriov : Sriov?
  getter usb_address : String?
  getter vendor : String?
  getter vendor_id : String?
end
