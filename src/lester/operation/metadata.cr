struct Lester::Operation::Metadata
  include Hapi::Resource

  getter command : Array(String)?
  getter environment : Hash(String, String)?
  getter fds : Hash(String, String)?
  getter? interactive : Bool?
end
