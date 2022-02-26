require "../spec_helper"

describe Lester::Operation::Endpoint do
  describe "#list" do
    it "lists operations" do
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
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/operations").to_return(body: body)

      LXD.operations.list do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Operation))
      end
    end
  end

  describe "#delete" do
    it "deletes operation" do
      body = <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:DELETE, "#{LXD.uri}/operations/a1b2c3")
        .to_return(body: body)

      LXD.operations.delete(id: "a1b2c3") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches operation" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
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

      WebMock.stub(:GET, "#{LXD.uri}/operations/a1b2c3")
        .to_return(body: body)

      LXD.operations.fetch(id: "a1b2c3") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
        response.metadata.try(&.success?).should be_true
      end
    end
  end

  describe "#wait" do
    it "waits for operation to complete" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
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

      WebMock.stub(:GET, "#{LXD.uri}/operations/a1b2c3/wait")
        .with(query: {"timeout" => "-1", "public" => "", "secret" => "abc"})
        .to_return(body: body)

      LXD.operations.wait(id: "a1b2c3", secret: "abc") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#websocket" do
    pending "connects to operation's websocket stream" do
      # TODO
    end
  end
end
