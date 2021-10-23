require "../../spec_helper"

describe Lester::Instance::Snapshot::Endpoint do
  describe "#list" do
    it "lists snapshots" do
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
              "architecture": "x86_64",
              "config": {
                "security.nesting": "true"
              },
              "created_at": "2021-03-23T20:00:00-04:00",
              "devices": {
                "root": {
                  "path": "/",
                  "pool": "default",
                  "type": "disk"
                }
              },
              "ephemeral": false,
              "expanded_config": {
                "security.nesting": "true"
              },
              "expanded_devices": {
                "root": {
                  "path": "/",
                  "pool": "default",
                  "type": "disk"
                }
              },
              "expires_at": "2021-03-23T17:38:37.753398689-04:00",
              "last_used_at": "2021-03-23T20:00:00-04:00",
              "name": "foo",
              "profiles": ["default"],
              "size": 143360,
              "stateful": false
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/snapshots")
        .with(query: {"recursion" => "1", "project" => "default"})
        .to_return(body_io: body_io)

      LXD.instances.snapshots.list("inst4", project: "default") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Instance))
      end
    end
  end

  describe "#create" do
    it "creates snapshot" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": "",
          "metadata": {
            "id": "a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
            "class": "websocket",
            "description": "Refreshing image",
            "created_at": "2021-10-12T12:34:48.04092704Z",
            "updated_at": "2021-10-12T12:34:48.04092704Z",
            "status": "Running",
            "status_code": 103,
            "resources": null,
            "metadata": null,
            "may_cancel": false,
            "err": "",
            "location": "none"
          }
        }
        JSON

      WebMock.stub(:POST, "#{LXD.uri}/instances/inst4/snapshots?project=")
        .with(body: %({"name":"snap0"}))
        .to_return(body_io: body_io)

      LXD.instances.snapshots.create(
        instance_name: "inst4",
        name: "snap0"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#delete" do
    it "deletes snapshot" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": "",
          "metadata": {
            "id": "a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
            "class": "task",
            "description": "Refreshing image",
            "created_at": "2021-10-12T12:34:48.04092704Z",
            "updated_at": "2021-10-12T12:34:48.04092704Z",
            "status": "Running",
            "status_code": 103,
            "resources": null,
            "metadata": null,
            "may_cancel": false,
            "err": "",
            "location": "none"
          }
        }
        JSON

      WebMock.stub(
        :DELETE,
        "#{LXD.uri}/instances/inst4/snapshots/snap0?project="
      )
        .to_return(body_io: body_io)

      LXD.instances.snapshots.delete(
        instance_name: "inst4",
        name: "snap0"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#fetch" do
    it "fetches snapshot" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "architecture": "x86_64",
            "config": {
              "security.nesting": "true"
            },
            "created_at": "2021-03-23T20:00:00-04:00",
            "devices": {
              "root": {
                "path": "/",
                "pool": "default",
                "type": "disk"
              }
            },
            "ephemeral": false,
            "expanded_config": {
              "security.nesting": "true"
            },
            "expanded_devices": {
              "root": {
                "path": "/",
                "pool": "default",
                "type": "disk"
              }
            },
            "expires_at": "2021-03-23T17:38:37.753398689-04:00",
            "last_used_at": "2021-03-23T20:00:00-04:00",
            "name": "foo",
            "profiles": ["default"],
            "size": 143360,
            "stateful": false
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/snapshots/snap0")
        .to_return(body_io: body_io)

      LXD.instances.snapshots.fetch("inst4", "snap0") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Instance)
      end
    end
  end

  describe "#update" do
    it "updates snapshot" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": "",
          "metadata": {
            "id": "a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
            "class": "task",
            "description": "Refreshing image",
            "created_at": "2021-10-12T12:34:48.04092704Z",
            "updated_at": "2021-10-12T12:34:48.04092704Z",
            "status": "Running",
            "status_code": 103,
            "resources": null,
            "metadata": null,
            "may_cancel": false,
            "err": "",
            "location": "none"
          }
        }
        JSON

      WebMock.stub(
        :PATCH,
        "#{LXD.uri}/instances/inst4/snapshots/snap0?project="
      )
        .with(body: %({"expires_at":"2021-10-26T13:11:03Z"}))
        .to_return(body_io: body_io)

      LXD.instances.snapshots.update(
        instance_name: "inst4",
        name: "snap0",
        expires_at: Time.utc(2021, 10, 26, 13, 11, 3)
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#rename" do
    it "renames snapshot" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": "",
          "metadata": {
            "id": "a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
            "class": "websocket",
            "description": "Refreshing image",
            "created_at": "2021-10-12T12:34:48.04092704Z",
            "updated_at": "2021-10-12T12:34:48.04092704Z",
            "status": "Running",
            "status_code": 103,
            "resources": null,
            "metadata": null,
            "may_cancel": false,
            "err": "",
            "location": "none"
          }
        }
        JSON

      WebMock.stub(:POST, "#{LXD.uri}/instances/inst4/snapshots/snap0?project=")
        .with(body: %({"live":false,"name":"debian-snap"}))
        .to_return(body_io: body_io)

      LXD.instances.snapshots.rename(
        instance_name: "inst4",
        name: "snap0",
        new_name: "debian-snap",
        live: false
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#replace" do
    it "updates snapshot" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": "",
          "metadata": {
            "id": "a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
            "class": "task",
            "description": "Refreshing image",
            "created_at": "2021-10-12T12:34:48.04092704Z",
            "updated_at": "2021-10-12T12:34:48.04092704Z",
            "status": "Running",
            "status_code": 103,
            "resources": null,
            "metadata": null,
            "may_cancel": false,
            "err": "",
            "location": "none"
          }
        }
        JSON

      WebMock.stub(:PUT, "#{LXD.uri}/instances/inst4/snapshots/snap0?project=")
        .with(body: %({"expires_at":"2021-10-26T13:11:03Z"}))
        .to_return(body_io: body_io)

      LXD.instances.snapshots.replace(
        instance_name: "inst4",
        name: "snap0",
        expires_at: Time.utc(2021, 10, 26, 13, 11, 3)
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end
end
