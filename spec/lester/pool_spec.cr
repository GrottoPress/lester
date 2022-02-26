require "../spec_helper"

describe Lester::Pool::Endpoint do
  describe "#list" do
    it "lists storage pools" do
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
                "volume.block.filesystem": "ext4",
                "volume.size": "50GiB"
              },
              "description": "Local SSD pool",
              "driver": "zfs",
              "locations": [
                "lxd01",
                "lxd02",
                "lxd03"
              ],
              "name": "local",
              "status": "Created",
              "used_by": [
                "/1.0/profiles/default",
                "/1.0/instances/c1"
              ]
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/storage-pools")
        .with(query: {"recursion" => "1"})
        .to_return(body: body)

      LXD.pools.list do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Pool))
      end
    end
  end

  describe "#create" do
    it "creates storage pool" do
      body = <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:POST, "#{LXD.uri}/storage-pools?project=&target=")
        .with(body: %({"driver":"zfs","name":"local"}))
        .to_return(body: body)

      LXD.pools.create(driver: "zfs", name: "local") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#delete" do
    it "deletes storage pool" do
      body = <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:DELETE, "#{LXD.uri}/storage-pools/pool0?project=")
        .to_return(body: body)

      LXD.pools.delete(name: "pool0") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches storage pool" do
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
              "volume.block.filesystem": "ext4",
              "volume.size": "50GiB"
            },
            "description": "Local SSD pool",
            "driver": "zfs",
            "locations": [
              "lxd01",
              "lxd02",
              "lxd03"
            ],
            "name": "local",
            "status": "Created",
            "used_by": [
              "/1.0/profiles/default",
              "/1.0/instances/c1"
            ]
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/storage-pools/pool0")
        .with(query: {"target" => "lxd0"})
        .to_return(body: body)

      LXD.pools.fetch(name: "pool0", target: "lxd0") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Pool)
      end
    end
  end

  describe "#update" do
    it "updates storage pool" do
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

      WebMock.stub(:PATCH, "#{LXD.uri}/storage-pools/pool0?project=&target=")
        .with(body: %({"description":"Local SSD pool"}))
        .to_return(body: body)

      LXD.pools.update(
        name: "pool0",
        description: "Local SSD pool"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates storage pool" do
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

      WebMock.stub(:PUT, "#{LXD.uri}/storage-pools/pool0?project=&target=")
        .with(body: %({"description":"Local SSD pool"}))
        .to_return(body: body)

      LXD.pools.replace(
        name: "pool0",
        description: "Local SSD pool"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#resources" do
    it "retrieves storage pool resource usage" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "inodes": {
              "total": 30709993797,
              "used": 23937695
            },
            "space": {
              "total": 420100937728,
              "used": 343537419776
            }
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/storage-pools/pool0/resources")
        .with(query: {"target" => "lxd0"})
        .to_return(body: body)

      LXD.pools.resources(name: "pool0", target: "lxd0") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Pool::Resources)
      end
    end
  end
end
