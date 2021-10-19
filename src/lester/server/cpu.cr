struct Lester::Server::Cpu
  include Hapi::Resource

  getter architecture : String?
  getter sockets : Array(Socket)?
  getter total : Int32?
end
