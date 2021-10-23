require "../../spec_helper"

describe Lester::Instance::Console::Endpoint do
  describe "#connect" do
    it "connects to console" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": "",
          "metadata": {
            "id": "a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
            "class": "websocket",
            "description": "Refreshing image",
            "created_at": "2021-10-12T12:34:48.04092704Z",
            "updated_at": "2021-10-12T12:34:48.04092704Z",
            "status": "Running",
            "status_code": 103,
            "resources": null,
            "metadata": null,
            "may_cancel": false,
            "err": "",
            "location": "none"
          }
        }
        JSON

      WebMock.stub(
        :POST,
        "#{LXD_BASE_URI}/1.0/instances/inst4/console?project="
      )
        .with(body: %({"height":24,"type":"console","width":80}))
        .to_return(body_io: body_io)

      LXD.instances.console.connect(
        instance_name: "inst4",
        height: 24,
        type: "console",
        width: 80
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#output" do
    it "writes console log to a file" do
      body_io = IO::Memory.new("Lester::Instance::Console::Endpoint#output")
      destination = File.tempname("lester-instance-console-endpoint-output")

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/instances/inst4/console")
        .to_return(body_io: body_io)

      LXD.instances.console.output("inst4", destination) do |response|
        response.success?.should be_true
        File.read_lines(destination).first?.should eq(body_io.to_s)
      ensure
        File.delete(destination)
      end
    end

    it "saves output to IO" do
      body_io = IO::Memory.new("Lester::Instance::Console::Endpoint#output")
      destination = IO::Memory.new

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/instances/inst4/console")
        .to_return(body_io: body_io)

      LXD.instances.console.output("inst4", destination) do |response|
        response.success?.should be_true
        destination.to_s.should eq(body_io.to_s)
      end
    end
  end

  describe "#clear" do
    it "clears console log" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200
        }
        JSON

      WebMock.stub(
        :DELETE,
        "#{LXD_BASE_URI}/1.0/instances/inst4/console?project="
      ).to_return(body_io: body_io)

      LXD.instances.console.clear(instance_name: "inst4") do |response|
        response.success?.should be_true
      end
    end
  end
end
