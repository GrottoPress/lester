struct Lester::Network::Lease::List
  include Response

  getter metadata : Array(Lease)?
end
