struct Lester::Server::Gpu::Card
  include Hapi::Resource

  getter driver : String?
  getter driver_version : String?
  getter drm : Drm?
  getter mdev : MDev?
  getter numa_node : Int32?
  getter nvidia : Nvidia?
  getter pci_address : String?
  getter product : String?
  getter product_id : String?
  getter sriov : Sriov?
  getter usb_address : String?
  getter vendor : String?
  getter vendor_id : String?
end
