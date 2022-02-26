require "../../spec_helper"

describe Lester::Network::Acl::Endpoint do
  describe "#list" do
    it "lists network ACLs" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": [
            {
              "config": {
                "user.mykey": "foo"
              },
              "description": "Web servers",
              "egress": [
                {
                  "action": "allow",
                  "description": "Allow DNS queries to Google DNS",
                  "destination": "8.8.8.8/32,8.8.4.4/32",
                  "destination_port": "53",
                  "icmp_code": "0",
                  "icmp_type": "8",
                  "protocol": "udp",
                  "source": "@internal",
                  "source_port": "1234",
                  "state": "enabled"
                }
              ],
              "ingress": [
                {
                  "action": "allow",
                  "description": "Allow DNS queries to Google DNS",
                  "destination": "8.8.8.8/32,8.8.4.4/32",
                  "destination_port": "53",
                  "icmp_code": "0",
                  "icmp_type": "8",
                  "protocol": "udp",
                  "source": "@internal",
                  "source_port": "1234",
                  "state": "enabled"
                }
              ],
              "name": "bar",
              "used_by": [
                "/1.0/instances/c1",
                "/1.0/instances/v1",
                "/1.0/networks/web-out"
              ]
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/network-acls")
        .with(query: {"project" => "default", "recursion" => "1"})
        .to_return(body: body)

      LXD.networks.acls.list(project: "default") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Network::Acl))
      end
    end
  end

  describe "#create" do
    it "creates network ACL" do
      body = <<-JSON
        {
          "type": "async",
          "status": "Acl created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:POST, "#{LXD.uri}/network-acls?project=")
        .with(body: %({\
          "name":"web-out",\
          "egress":[{\
            "action":"allow",\
            "state":"enabled",\
            "destination_port":"80"\
          }]\
        }))
        .to_return(body: body)

      LXD.networks.acls.create(
        name: "web-out",
        egress: [{action: "allow", state: "enabled", destination_port: "80"}]
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#delete" do
    it "deletes network ACL" do
      body = <<-JSON
        {
          "type": "async",
          "status": "Acl created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:DELETE, "#{LXD.uri}/network-acls/web-out?project=")
        .to_return(body: body)

      LXD.networks.acls.delete(name: "web-out") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches network ACL" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "config": {
              "user.mykey": "foo"
            },
            "description": "Web servers",
            "egress": [
              {
                "action": "allow",
                "description": "Allow DNS queries to Google DNS",
                "destination": "8.8.8.8/32,8.8.4.4/32",
                "destination_port": "53",
                "icmp_code": "0",
                "icmp_type": "8",
                "protocol": "udp",
                "source": "@internal",
                "source_port": "1234",
                "state": "enabled"
              }
            ],
            "ingress": [
              {
                "action": "allow",
                "description": "Allow DNS queries to Google DNS",
                "destination": "8.8.8.8/32,8.8.4.4/32",
                "destination_port": "53",
                "icmp_code": "0",
                "icmp_type": "8",
                "protocol": "udp",
                "source": "@internal",
                "source_port": "1234",
                "state": "enabled"
              }
            ],
            "name": "bar",
            "used_by": [
              "/1.0/instances/c1",
              "/1.0/instances/v1",
              "/1.0/networks/web-out"
            ]
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/network-acls/web-out")
        .to_return(body: body)

      LXD.networks.acls.fetch(name: "web-out") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Network::Acl)
      end
    end
  end

  describe "#update" do
    it "updates network ACL" do
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

      WebMock.stub(:PATCH, "#{LXD.uri}/network-acls/web-out?project=")
        .with(body: %({"egress":[{"state":"disabled"}]}))
        .to_return(body: body)

      LXD.networks.acls.update(
        name: "web-out",
        egress: [{state: "disabled"}]
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#rename" do
    it "renames network ACL" do
      body = <<-JSON
        {
          "type": "async",
          "status": "Acl created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:POST, "#{LXD.uri}/network-acls/web-out?project=")
        .with(body: %({"name":"http-out"}))
        .to_return(body: body)

      LXD.networks.acls.rename(
        name: "web-out",
        new_name: "http-out"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates network ACL" do
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

      WebMock.stub(:PUT, "#{LXD.uri}/network-acls/web-out?project=")
        .with(body: %({"egress":[{"state":"disabled"}]}))
        .to_return(body: body)

      LXD.networks.acls.replace(
        name: "web-out",
        egress: [{state: "disabled"}]
      ) do |response|
        response.success?.should be_true
      end
    end
  end
end
