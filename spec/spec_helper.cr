require "spec"
require "webmock"

require "../src/lester"

LXD = Lester.new(
  "https://example.com/lxd",
  "spec/certs/priv.pem",
  "spec/certs/cert.pem"
)

Spec.before_each do
  WebMock.reset
end
