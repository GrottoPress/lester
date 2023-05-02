struct Lester::Pool::Resources
  include Lester::Resource

  getter inodes : Inodes?
  getter space : Space?
end
