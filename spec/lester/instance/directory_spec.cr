require "../../spec_helper"

describe Lester::Instance::Directory::Endpoint do
  describe "#create" do
    it "creates directory" do
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
        "#{LXD_BASE_URI}/1.0/instances/inst4/files?path=dirname&project="
      ).to_return(body_io: body_io)

      LXD.instances.directories.create(
        instance_name: "inst4",
        path: "dirname"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches directory" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": [".config", ".bash_history", ".profile", ".bashrc"]
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/instances/inst4/files")
        .with(query: {"path" => "dirname"})
        .to_return(body_io: body_io)

      LXD.instances.directories.fetch("inst4", "dirname") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(String))
      end
    end
  end

  describe "#delete" do
    it "deletes directory" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200
        }
        JSON

      WebMock.stub(
        :DELETE,
        "#{LXD_BASE_URI}/1.0/instances/inst4/files?path=dirname&project="
      ).to_return(body_io: body_io)

      LXD.instances.directories.delete("inst4", "dirname") do |response|
        response.success?.should be_true
      end
    end
  end
end
