struct Lester::Server::System
  include Lester::Resource

  @type : String?

  getter chassis : Chassis?
  getter family : String?
  getter firmware : Firmware?
  getter motherboard : Motherboard?
  getter product : String?
  getter serial : String?
  getter sku : String?
  getter uuid : String?
  getter vendor : String?
  getter version : String?

  def type : Type?
    @type.try { |type| Type.parse(type.gsub '-', '_') }
  end
end
