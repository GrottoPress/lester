require "../../spec_helper"

describe Lester::Instance::Template::Endpoint do
  describe "#list" do
    it "lists templates" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error":"",
          "metadata": ["hostname.tpl", "hosts.tpl"]
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/metadata/templates")
        .to_return(body_io: body_io)

      LXD.instances.templates.list(instance_name: "inst4") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(String))
      end
    end
  end

  describe "#create" do
    it "creates template" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(
        :POST,
        "#{LXD.uri}/instances/inst4/metadata/templates?path=file.tpl&project="
      ).to_return(body_io: body_io)

      LXD.instances.templates.create(
        instance_name: "inst4",
        path: "file.tpl",
        content: "Lester::Instance::Template::Endpoint#create"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#delete" do
    it "deletes template" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200
        }
        JSON

      WebMock.stub(
        :DELETE,
        "#{LXD.uri}/instances/inst4/metadata/templates?path=file.tpl&project="
      ).to_return(body_io: body_io)

      LXD.instances.templates.delete("inst4", "file.tpl") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "downloads template" do
      body_io = IO::Memory.new("Lester::Instance::Template::Endpoint#fetch")
      destination = File.tempname("lester-instance-file-endpoint-fetch")

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/metadata/templates")
        .with(query: {"path" => "file.tpl"})
        .to_return(body_io: body_io)

      LXD.instances.templates.fetch(
        instance_name: "inst4",
        path: "file.tpl",
        destination: destination
      ) do |response|
        response.success?.should be_true
        File.read_lines(destination).first?.should eq(body_io.to_s)
      ensure
        File.delete(destination)
      end
    end

    it "saved template to IO" do
      body_io = IO::Memory.new("Lester::Instance::Template::Endpoint#fetch")
      destination = IO::Memory.new

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/metadata/templates")
        .with(query: {"path" => "file.tpl"})
        .to_return(body_io: body_io)

      LXD.instances.templates.fetch(
        instance_name: "inst4",
        path: "file.tpl",
        destination: destination
      ) do |response|
        response.success?.should be_true
        destination.to_s.should eq(body_io.to_s)
      end
    end
  end
end
