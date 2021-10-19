struct Lester::Server::Cpu::Cache
  include Hapi::Resource

  enum Type
    Data
    Instruction
    Unified
  end

  getter level : Int32?
  getter size : Int64?
  getter type : Type?
end
