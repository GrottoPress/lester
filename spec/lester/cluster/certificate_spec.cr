require "../../spec_helper"

describe Lester::Cluster::Certificate::Endpoint do
  describe "#replace" do
    it "updates member" do
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

      WebMock.stub(:PUT, "#{LXD.uri}/cluster/certificate")
        .with(body: %({\
          "cluster_certificate":"X509 PEM certificate",\
          "cluster_certificate_key":"X509 PEM certificate key"\
        }))
        .to_return(body: body)

      LXD.cluster.certificate.replace(
        cluster_certificate: "X509 PEM certificate",
        cluster_certificate_key: "X509 PEM certificate key"
      ) do |response|
        response.success?.should be_true
      end
    end
  end
end
