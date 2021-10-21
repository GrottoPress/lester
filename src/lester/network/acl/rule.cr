struct Lester::Network::Acl::Rule
  include Hapi::Resource

  @protocol : String?

  getter action : Action?
  getter description : String?
  getter destination : String?
  getter destination_port : String?
  getter icmp_code : String?
  getter icmp_type : String?
  getter source : String?
  getter source_port : String?
  getter state : State?

  def protocol : Protocol?
    @protocol.try do |protocol|
      return Protocol::Any if protocol.empty?
      Protocol.parse(protocol)
    end
  end
end
