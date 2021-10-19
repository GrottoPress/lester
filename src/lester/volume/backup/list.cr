struct Lester::Volume::Backup::List
  include Response

  getter metadata : Array(Backup)?
end
