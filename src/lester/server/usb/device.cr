struct Lester::Server::Usb::Device
  include Lester::Resource

  getter bus_address : Int32?
  getter device_address : Int32?
  getter interfaces : Array(Interface)?
  getter product : String?
  getter product_id : String?
  getter speed : Int32?
  getter vendor : String?
  getter vendor_id : String?
end
