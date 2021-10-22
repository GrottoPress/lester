struct Lester::Project::State::Resources
  include Hapi::Resource
  include JSON::Serializable::Unmapped

  getter containers : Resource?
  getter cpu : Resource?
  getter disk : Resource?
  getter instances : Resource?
  getter memory : Resource?
  getter networks : Resource?
  getter processes : Resource?

  def virtual_machines : Resource?
    json_unmapped["virtual-machines"]?.try do |resource|
      Resource.from_json(resource.to_json)
    end
  end
end
