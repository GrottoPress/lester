require "../../spec_helper"

describe Lester::Cluster::Member::Endpoint do
  describe "#list" do
    it "lists members" do
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
                "scheduler.instance": "all"
              },
              "database": true,
              "description": "AMD Epyc 32c/64t",
              "failure_domain": "rack1",
              "message": "fully operational",
              "roles": [
                "database"
              ],
              "server_name": "lxd01",
              "status": "Online",
              "url": "https://10.0.0.1:8443"
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/cluster/members")
        .with(query: {"recursion" => "1"})
        .to_return(body_io: body_io)

      LXD.cluster.members.list do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Cluster::Member))
      end
    end
  end

  describe "#add" do
    it "requests join token member" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Member added",
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

      WebMock.stub(:POST, "#{LXD_BASE_URI}/1.0/cluster/members")
        .with(body: %({"server_name":"lxd02"}))
        .to_return(body_io: body_io)

      LXD.cluster.members.add(server_name: "lxd02") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#delete" do
    it "deletes member" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Cluster::Member created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:DELETE, "#{LXD_BASE_URI}/1.0/cluster/members/lxd01")
        .to_return(body_io: body_io)

      LXD.cluster.members.delete(name: "lxd01") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches member" do
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
              "scheduler.instance": "all"
            },
            "database": true,
            "description": "AMD Epyc 32c/64t",
            "failure_domain": "rack1",
            "message": "fully operational",
            "roles": [
              "database"
            ],
            "server_name": "lxd01",
            "status": "Online",
            "url": "https://10.0.0.1:8443"
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/cluster/members/lxd01")
        .to_return(body_io: body_io)

      LXD.cluster.members.fetch(name: "lxd01") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Cluster::Member)
      end
    end
  end

  describe "#update" do
    it "updates member" do
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

      WebMock.stub(:PATCH, "#{LXD_BASE_URI}/1.0/cluster/members/lxd01")
        .with(body: %({"failure_domain":"rack1","roles":["database"]}))
        .to_return(body_io: body_io)

      LXD.cluster.members.update(
        name: "lxd01",
        failure_domain: "rack1",
        roles: ["database"]
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#rename" do
    it "renames member" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Cluster::Member created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:POST, "#{LXD_BASE_URI}/1.0/cluster/members/lxd01")
        .with(body: %({"server_name":"lxd02"}))
        .to_return(body_io: body_io)

      LXD.cluster.members.rename(name: "lxd01", new_name: "lxd02") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates member" do
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

      WebMock.stub(:PUT, "#{LXD_BASE_URI}/1.0/cluster/members/lxd01")
        .with(body: %({"failure_domain":"rack1","roles":["database"]}))
        .to_return(body_io: body_io)

      LXD.cluster.members.replace(
        name: "lxd01",
        failure_domain: "rack1",
        roles: ["database"]
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#state" do
    it "gets network state" do
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

      WebMock.stub(:POST, "#{LXD_BASE_URI}/1.0/cluster/members/lxd01/state")
        .with(body: %({"action":"evacuate"}))
        .to_return(body_io: body_io)

      LXD.cluster.members.state(name: "lxd01", action: "evacuate") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end
end
