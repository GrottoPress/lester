require "../spec_helper"

describe Lester::Metrics::Endpoint do
  describe "#fetch" do
    it "fetches peer" do
      body_io = IO::Memory.new <<-TEXT
        # HELP lxd_cpu_seconds_total The total number of CPU seconds.
        # TYPE lxd_cpu_seconds_total counter
        lxd_cpu_seconds_total{cpu="0",mode="system",name="buster"} 194
        lxd_cpu_seconds_total{cpu="0",mode="user",name="buster"} 724
        lxd_cpu_seconds_total{cpu="1",mode="system",name="buster"} 161
        lxd_cpu_seconds_total{cpu="1",mode="user",name="buster"} 775
        lxd_cpu_seconds_total{cpu="2",mode="system",name="buster"} 187
        lxd_cpu_seconds_total{cpu="2",mode="user",name="buster"} 667
        lxd_cpu_seconds_total{cpu="3",mode="system",name="buster"} 134
        lxd_cpu_seconds_total{cpu="3",mode="user",name="buster"} 690
        TEXT

      WebMock.stub(:GET, "#{LXD.uri}/metrics")
        .with(query: {"project" => "default"})
        .to_return(body_io: body_io)

      LXD.metrics.fetch(project: "default") do |response|
        response.should eq(body_io.to_s)
      end
    end
  end
end
