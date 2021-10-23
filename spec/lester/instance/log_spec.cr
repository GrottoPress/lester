require "../../spec_helper"

describe Lester::Instance::Log::Endpoint do
  describe "#list" do
    it "lists log files" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": [
            "/1.0/instances/inst4/logs/lxc.conf",
            "/1.0/instances/inst4/logs/lxc.log"
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/logs")
        .to_return(body_io: body_io)

      LXD.instances.logs.list(instance_name: "inst4") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(String))
      end
    end
  end

  describe "#delete" do
    it "deletes log file" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200
        }
        JSON

      WebMock.stub(:DELETE, "#{LXD.uri}/instances/inst4/logs/file.log?project=")
        .to_return(body_io: body_io)

      LXD.instances.logs.delete("inst4", "file.log") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "downloads log file" do
      body_io = IO::Memory.new("Lester::Instance::Log::Endpoint#fetch")
      destination = File.tempname("lester-instance-file-endpoint-fetch")

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/logs/file.log")
        .to_return(body_io: body_io)

      LXD.instances.logs.fetch(
        instance_name: "inst4",
        filename: "file.log",
        destination: destination
      ) do |response|
        response.success?.should be_true
        File.read_lines(destination).first?.should eq(body_io.to_s)
      ensure
        File.delete(destination)
      end
    end

    it "saves log file to IO" do
      body_io = IO::Memory.new("Lester::Instance::Log::Endpoint#fetch")
      destination = IO::Memory.new

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/logs/file.log")
        .to_return(body_io: body_io)

      LXD.instances.logs.fetch(
        instance_name: "inst4",
        filename: "file.log",
        destination: destination
      ) do |response|
        response.success?.should be_true
        destination.to_s.should eq(body_io.to_s)
      end
    end
  end
end
