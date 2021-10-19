require "../../spec_helper"

describe Lester::Volume::Backup::Endpoint do
  describe "#list" do
    it "lists backups" do
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
              "created_at": "2021-03-23T16:38:37.753398689-04:00",
              "expires_at": "2021-03-23T17:38:37.753398689-04:00",
              "name": "backup0",
              "optimized_storage": true,
              "volume_only": false
            }
          ]
        }
        JSON

      WebMock.stub(
        :GET,
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom/\
          volume0/backups"
      )
        .with(query: {"recursion" => "1", "project" => "default"})
        .to_return(body_io: body_io)

      LXD.volumes.backups.list(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
        project: "default"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Volume::Backup))
      end
    end
  end

  describe "#create" do
    it "creates backup" do
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
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom/volume0/\
          backups?project=&target="
      )
        .with(body: %({"name":"backup0","compression_algorithm":"gzip"}))
        .to_return(body_io: body_io)

      LXD.volumes.backups.create(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
        name: "backup0",
        compression_algorithm: "gzip"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#delete" do
    it "deletes backup" do
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
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom/volume0/\
          backups/backup0?project=&target="
      ).to_return(body_io: body_io)

      LXD.volumes.backups.delete(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
        name: "backup0"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#fetch" do
    it "fetches backup" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "created_at": "2021-03-23T16:38:37.753398689-04:00",
            "expires_at": "2021-03-23T17:38:37.753398689-04:00",
            "name": "backup0",
            "optimized_storage": true,
            "volume_only": false
          }
        }
        JSON

      WebMock.stub(
        :GET,
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom/volume0/\
          backups/backup0"
      ).to_return(body_io: body_io)

      LXD.volumes.backups.fetch(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
        name: "backup0"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Volume::Backup)
      end
    end
  end

  describe "#rename" do
    it "renames backup" do
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
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom/volume0/\
          backups/backup0?project=&target="
      )
        .with(body: %({"name":"backup1"}))
        .to_return(body_io: body_io)

      LXD.volumes.backups.rename(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
        name: "backup0",
        new_name: "backup1"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#export" do
    it "downloads raw backup file" do
      body_io = IO::Memory.new("Lester::Volume::Backup::Endpoint#export")
      destination = File.tempname("lester-volume-backup-endpoint-export")

      WebMock.stub(
        :GET,
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom/volume0/\
          backups/backup0/export"
      ).to_return(body_io: body_io)

      LXD.volumes.backups.export(
        pool_name: "pool0",
        volume_name: "volume0",
        volume_type: "custom",
        name: "backup0",
        destination: destination
      ) do |response|
        response.success?.should be_true
        File.read_lines(destination).first?.should eq(body_io.to_s)
      ensure
        File.delete(destination)
      end
    end
  end
end
