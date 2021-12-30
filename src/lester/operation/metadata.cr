struct Lester::Operation::Metadata
  include Hapi::Resource

  getter command : Array(String)?
  getter environment : Hash(String, String)?
  getter fds : Hash(Int32, String)?
  getter? interactive : Bool?
  getter output : Hash(Int32, String)?
end
