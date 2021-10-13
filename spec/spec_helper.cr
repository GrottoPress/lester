require "spec"
require "webmock"

require "../src/lester"

LXD_BASE_URI = "https://example.com/lxd"

LXD = Lester.new(LXD_BASE_URI, "spec/certs/priv.pem", "spec/certs/cert.pem")

Spec.before_each do
  WebMock.reset
end
