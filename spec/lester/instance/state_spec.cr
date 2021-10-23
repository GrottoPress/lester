require "../../spec_helper"

describe Lester::Instance::State::Endpoint do
  describe "#fetch" do
    it "fetches state" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "cpu": {
              "usage": 3637691016
            },
            "disk": {
              "additionalProp1": {
                "usage": 502239232
              }
            },
            "memory": {
              "swap_usage": 12297557,
              "swap_usage_peak": 12297557,
              "usage": 73248768,
              "usage_peak": 73785344
            },
            "network": {
              "additionalProp1": {
                "addresses": [
                  {
                    "address": "fd42:4c81:5770:1eaf:216:3eff:fe0c:eedd",
                    "family": "inet6",
                    "netmask": "64",
                    "scope": "global"
                  }
                ],
                "counters": {
                  "bytes_received": 192021,
                  "bytes_sent": 10888579,
                  "errors_received": 14,
                  "errors_sent": 41,
                  "packets_dropped_inbound": 179,
                  "packets_dropped_outbound": 541,
                  "packets_received": 1748,
                  "packets_sent": 964
                },
                "host_name": "vethbbcd39c7",
                "hwaddr": "00:16:3e:0c:ee:dd",
                "mtu": 1500,
                "state": "up",
                "type": "broadcast"
              }
            },
            "pid": 7281,
            "processes": 50,
            "status": "Running",
            "status_code": 0
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/instances/inst4/state")
        .with(query: {"project" => "default"})
        .to_return(body_io: body_io)

      LXD.instances.state.fetch("inst4", project: "default") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Instance::State)
      end
    end
  end

  describe "#replace" do
    it "updates state" do
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
            "class": "task",
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

      WebMock.stub(:PUT, "#{LXD.uri}/instances/inst4/state?project=")
        .with(body: %({"action":"start","force":false}))
        .to_return(body_io: body_io)

      LXD.instances.state.replace(
        instance_name: "inst4",
        action: "start",
        force: false
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end
end
