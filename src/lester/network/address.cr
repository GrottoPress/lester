struct Lester::Network::Address
  include Lester::Resource

  enum Scope
    Local
    Link
    Global
  end

  getter family : String?
  getter address : String?
  getter netmask : String?
  getter scope : Scope?
end
