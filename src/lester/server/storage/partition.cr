struct Lester::Server::Storage::Partition
  include Hapi::Resource

  getter device : String?
  getter id : String?
  getter partition : Int32?
  getter? read_only : Bool?
  getter size : Int64?
end
