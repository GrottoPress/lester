struct Lester::Instance::Backup
  include Lester::Resource

  getter? container_only : Bool?
  getter created_at : Time?
  getter expires_at : Time?
  getter? instance_only : Bool?
  getter name : String?
  getter? optimized_storage : Bool?
end
