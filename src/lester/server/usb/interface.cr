struct Lester::Server::Usb::Interface
  include Hapi::Resource

  getter class : String?
  getter class_id : Int32?
  getter driver : String?
  getter driver_version : String?
  getter number : Int32?
  getter subclass : String?
  getter subclass_id : Int32?
end
