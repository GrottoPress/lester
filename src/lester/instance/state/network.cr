struct Lester::Instance::State::Network
  include Hapi::Resource

  enum State
    Up
    Down
  end

  struct Address
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

  struct Counters
    include Hapi::Resource

    getter bytes_received : Int64?
    getter bytes_sent : Int64?
    getter errors_received : Int32?
    getter errors_sent : Int32?
    getter packets_dropped_inbound : Int64?
    getter packets_dropped_outbound : Int64?
    getter packets_received : Int64?
    getter packets_sent : Int64?
  end

  getter addresses : Array(Address)?
  getter counters : Counters?
  getter hwaddr : String?
  getter host_name : String?
  getter mtu : Int64?
  getter state : State?
  getter type : String?
end
