require "../spec_helper"

describe Lester::Volume::Endpoint do
  describe "#list" do
    it "lists volumes" do
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
              "location": "lxd01",
              "name": "foo",
              "restore": "snap0",
              "type": "custom",
              "used_by": [
                "/1.0/instances/blah"
              ]
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes")
        .with(query: {"target" => "lxd0", "recursion" => "1"})
        .to_return(body_io: body_io)

      LXD.volumes.list(pool_name: "pool0", target: "lxd0") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Volume))
      end
    end

    it "lists volumes of a given type" do
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
              "location": "lxd01",
              "name": "foo",
              "restore": "snap0",
              "type": "custom",
              "used_by": [
                "/1.0/instances/blah"
              ]
            }
          ]
        }
        JSON

      WebMock.stub(
        :GET,
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom"
      )
        .with(query: {"recursion" => "1"})
        .to_return(body_io: body_io)

      LXD.volumes.list(pool_name: "pool0", type: "custom") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Volume))
      end
    end
  end

  describe "#create" do
    it "creates volume" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": "",
          "metadata": {
            "class": "websocket",
            "created_at": "2021-03-23T17:38:37.753398689-04:00",
            "description": "Executing command",
            "err": "Some error message",
            "id": "6916c8a6-9b7d-4abd-90b3-aedfec7ec7da",
            "location": "lxd01",
            "may_cancel": false,
            "metadata": {
              "command": [
                "bash"
              ],
              "environment": {
                "HOME": "/root",
                "LANG": "C.UTF-8",
                "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin",
                "TERM": "xterm",
                "USER": "root"
              },
              "fds": {
                "0": "da3046cf02c0116febf4ef3fe4eaecdf308e720c05e5a9c",
                "1": "05896879d8692607bd6e4a09475667da3b5f6714418ab0e"
              },
              "interactive": true
            },
            "resources": {
              "containers": [
                "/1.0/containers/foo"
              ],
              "instances": [
                "/1.0/instances/foo"
              ]
            },
            "status": "Running",
            "status_code": 0,
            "updated_at": "2021-03-23T17:38:37.753398689-04:00"
          }
        }
        JSON

      WebMock.stub(
        :POST,
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes?project=&target="
      )
        .with(body: %({"content_type":"filesystem","description":"My volume"}))
        .to_return(body_io: body_io)

      LXD.volumes.create(
        pool_name: "pool0",
        content_type: "filesystem",
        description: "My volume"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end

    it "creates volume of a given type" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": "",
          "metadata": {
            "class": "websocket",
            "created_at": "2021-03-23T17:38:37.753398689-04:00",
            "description": "Executing command",
            "err": "Some error message",
            "id": "6916c8a6-9b7d-4abd-90b3-aedfec7ec7da",
            "location": "lxd01",
            "may_cancel": false,
            "metadata": {
              "command": [
                "bash"
              ],
              "environment": {
                "HOME": "/root",
                "LANG": "C.UTF-8",
                "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin",
                "TERM": "xterm",
                "USER": "root"
              },
              "fds": {
                "0": "da3046cf02c0116febf4ef3fe4eaecdf308e720c05e5a9c",
                "1": "05896879d8692607bd6e4a09475667da3b5f6714418ab0e"
              },
              "interactive": true
            },
            "resources": {
              "containers": [
                "/1.0/containers/foo"
              ],
              "instances": [
                "/1.0/instances/foo"
              ]
            },
            "status": "Running",
            "status_code": 0,
            "updated_at": "2021-03-23T17:38:37.753398689-04:00"
          }
        }
        JSON

      WebMock.stub(
        :POST,
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom?project=\
          &target="
      )
        .with(body: %({"content_type":"filesystem","description":"My volume"}))
        .to_return(body_io: body_io)

      LXD.volumes.create(
        pool_name: "pool0",
        type: "custom",
        content_type: "filesystem",
        description: "My volume"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#delete" do
    it "deletes volume" do
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
        :DELETE,
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom/vol0?\
          project=&target="
      ).to_return(body_io: body_io)

      LXD.volumes.delete(
        pool_name: "pool0",
        name: "vol0",
        type: "custom"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches volume" do
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
            "location": "lxd01",
            "name": "foo",
            "restore": "snap0",
            "type": "custom",
            "used_by": [
              "/1.0/instances/blah"
            ]
          }
        }
        JSON

      WebMock.stub(
        :GET,
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom/vol0"
      )
        .with(query: {"target" => "lxd0"})
        .to_return(body_io: body_io)

      LXD.volumes.fetch(
        pool_name: "pool0",
        name: "vol0",
        type: "custom",
        target: "lxd0"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Volume)
      end
    end
  end

  describe "#update" do
    it "updates volume" do
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

      WebMock.stub(
        :PATCH,
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom/vol0?\
          project=&target="
      )
        .with(body: %({"description":"My volume","restore":"snap0"}))
        .to_return(body_io: body_io)

      LXD.volumes.update(
        pool_name: "pool0",
        name: "vol0",
        type: "custom",
        description: "My volume",
        restore: "snap0"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#rename" do
    it "renames volume" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "class": "websocket",
            "created_at": "2021-03-23T17:38:37.753398689-04:00",
            "description": "Executing command",
            "err": "Some error message",
            "id": "6916c8a6-9b7d-4abd-90b3-aedfec7ec7da",
            "location": "lxd01",
            "may_cancel": false,
            "metadata": {
              "command": [
                "bash"
              ],
              "environment": {
                "HOME": "/root",
                "LANG": "C.UTF-8",
                "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin",
                "TERM": "xterm",
                "USER": "root"
              },
              "fds": {
                "0": "da3046cf02c0116febf4ef3fe4eaecdf308e720c05e5a9c",
                "1": "05896879d8692607bd6e4a09475667da3b5f6714418ab0e"
              },
              "interactive": true
            },
            "resources": {
              "containers": [
                "/1.0/containers/foo"
              ],
              "instances": [
                "/1.0/instances/foo"
              ]
            },
            "status": "Running",
            "status_code": 0,
            "updated_at": "2021-03-23T17:38:37.753398689-04:00"
          }
        }
        JSON

      WebMock.stub(
        :POST,
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom/vol0?\
          project=&target="
      )
        .with(body: %({"migration":false,"name":"vol1"}))
        .to_return(body_io: body_io)

      LXD.volumes.rename(
        pool_name: "pool0",
        name: "vol0",
        new_name: "vol1",
        type: "custom",
        migration: false,
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates volume" do
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

      WebMock.stub(
        :PUT,
        "#{LXD_BASE_URI}/1.0/storage-pools/pool0/volumes/custom/vol0?\
          project=&target="
      )
        .with(body: %({"description":"My volume","restore":"snap0"}))
        .to_return(body_io: body_io)

      LXD.volumes.replace(
        pool_name: "pool0",
        name: "vol0",
        type: "custom",
        description: "My volume",
        restore: "snap0"
      ) do |response|
        response.success?.should be_true
      end
    end
  end
end
