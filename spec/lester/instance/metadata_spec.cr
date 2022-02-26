require "../../spec_helper"

describe Lester::Instance::Metadata::Endpoint do
  describe "#fetch" do
    it "retrieves metadata" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "architecture": "amd64",
            "creation_date": 1633678057,
            "expiry_date": 1636270057,
            "properties": {
              "architecture": "amd64",
              "description": "Debian buster amd64 (20211008_07:18)",
              "name": "debian-buster-amd64-default-20211008_07:18",
              "os": "debian",
              "release": "buster",
              "serial": "20211008_07:18",
              "variant": "default"
            },
            "templates": {
              "/etc/hosts": {
                "when": [
                  "create",
                  "copy"
                ],
                "create_only": false,
                "template": "hosts.tpl",
                "properties": {}
              }
            }
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/metadata")
        .with(query: {"project" => "default"})
        .to_return(body: body)

      LXD.instances.metadata.fetch(
        instance_name: "inst4",
        project: "default",
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Image::Metadata)
      end
    end
  end

  describe "#update" do
    it "updates metadata" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:PATCH, "#{LXD.uri}/instances/inst4/metadata?project=")
        .with(body: %({"architecture":"x86_64","expiry_date":1620685757}))
        .to_return(body: body)

      LXD.instances.metadata.update(
        instance_name: "inst4",
        architecture: "x86_64",
        expiry_date: 1620685757,
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates metadata" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:PUT, "#{LXD.uri}/instances/inst4/metadata?project=")
        .with(body: %({"architecture":"x86_64","expiry_date":1620685757}))
        .to_return(body: body)

      LXD.instances.metadata.replace(
        instance_name: "inst4",
        architecture: "x86_64",
        expiry_date: 1620685757,
      ) do |response|
        response.success?.should be_true
      end
    end
  end
end
