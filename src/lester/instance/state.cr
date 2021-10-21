struct Lester::Instance::State
  include Hapi::Resource

  getter cpu : Cpu?
  getter disk : Hash(String, Disk)?
  getter memory : Memory?
  getter network : Hash(String, Network::State)?
  getter pid : Int32?
  getter processes : Int32?
  getter status : String?
  getter status_code : Int32?
end
