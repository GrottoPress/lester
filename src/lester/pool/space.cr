struct Lester::Pool::Space
  include Lester::Resource

  getter total : Int64?
  getter used : Int64?
end
