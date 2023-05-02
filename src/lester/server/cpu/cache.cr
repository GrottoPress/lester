struct Lester::Server::Cpu::Cache
  include Lester::Resource

  enum Type
    Data
    Instruction
    Unified
  end

  getter level : Int32?
  getter size : Int64?
  getter type : Type?
end
