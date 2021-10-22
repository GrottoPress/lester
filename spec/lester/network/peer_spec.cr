require "../../spec_helper"

describe Lester::Network::Peer::Endpoint do
  describe "#list" do
    it "lists peers" do
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
                "user.mykey": "foo"
              },
              "description": "Peering with network1 in project1",
              "name": "project1-network1",
              "status": "Pending",
              "target_network": "network1",
              "target_project": "project1"
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/networks/lxdbr0/peers")
        .with(query: {"recursion" => "1"})
        .to_return(body_io: body_io)

      LXD.networks.peers.list(network_name: "lxdbr0") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Network::Peer))
      end
    end
  end

  describe "#create" do
    it "creates peer" do
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

      WebMock.stub(:POST, "#{LXD_BASE_URI}/1.0/networks/lxdbr0/peers?project=")
        .with(body: %({\
          "name":"peer1",\
          "config":{"user.mykey":"foo"},\
          "description":"Peering with lxdbr0"\
        }))
        .to_return(body_io: body_io)

      LXD.networks.peers.create(
        network_name: "lxdbr0",
        name: "peer1",
        config: {"user.mykey": "foo"},
        description: "Peering with lxdbr0"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#delete" do
    it "deletes peer" do
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

      WebMock.stub(
        :DELETE,
        "#{LXD_BASE_URI}/1.0/networks/lxdbr0/peers/peer0?project="
      ).to_return(body_io: body_io)

      LXD.networks.peers.delete(
        network_name: "lxdbr0",
        name: "peer0"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches peer" do
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
              "user.mykey": "foo"
            },
            "description": "Peering with network1 in project1",
            "name": "project1-network1",
            "status": "Pending",
            "target_network": "network1",
            "target_project": "project1"
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/networks/lxdbr0/peers/peer0")
        .to_return(body_io: body_io)

      LXD.networks.peers.fetch(
        network_name: "lxdbr0",
        name: "peer0"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Network::Peer)
      end
    end
  end

  describe "#update" do
    it "updates peer" do
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
        "#{LXD_BASE_URI}/1.0/networks/lxdbr0/peers/peer0?project="
      )
        .with(body: %({"config":{"user.mykey":"bar"}}))
        .to_return(body_io: body_io)

      LXD.networks.peers.update(
        network_name: "lxdbr0",
        name: "peer0",
        config: {"user.mykey": "bar"}
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates peer" do
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
        :PUT,
        "#{LXD_BASE_URI}/1.0/networks/lxdbr0/peers/peer0?project="
      )
        .with(body: %({"config":{"user.mykey":"bar"}}))
        .to_return(body_io: body_io)

      LXD.networks.peers.replace(
        network_name: "lxdbr0",
        name: "peer0",
        config: {"user.mykey": "bar"}
      ) do |response|
        response.success?.should be_true
      end
    end
  end
end
