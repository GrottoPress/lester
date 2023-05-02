struct Lester::Operation::Metadata
  include Lester::Resource

  @return : Int32?

  getter command : Array(String)?
  getter control : String?
  getter environment : Hash(String, String)?
  getter fds : Hash(Int32, String)?
  getter fs : String?
  getter? interactive : Bool?
  getter output : Hash(Int32, String)?

  def return : Process::Status?
    @return.try { |code| Process::Status.new(code) }
  end
end
