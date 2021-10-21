require "../spec_helper"

describe Lester::Network::Endpoint do
  describe "#list" do
    it "lists networks" do
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
                "ipv4.address": "10.0.0.1/24",
                "ipv4.nat": "true",
                "ipv6.address": "none"
              },
              "description": "My new LXD bridge",
              "locations": [
                "lxd01",
                "lxd02",
                "lxd03"
              ],
              "managed": true,
              "name": "lxdbr0",
              "status": "Created",
              "type": "bridge",
              "used_by": [
                "/1.0/profiles/default",
                "/1.0/instances/c1"
              ]
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/networks")
        .with(query: {"project" => "default", "recursion" => "1"})
        .to_return(body_io: body_io)

      LXD.networks.list(project: "default") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Network))
      end
    end
  end

  describe "#create" do
    it "creates network" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Network created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:POST, "#{LXD_BASE_URI}/1.0/networks?project=&target=")
        .with(body: %({"name":"lxdbr0","type":"bridge"}))
        .to_return(body_io: body_io)

      LXD.networks.create(name: "lxdbr0", type: "bridge") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#delete" do
    it "deletes network" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Network created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:DELETE, "#{LXD_BASE_URI}/1.0/networks/lxdbr0?project=")
        .to_return(body_io: body_io)

      LXD.networks.delete(name: "lxdbr0") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches network" do
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
              "ipv4.address": "10.0.0.1/24",
              "ipv4.nat": "true",
              "ipv6.address": "none"
            },
            "description": "My new LXD bridge",
            "locations": [
              "lxd01",
              "lxd02",
              "lxd03"
            ],
            "managed": true,
            "name": "lxdbr0",
            "status": "Created",
            "type": "bridge",
            "used_by": [
              "/1.0/profiles/default",
              "/1.0/instances/c1"
            ]
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/networks/lxdbr0")
        .to_return(body_io: body_io)

      LXD.networks.fetch(name: "lxdbr0") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Network)
      end
    end
  end

  describe "#update" do
    it "updates network" do
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

      WebMock.stub(
        :PATCH,
        "#{LXD_BASE_URI}/1.0/networks/lxdbr0?project=&target="
      )
        .with(body: %({"config":{"ipv4.nat":"true","ipv6.address":"none"}}))
        .to_return(body_io: body_io)

      LXD.networks.update(
        name: "lxdbr0",
        config: {"ipv4.nat": "true", "ipv6.address": "none"}
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#rename" do
    it "renames network" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Network created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:POST, "#{LXD_BASE_URI}/1.0/networks/lxdbr0?project=")
        .with(body: %({"name":"lxdbr10"}))
        .to_return(body_io: body_io)

      LXD.networks.rename(name: "lxdbr0", new_name: "lxdbr10") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates network" do
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

      WebMock.stub(:PUT, "#{LXD_BASE_URI}/1.0/networks/lxdbr0?project=&target=")
        .with(body: %({"config":{"ipv4.nat":"true","ipv6.address":"none"}}))
        .to_return(body_io: body_io)

      LXD.networks.replace(
        name: "lxdbr0",
        config: {"ipv4.nat": "true", "ipv6.address": "none"}
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#leases" do
    it "lists DHCP leases for the network" do
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
              "address": "10.0.0.98",
              "hostname": "c1",
              "hwaddr": "00:16:3e:2c:89:d9",
              "location": "lxd01",
              "type": "dynamic"
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/networks/lxdbr0/leases")
        .to_return(body_io: body_io)

      LXD.networks.leases(name: "lxdbr0") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Network::Lease))
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
            "addresses": [
              {
                "address": "10.0.0.1",
                "family": "inet",
                "netmask": "24",
                "scope": "global"
              }
            ],
            "bond": {
              "down_delay": 0,
              "lower_devices": [
                "eth0",
                "eth1"
              ],
              "mii_frequency": 100,
              "mii_state": "up",
              "mode": "802.3ad",
              "transmit_policy": "layer3+4",
              "up_delay": 0
            },
            "bridge": {
              "forward_delay": 1500,
              "id": "8000.0a0f7c6edbd9",
              "stp": false,
              "upper_devices": [
                "eth0",
                "eth1"
              ],
              "vlan_default": 1,
              "vlan_filtering": false
            },
            "counters": {
              "bytes_received": 250542118,
              "bytes_sent": 17524040140,
              "packets_received": 1182515,
              "packets_sent": 1567934
            },
            "hwaddr": "00:16:3e:5a:83:57",
            "mtu": 1500,
            "state": "up",
            "type": "broadcast",
            "vlan": {
              "lower_device": "eth0",
              "vid": 100
            }
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/networks/lxdbr0/state")
        .to_return(body_io: body_io)

      LXD.networks.state(name: "lxdbr0") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Network::State)
      end
    end
  end
end
