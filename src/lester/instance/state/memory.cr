struct Lester::Instance::State::Memory
  include Hapi::Resource

  getter swap_usage : Int64?
  getter swap_usage_peak : Int64?
  getter usage : Int64?
  getter usage_peak : Int64?
end
