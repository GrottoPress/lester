struct Lester::Network::State::Counters
  include Lester::Resource

  getter bytes_received : Int64?
  getter bytes_sent : Int64?
  getter errors_received : Int32?
  getter errors_sent : Int32?
  getter packets_dropped_inbound : Int64?
  getter packets_dropped_outbound : Int64?
  getter packets_received : Int64?
  getter packets_sent : Int64?
end
