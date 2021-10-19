struct Lester::Server::Cpu::Socket
  include Hapi::Resource

  getter cache : Array(Cache)?
  getter cores : Array(Core)?
  getter frequency : Int32?
  getter frequency_minimum : Int32?
  getter frequency_turbo : Int32?
  getter name : String?
  getter socket : Int32?
  getter vendor : String?
end
