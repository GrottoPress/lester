struct Lester::Server::Resources
  include Lester::Resource

  getter cpu : Cpu?
  getter gpu : Gpu?
  getter memory : Memory?
  getter network : Network?
  getter pci : Pci?
  getter storage : Storage?
  getter system : System?
  getter usb : Usb?
end
