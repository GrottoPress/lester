struct Lester::Operation::Metadata
  include Hapi::Resource

  @return : Int32?

  getter command : Array(String)?
  getter environment : Hash(String, String)?
  getter fds : Hash(Int32, String)?
  getter? interactive : Bool?
  getter output : Hash(Int32, String)?

  def return : Process::Status?
    @return.try { |code| Process::Status.new(code) }
  end
end
