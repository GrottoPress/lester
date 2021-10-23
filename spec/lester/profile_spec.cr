require "../spec_helper"

describe Lester::Profile::Endpoint do
  describe "#list" do
    it "lists profiles" do
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
              "config": {
                "limits.cpu": "4",
                "limits.memory": "4GiB"
              },
              "description": "Medium size instances",
              "devices": {
                "eth0": {
                  "name": "eth0",
                  "network": "lxdbr0",
                  "type": "nic"
                },
                "root": {
                  "path": "/",
                  "pool": "default",
                  "type": "disk"
                }
              },
              "name": "foo",
              "used_by": [
                "/1.0/instances/c1",
                "/1.0/instances/v1"
              ]
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/profiles")
        .with(query: {"project" => "default", "recursion" => "1"})
        .to_return(body_io: body_io)

      LXD.profiles.list(project: "default") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Profile))
      end
    end
  end

  describe "#create" do
    it "creates profile" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Member added",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:POST, "#{LXD.uri}/profiles?project=")
        .with(body: %({"name":"profile1","config":{"limits.cpu":"4"}}))
        .to_return(body_io: body_io)

      LXD.profiles.create(
        name: "profile1",
        config: {"limits.cpu": "4"}
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#delete" do
    it "deletes profile" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Profile created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:DELETE, "#{LXD.uri}/profiles/profile0?project=")
        .to_return(body_io: body_io)

      LXD.profiles.delete(name: "profile0") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches profile" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "config": {
              "limits.cpu": "4",
              "limits.memory": "4GiB"
            },
            "description": "Medium size instances",
            "devices": {
              "eth0": {
                "name": "eth0",
                "network": "lxdbr0",
                "type": "nic"
              },
              "root": {
                "path": "/",
                "pool": "default",
                "type": "disk"
              }
            },
            "name": "foo",
            "used_by": [
              "/1.0/instances/c1",
              "/1.0/instances/v1"
            ]
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/profiles/profile0")
        .to_return(body_io: body_io)

      LXD.profiles.fetch(name: "profile0") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Profile)
      end
    end
  end

  describe "#update" do
    it "updates profile" do
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

      WebMock.stub(:PATCH, "#{LXD.uri}/profiles/profile0?project=")
        .with(body: %({"config":{"limits.cpu":"4","limits.memory":"4GiB"}}))
        .to_return(body_io: body_io)

      LXD.profiles.update(
        name: "profile0",
        config: {"limits.cpu": "4", "limits.memory": "4GiB"}
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#rename" do
    it "renames profile" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Profile created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:POST, "#{LXD.uri}/profiles/profile0")
        .with(body: %({"name":"profile1"}))
        .to_return(body_io: body_io)

      LXD.profiles.rename(name: "profile0", new_name: "profile1") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates profile" do
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

      WebMock.stub(:PUT, "#{LXD.uri}/profiles/profile0?project=")
        .with(body: %({"config":{"limits.cpu":"4","limits.memory":"4GiB"}}))
        .to_return(body_io: body_io)

      LXD.profiles.replace(
        name: "profile0",
        config: {"limits.cpu": "4", "limits.memory": "4GiB"}
      ) do |response|
        response.success?.should be_true
      end
    end
  end
end
