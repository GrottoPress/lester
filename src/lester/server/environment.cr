struct Lester::Server::Environment
  include Hapi::Resource

  getter addresses : Array(String)?
  getter architectures : Array(String)?
  getter certificate : String?
  getter certificate_fingerprint : String?
  getter driver : String?
  getter driver_version : String?
  getter firewall : String?
  getter kernel : String?
  getter kernel_architecture : String?
  getter kernel_features : Hash(String, String)?
  getter kernel_version : String?
  getter lxc_features : Hash(String, String)?
  getter os_name : String?
  getter os_version : String?
  getter project : String?
  getter server : String?
  getter? server_clustered : Bool?
  getter server_name : String?
  getter server_pid : Int32?
  getter server_version : String?
  getter storage : String?
  getter storage_supported_drivers : Array(Storage::Driver)?
  getter storage_version : String?
end
