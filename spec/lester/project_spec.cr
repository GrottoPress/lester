require "../spec_helper"

describe Lester::Project::Endpoint do
  describe "#list" do
    it "lists projects" do
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
                "features.networks": "false",
                "features.profiles": "true"
              },
              "description": "My new project",
              "name": "foo",
              "used_by": [
                "/1.0/images/0e60015346f06627f10580d56ac7fffd9ea77",
                "/1.0/instances/c1",
                "/1.0/networks/lxdbr0",
                "/1.0/profiles/default",
                "/1.0/storage-pools/default/volumes/custom/blah"
              ]
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/projects")
        .with(query: {"recursion" => "1"})
        .to_return(body_io: body_io)

      LXD.projects.list do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Project))
      end
    end
  end

  describe "#create" do
    it "creates project" do
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

      WebMock.stub(:POST, "#{LXD.uri}/projects")
        .with(body: %({\
          "name":"project1",\
          "config":{"features.profiles":"true"},\
          "description":"My new project"\
        }))
        .to_return(body_io: body_io)

      LXD.projects.create(
        name: "project1",
        config: {"features.profiles": "true"},
        description: "My new project"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#delete" do
    it "deletes project" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Project created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:DELETE, "#{LXD.uri}/projects/project0")
        .to_return(body_io: body_io)

      LXD.projects.delete(name: "project0") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches project" do
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
              "features.networks": "false",
              "features.profiles": "true"
            },
            "description": "My new project",
            "name": "foo",
            "used_by": [
              "/1.0/images/0e60015346f06627f10580d56ac7fffd9ea77",
              "/1.0/instances/c1",
              "/1.0/networks/lxdbr0",
              "/1.0/profiles/default",
              "/1.0/storage-pools/default/volumes/custom/blah"
            ]
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/projects/project0")
        .to_return(body_io: body_io)

      LXD.projects.fetch(name: "project0") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Project)
      end
    end
  end

  describe "#update" do
    it "updates project" do
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

      WebMock.stub(:PATCH, "#{LXD.uri}/projects/project0")
        .with(body: %({"config":{"features.profiles":"true"}}))
        .to_return(body_io: body_io)

      LXD.projects.update(
        name: "project0",
        config: {"features.profiles": "true"}
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#rename" do
    it "renames project" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Project created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:POST, "#{LXD.uri}/projects/project0")
        .with(body: %({"name":"project1"}))
        .to_return(body_io: body_io)

      LXD.projects.rename(name: "project0", new_name: "project1") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates project" do
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

      WebMock.stub(:PUT, "#{LXD.uri}/projects/project0")
        .with(body: %({"config":{"features.profiles":"true"}}))
        .to_return(body_io: body_io)

      LXD.projects.replace(
        name: "project0",
        config: {"features.profiles": "true"}
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#state" do
    it "gets project state" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "resources": {
              "containers": {
                "Limit": -1,
                "Usage": 1
              },
              "cpu": {
                "Limit": -1,
                "Usage": 0
              },
              "disk": {
                "Limit": -1,
                "Usage": 0
              },
              "instances": {
                "Limit": -1,
                "Usage": 1
              },
              "memory": {
                "Limit": -1,
                "Usage": 0
              },
              "networks": {
                "Limit": -1,
                "Usage": 1
              },
              "processes": {
                "Limit": -1,
                "Usage": 0
              },
              "virtual-machines": {
                "Limit": -1,
                "Usage": 0
              }
            }
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/projects/project0/state")
        .to_return(body_io: body_io)

      LXD.projects.state(name: "project0") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Project::State)

        response.metadata.try &.resources
          .try(&.virtual_machines.try &.limit)
          .should(eq -1)
      end
    end
  end
end
