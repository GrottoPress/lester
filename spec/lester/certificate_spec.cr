require "../spec_helper"

describe Lester::Certificate::Endpoint do
  describe "#list" do
    it "lists certificates" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": [
            {
              "certificate": "X509 PEM certificate",
              "fingerprint": "fd200419b271f1dc2a5591b693cc5774b7f234e",
              "name": "castiana",
              "projects": [
                "default",
                "foo",
                "bar"
              ],
              "restricted": true,
              "type": "client"
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/certificates")
        .with(query: {"recursion" => "1"})
        .to_return(body_io: body_io)

      LXD.certificates.list do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Certificate))
      end
    end
  end

  describe "#add" do
    it "adds certificate" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:POST, "#{LXD.uri}/certificates?public")
        .with(body: %({"password":"secret"}))
        .to_return(body_io: body_io)

      LXD.certificates.add(password: "secret") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#delete" do
    it "deletes certificate" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:DELETE, "#{LXD.uri}/certificates/a1b2c3")
        .to_return(body_io: body_io)

      LXD.certificates.delete(fingerprint: "a1b2c3") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches certificate" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "certificate": "X509 PEM certificate",
            "fingerprint": "fd200419b271f1dc2a5591b693cc5774b7f234e",
            "name": "castiana",
            "projects": [
              "default",
              "foo",
              "bar"
            ],
            "restricted": true,
            "type": "client"
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/certificates/a1b2c3")
        .to_return(body_io: body_io)

      LXD.certificates.fetch(fingerprint: "a1b2c3") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Certificate)
      end
    end
  end

  describe "#update" do
    it "updates certificate" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:PATCH, "#{LXD.uri}/certificates/a1b2c3")
        .with(body: %({"name":"castiana","restricted":true}))
        .to_return(body_io: body_io)

      LXD.certificates.update(
        fingerprint: "a1b2c3",
        name: "castiana",
        restricted: true
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates certificate" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:PUT, "#{LXD.uri}/certificates/a1b2c3")
        .with(body: %({"name":"castiana","restricted":true}))
        .to_return(body_io: body_io)

      LXD.certificates.replace(
        fingerprint: "a1b2c3",
        name: "castiana",
        restricted: true
      ) do |response|
        response.success?.should be_true
      end
    end
  end
end
