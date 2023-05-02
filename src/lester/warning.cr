struct Lester::Warning
  include Lester::Resource

  getter count : Int32?
  getter entity_url : String?
  getter first_seen_at : Time?
  getter last_message : String?
  getter last_seen_at : Time?
  getter location : String?
  getter project : String?
  getter severity : String? # "low"
  getter status : Status?
  getter type : String?
  getter uuid : String?
end
