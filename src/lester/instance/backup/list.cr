struct Lester::Instance::Backup::List
  include Response

  getter metadata : Array(Backup)?
end
