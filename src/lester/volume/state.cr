struct Lester::Volume::State
  include Hapi::Resource

  getter usage : Usage?
end
