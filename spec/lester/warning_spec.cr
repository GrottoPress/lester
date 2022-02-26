require "../spec_helper"

describe Lester::Warning::Endpoint do
  describe "#list" do
    it "lists warnings" do
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
              "count": 1,
              "entity_url": "/1.0/instances/c1?project=default",
              "first_seen_at": "2021-03-23T17:38:37.753398689-04:00",
              "last_message": "Couldn't find the CGroup blkio.weight",
              "last_seen_at": "2021-03-23T17:38:37.753398689-04:00",
              "location": "node1",
              "project": "default",
              "severity": "low",
              "status": "new",
              "type": "Couldn't find CGroup",
              "uuid": "e9e9da0d-2538-4351-8047-46d4a8ae4dbb"
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/warnings")
        .with(query: {"project" => "default", "recursion" => "1"})
        .to_return(body: body)

      LXD.warnings.list(project: "default") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Warning))
      end
    end
  end

  describe "#delete" do
    it "deletes warning" do
      body = <<-JSON
        {
          "type": "async",
          "status": "Warning created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": ""
        }
        JSON

      WebMock.stub(:DELETE, "#{LXD.uri}/warnings/a1b2c3")
        .to_return(body: body)

      LXD.warnings.delete(uuid: "a1b2c3") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#fetch" do
    it "fetches warning" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "count": 1,
            "entity_url": "/1.0/instances/c1?project=default",
            "first_seen_at": "2021-03-23T17:38:37.753398689-04:00",
            "last_message": "Couldn't find the CGroup blkio.weight",
            "last_seen_at": "2021-03-23T17:38:37.753398689-04:00",
            "location": "node1",
            "project": "default",
            "severity": "low",
            "status": "new",
            "type": "Couldn't find CGroup",
            "uuid": "e9e9da0d-2538-4351-8047-46d4a8ae4dbb"
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/warnings/a1b2c3")
        .to_return(body: body)

      LXD.warnings.fetch(uuid: "a1b2c3") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Warning)
      end
    end
  end

  describe "#update" do
    it "updates warning" do
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

      WebMock.stub(:PATCH, "#{LXD.uri}/warnings/a1b2c3")
        .with(body: %({"status":"new"}))
        .to_return(body: body)

      LXD.warnings.update(uuid: "a1b2c3", status: "new") do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates warning" do
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

      WebMock.stub(:PUT, "#{LXD.uri}/warnings/a1b2c3")
        .with(body: %({"status":"new"}))
        .to_return(body: body)

      LXD.warnings.replace(uuid: "a1b2c3", status: "new") do |response|
        response.success?.should be_true
      end
    end
  end
end
