struct Lester::Pool::Resources
  include Hapi::Resource

  getter inodes : Inodes?
  getter space : Space?
end
