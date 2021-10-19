struct Lester::Server::Storage::Disk
  include Hapi::Resource

  getter block_size : Int32?
  getter device : String?
  getter device_id : String?
  getter device_path : String?
  getter firmware_version : String?
  getter id : String?
  getter model : String?
  getter numa_node : Int32?
  getter partitions : Array(Partition)?
  getter pci_address : String?
  getter? read_only : Bool?
  getter? removable : Bool?
  getter rpm : Int32?
  getter serial : String?
  getter size : Int64?
  getter type : String?
  getter usb_address : String?
  getter wwn : String?
end
