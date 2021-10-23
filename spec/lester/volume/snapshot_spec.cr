require "../../spec_helper"

describe Lester::Volume::Snapshot::Endpoint do
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
              "config": {
                "size": "50GiB",
                "zfs.remove_snapshots": "true"
              },
              "content_type": "filesystem",
              "description": "My custom volume",
              "expires_at": "2021-03-23T17:38:37.753398689-04:00",
              "name": "snap0"
            }
          ]
        }
        JSON

      WebMock.stub(
        :GET,
        "#{LXD.uri}/storage-pools/pool0/volumes/custom/volume0/snapshots"
      )
        .with(query: {"recursion" => "1", "target" => "lxd0"})
        .to_return(body_io: body_io)

      LXD.volumes.snapshots.list(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
        target: "lxd0"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Volume))
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

      WebMock.stub(
        :POST,
        "#{LXD.uri}/storage-pools/pool0/volumes/custom/volume0/\
          snapshots?project=&target="
      )
        .with(body: %({"name":"snap0"}))
        .to_return(body_io: body_io)

      LXD.volumes.snapshots.create(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
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
        "#{LXD.uri}/storage-pools/pool0/volumes/custom/volume0/\
          snapshots/snap0?project=&target="
      )
        .to_return(body_io: body_io)

      LXD.volumes.snapshots.delete(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
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
            "config": {
              "size": "50GiB",
              "zfs.remove_snapshots": "true"
            },
            "content_type": "filesystem",
            "description": "My custom volume",
            "expires_at": "2021-03-23T17:38:37.753398689-04:00",
            "name": "snap0"
          }
        }
        JSON

      WebMock.stub(
        :GET,
        "#{LXD.uri}/storage-pools/pool0/volumes/custom/volume0/snapshots/snap0"
      ).to_return(body_io: body_io)

      LXD.volumes.snapshots.fetch(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
        name: "snap0"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Volume)
      end
    end
  end

  describe "#update" do
    it "updates snapshot" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(
        :PATCH,
        "#{LXD.uri}/storage-pools/pool0/volumes/custom/volume0/\
          snapshots/snap0?project=&target="
      )
        .with(body: %({"expires_at":"2021-10-26T13:11:03Z"}))
        .to_return(body_io: body_io)

      LXD.volumes.snapshots.update(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
        name: "snap0",
        expires_at: Time.utc(2021, 10, 26, 13, 11, 3)
      ) do |response|
        response.success?.should be_true
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

      WebMock.stub(
        :POST,
        "#{LXD.uri}/storage-pools/pool0/volumes/custom/volume0/\
          snapshots/snap0?project=&target="
      )
        .with(body: %({"name":"snap10"}))
        .to_return(body_io: body_io)

      LXD.volumes.snapshots.rename(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
        name: "snap0",
        new_name: "snap10"
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
          "error": ""
        }
        JSON

      WebMock.stub(
        :PUT,
        "#{LXD.uri}/storage-pools/pool0/volumes/custom/volume0/\
          snapshots/snap0?project=&target="
      )
        .with(body: %({"expires_at":"2021-10-26T13:11:03Z"}))
        .to_return(body_io: body_io)

      LXD.volumes.snapshots.replace(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
        name: "snap0",
        expires_at: Time.utc(2021, 10, 26, 13, 11, 3)
      ) do |response|
        response.success?.should be_true
      end
    end
  end
end
