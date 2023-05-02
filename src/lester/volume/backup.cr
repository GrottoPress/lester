struct Lester::Volume::Backup
  include Lester::Resource

  getter created_at : Time?
  getter expires_at : Time?
  getter name : String?
  getter? optimized_storage : Bool?
  getter? volume_only : Bool?
end
