require "../../spec_helper"

describe Lester::Instance::File::Endpoint do
  describe "#create" do
    it "creates file" do
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
        "#{LXD_BASE_URI}/1.0/instances/inst4/files?path=file.txt&project="
      ).to_return(body_io: body_io)

      LXD.instances.files.create(
        instance_name: "inst4",
        path: "file.txt",
        content: "Lester::Instance::File::Endpoint#create"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches file" do
      body_io = IO::Memory.new("Lester::Instance::File::Endpoint#fetch")
      destination = File.tempname("lester-instance-file-endpoint-fetch")

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/instances/inst4/files")
        .with(query: {"path" => "file.txt"})
        .to_return(body_io: body_io)

      LXD.instances.files.fetch(
        instance_name: "inst4",
        path: "file.txt",
        destination: destination
      ) do |response|
        response.success?.should be_true
        File.read_lines(destination).first?.should eq(body_io.to_s)
      ensure
        File.delete(destination)
      end
    end

    it "saves file to IO" do
      body_io = IO::Memory.new("Lester::Instance::File::Endpoint#fetch")
      destination = IO::Memory.new

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/instances/inst4/files")
        .with(query: {"path" => "file.txt"})
        .to_return(body_io: body_io)

      LXD.instances.files.fetch(
        instance_name: "inst4",
        path: "file.txt",
        destination: destination
      ) do |response|
        response.success?.should be_true
        destination.to_s.should eq(body_io.to_s)
      end
    end
  end

  describe "#delete" do
    it "deletes file" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200
        }
        JSON

      WebMock.stub(
        :DELETE,
        "#{LXD_BASE_URI}/1.0/instances/inst4/files?path=file.txt&project="
      ).to_return(body_io: body_io)

      LXD.instances.files.delete("inst4", "file.txt") do |response|
        response.success?.should be_true
      end
    end
  end
end
