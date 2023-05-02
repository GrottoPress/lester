struct Lester::Server::Cpu::Core
  include Lester::Resource

  getter core : Int32?
  getter die : Int32?
  getter frequency : Int32?
  getter threads : Array(Thread)?
end
