struct Lester::Server::Cpu
  include Lester::Resource

  getter architecture : String?
  getter sockets : Array(Socket)?
  getter total : Int32?
end
