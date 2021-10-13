struct Lester::Operation::Item
  include Response

  getter metadata : Operation?
  getter operation : String?
end
