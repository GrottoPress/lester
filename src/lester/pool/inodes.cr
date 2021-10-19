struct Lester::Pool::Inodes
  include Hapi::Resource

  getter total : Int64?
  getter used : Int64?
end
