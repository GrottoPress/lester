struct Lester::Project::State::Resource
  include Hapi::Resource

  @Limit : Int32?
  @Usage : Int32?

  def limit : Int32?
    @Limit
  end

  def usage : Int32?
    @Usage
  end
end
