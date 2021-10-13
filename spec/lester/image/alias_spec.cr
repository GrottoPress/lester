require "../../spec_helper"

describe Lester::Image::Alias::Endpoint do
  describe "#list" do
    it "lists aliases" do
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
              "description": "Our preferred Ubuntu image",
              "name": "ubuntu-20.04",
              "target": "06b86454720d36b20f94e31c6812e05ec51c1b568cf3a",
              "type": "container"
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/images/aliases")
        .with(query: {"recursion" => "1", "project" => "default"})
        .to_return(body_io: body_io)

      LXD.images.aliases.list(project: "default") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Image::Alias))
      end
    end
  end

  describe "#create" do
    it "creates alias" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:POST, "#{LXD_BASE_URI}/1.0/images/aliases?project=default")
        .with(body: %({\
          "description":"Ubuntu image",\
          "name":"ubuntu-20.04",\
          "target":"a1b2c3",\
          "type":"container"\
        }))
        .to_return(body_io: body_io)

      LXD.images.aliases.create(
        project: "default",
        description: "Ubuntu image",
        name: "ubuntu-20.04",
        target: "a1b2c3",
        type: "container"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#delete" do
    it "deletes alias" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:DELETE, "#{LXD_BASE_URI}/1.0/images/aliases/a1b2c3")
        .with(query: {"project" => "default"})
        .to_return(body_io: body_io)

      LXD.images.aliases.delete(
        name: "a1b2c3",
        project: "default"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches alias" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "description": "Our preferred Ubuntu image",
            "name": "ubuntu-20.04",
            "target": "06b86454720d36b20f94e31c6812e05ec51c1b568cf3",
            "type": "container"
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/images/aliases/awesome")
        .to_return(body_io: body_io)

      LXD.images.aliases.fetch(name: "awesome") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Image::Alias)
      end
    end
  end

  describe "#update" do
    it "updates alias" do
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

      WebMock.stub(:PATCH, "#{LXD_BASE_URI}/1.0/images/aliases/a1b2c3?project=")
        .with(body: %({"description":"New ubuntu image"}))
        .to_return(body_io: body_io)

      LXD.images.aliases.update(
        name: "a1b2c3",
        description: "New ubuntu image"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#rename" do
    it "renames alias" do
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

      WebMock.stub(:POST, "#{LXD_BASE_URI}/1.0/images/aliases/a1b2c3?project=")
        .with(body: %({"name":"beautiful"}))
        .to_return(body_io: body_io)

      LXD.images.aliases.rename(
        name: "a1b2c3",
        new_name: "beautiful"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates alias" do
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

      WebMock.stub(:PUT, "#{LXD_BASE_URI}/1.0/images/aliases/a1b2c3?project=")
        .with(body: %({"description":"New ubuntu image","target":"06b864547"}))
        .to_return(body_io: body_io)

      LXD.images.aliases.replace(
        name: "a1b2c3",
        description: "New ubuntu image",
        target: "06b864547"
      ) do |response|
        response.success?.should be_true
      end
    end
  end
end
