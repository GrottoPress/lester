struct Lester::Network::Address
  include Hapi::Resource

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
