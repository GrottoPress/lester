struct Lester::Server::Cpu::Thread
  include Hapi::Resource

  getter id : Int32?
  getter? isolated : Bool?
  getter numa_node : Int32?
  getter? online : Bool?
  getter thread : Int32?
end
