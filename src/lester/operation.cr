struct Lester::Operation
  include Lester::Resource

  getter class : Class?
  getter created_at : Time?
  getter description : String?
  getter err : String?
  getter id : String?
  getter location : String?
  getter? may_cancel : Bool?
  getter metadata : Metadata?
  getter resources : Resources?
  getter status : String?
  getter status_code : Int32?
  getter updated_at : Time?

  def success? : Bool?
    status_code.try(&.< 400)
  end
end
