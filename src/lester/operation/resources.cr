struct Lester::Operation::Resources
  include Hapi::Resource

  getter containers : Array(String)?
  getter instances : Array(String)?
end
