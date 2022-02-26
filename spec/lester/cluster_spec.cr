require "../spec_helper"

describe Lester::Cluster::Endpoint do
  describe "#fetch" do
    it "fetches cluster" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "enabled": true,
            "member_config": [],
            "server_name": "lxd01"
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/cluster").to_return(body: body)

      LXD.cluster.fetch do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Cluster)
      end
    end
  end

  describe "#replace" do
    it "updates cluster" do
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

      WebMock.stub(:PUT, "#{LXD.uri}/cluster")
        .with(body: %({"cluster_password":"blah","enabled":true}))
        .to_return(body: body)

      LXD.cluster.replace(cluster_password: "blah", enabled: true) do |response|
        response.success?.should be_true
      end
    end
  end
end
