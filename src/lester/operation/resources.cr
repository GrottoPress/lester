struct Lester::Operation::Resources
  include Lester::Resource

  getter containers : Array(String)?
  getter instances : Array(String)?
end
