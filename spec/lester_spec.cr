require "./spec_helper"

describe Lester do
  ENV["LXD_SOCKET"]?.try do |socket|
    next if socket.empty?

    it "connects to local LXD server" do
      WebMock.allow_net_connect = true

      lxd = Lester.new(socket)

      lxd.images.list do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Image))
      end
    end
  end

  ENV["LXD_BASE_URI"]?.try do |base_uri|
    next if base_uri.empty?
    next unless key = ENV["LXD_TLS_KEY_PATH"]?
    next unless cert = ENV["LXD_TLS_CERT_PATH"]?

    it "connects to remote LXD server" do
      WebMock.allow_net_connect = true

      ca = ENV["LXD_TLS_CA_PATH"]?
      verify = ENV["LXD_TLS_VERIFY_MODE"]? || "none"

      lxd = Lester.new(base_uri, key, cert, ca, verify)

      lxd.images.list do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Image))
      end
    end
  end
end
