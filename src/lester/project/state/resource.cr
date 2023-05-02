struct Lester::Project::State::Resource
  include Lester::Resource

  @Limit : Int32? # ameba:disable Style/VariableNames
  @Usage : Int32? # ameba:disable Style/VariableNames

  def limit : Int32?
    @Limit # ameba:disable Style/VariableNames
  end

  def usage : Int32?
    @Usage # ameba:disable Style/VariableNames
  end
end
