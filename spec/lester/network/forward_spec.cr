require "../../spec_helper"

describe Lester::Network::Forward::Endpoint do
  describe "#list" do
    it "lists forwards" do
      body = <<-JSON
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
              "description": "My public IP forward",
              "listen_address": "192.0.2.1",
              "location": "lxd01",
              "ports": [
                {
                  "description": "My web server forward",
                  "listen_port": "80,81,8080-8090",
                  "protocol": "tcp",
                  "target_address": "198.51.100.2",
                  "target_port": "80,81,8080-8090"
                }
              ]
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/networks/lxdbr0/forwards")
        .with(query: {"recursion" => "1"})
        .to_return(body: body)

      LXD.networks.forwards.list(network_name: "lxdbr0") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Network::Forward))
      end
    end
  end

  describe "#create" do
    it "creates forward" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Member added",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:POST, "#{LXD.uri}/networks/lxdbr0/forwards?project=")
        .with(body: %({\
          "listen_address":"4.5.6.7",\
          "config":{"user.mykey":"foo"},\
          "description":"My public IP forward"\
        }))
        .to_return(body: body)

      LXD.networks.forwards.create(
        network_name: "lxdbr0",
        listen_address: "4.5.6.7",
        config: {"user.mykey": "foo"},
        description: "My public IP forward"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#delete" do
    it "deletes forward" do
      body = <<-JSON
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
        "#{LXD.uri}/networks/lxdbr0/forwards/1.2.3.4?project="
      ).to_return(body: body)

      LXD.networks.forwards.delete(
        network_name: "lxdbr0",
        listen_address: "1.2.3.4"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches forward" do
      body = <<-JSON
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
            "description": "My public IP forward",
            "listen_address": "192.0.2.1",
            "location": "lxd01",
            "ports": [
              {
                "description": "My web server forward",
                "listen_port": "80,81,8080-8090",
                "protocol": "tcp",
                "target_address": "198.51.100.2",
                "target_port": "80,81,8080-8090"
              }
            ]
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/networks/lxdbr0/forwards/1.2.3.4")
        .to_return(body: body)

      LXD.networks.forwards.fetch(
        network_name: "lxdbr0",
        listen_address: "1.2.3.4"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Network::Forward)
      end
    end
  end

  describe "#update" do
    it "updates forward" do
      body = <<-JSON
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
        "#{LXD.uri}/networks/lxdbr0/forwards/1.2.3.4?project="
      )
        .with(body: %({"config":{"user.mykey":"bar"}}))
        .to_return(body: body)

      LXD.networks.forwards.update(
        network_name: "lxdbr0",
        listen_address: "1.2.3.4",
        config: {"user.mykey": "bar"}
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates forward" do
      body = <<-JSON
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
        "#{LXD.uri}/networks/lxdbr0/forwards/1.2.3.4?project="
      )
        .with(body: %({"config":{"user.mykey":"bar"}}))
        .to_return(body: body)

      LXD.networks.forwards.replace(
        network_name: "lxdbr0",
        listen_address: "1.2.3.4",
        config: {"user.mykey": "bar"}
      ) do |response|
        response.success?.should be_true
      end
    end
  end
end
