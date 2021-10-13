require "../spec_helper"

private struct Response
  include Lester::Response
end

describe Lester::Response do
  it "parses errors" do
    code = 404
    message = "not found"

    response = Response.from_json({
      error: message,
      error_code: code,
      type: "error",
    }.to_json)

    response.should be_a(Response)
    response.code.should eq(code)
    response.message.should eq(message)
    response.type.error?.should be_true
  end
end
