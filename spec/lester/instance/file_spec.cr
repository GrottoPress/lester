require "../../spec_helper"

describe Lester::Instance::File::Endpoint do
  describe "#create" do
    it "creates file" do
      body = <<-JSON
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
        "#{LXD.uri}/instances/inst4/files?path=file.txt&project="
      ).to_return(body: body)

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

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/files")
        .with(query: {"path" => "file.txt"})
        .to_return(body_io: body_io, headers: {
          "X-Lxd-Gid" => "0",
          "X-Lxd-Mode" => "0644",
          "X-Lxd-Type" => "file",
          "X-Lxd-Uid" => "0",
        })

      LXD.instances.files.fetch(
        instance_name: "inst4",
        path: "file.txt",
        destination: destination
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Instance::File)

        response.metadata.try do |metadata|
          metadata.content.should be_nil
          metadata.group_id.should eq(0)
          metadata.permissions.should eq("0644")
          metadata.type.try(&.file?).should be_true
          metadata.user_id.should eq(0)
        end

        File.read_lines(destination).first?.should eq(body_io.to_s)
      ensure
        File.delete(destination)
      end
    end

    it "saves file to IO" do
      body_io = IO::Memory.new("Lester::Instance::File::Endpoint#fetch")
      destination = IO::Memory.new

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/files")
        .with(query: {"path" => "file.txt"})
        .to_return(body_io: body_io, headers: {
          "X-Lxd-Gid" => "0",
          "X-Lxd-Mode" => "0644",
          "X-Lxd-Type" => "file",
          "X-Lxd-Uid" => "0",
        })

      LXD.instances.files.fetch(
        instance_name: "inst4",
        path: "file.txt",
        destination: destination
      ) do |response|
        response.success?.should be_true
        destination.to_s.should eq(body_io.to_s)
      end
    end

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

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/files")
        .with(query: {"path" => "/root"})
        .to_return(body_io: body_io, headers: {
          "X-Lxd-Gid" => "0",
          "X-Lxd-Mode" => "0700",
          "X-Lxd-Type" => "directory",
          "X-Lxd-Uid" => "0",
        })

      LXD.instances.files.fetch("inst4", path: "/root") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Instance::File)

        response.metadata.try do |metadata|
          metadata.content.should be_a(Array(String))
          metadata.group_id.should eq(0)
          metadata.permissions.should eq("0700")
          metadata.type.try(&.directory?).should be_true
          metadata.user_id.should eq(0)
        end
      end
    end
  end

  describe "#delete" do
    it "deletes file" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200
        }
        JSON

      WebMock.stub(
        :DELETE,
        "#{LXD.uri}/instances/inst4/files?path=file.txt&project="
      ).to_return(body: body)

      LXD.instances.files.delete("inst4", "file.txt") do |response|
        response.success?.should be_true
      end
    end
  end
end
