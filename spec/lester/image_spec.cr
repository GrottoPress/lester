require "../spec_helper"

describe Lester::Image::Endpoint do
  describe "#list" do
    it "lists images" do
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
              "auto_update": true,
              "properties": {
                "architecture": "amd64",
                "description": "Debian buster amd64 (20211011_06:29)",
                "os": "Debian",
                "release": "buster",
                "serial": "20211011_06:29",
                "type": "squashfs",
                "variant": "default"
              },
              "public": false,
              "expires_at": "1970-01-01T00:00:00Z",
              "profiles": [
                "default"
              ],
              "aliases": [],
              "architecture": "x86_64",
              "cached": true,
              "filename": "lxd.tar.xz",
              "fingerprint": "5eeb3c1b3212a818b074092ae7e2289b180c850daa",
              "size": 78844592,
              "update_source": {
                "alias": "debian/10",
                "certificate": "",
                "protocol": "simplestreams",
                "server": "https://images.linuxcontainers.org",
                "image_type": ""
              },
              "type": "container",
              "created_at": "2021-10-11T00:00:00Z",
              "last_used_at": "2021-10-09T16:24:50.459197242Z",
              "uploaded_at": "2021-10-11T14:55:36.022876455Z"
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/images")
        .with(query: {"recursion" => "1", "filter" => "default"})
        .to_return(body: body)

      LXD.images.list(filter: "default") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Image))
      end
    end
  end

  describe "#add" do
    it "adds image" do
      body = <<-JSON
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

      WebMock.stub(:POST, "#{LXD.uri}/images?project=&public")
        .with(body: %({"auto_update":false}))
        .to_return(body: body)

      LXD.images.add(secret: "a1b2c3", auto_update: false) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#delete" do
    it "deletes image" do
      body = <<-JSON
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

      WebMock.stub(:DELETE, "#{LXD.uri}/images/a1b2c3")
        .with(query: {"project" => "default"})
        .to_return(body: body)

      LXD.images.delete(fingerprint: "a1b2c3", project: "default") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#fetch" do
    it "fetches image" do
      body = <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "auto_update": true,
            "properties": {
              "architecture": "amd64",
              "description": "Debian buster amd64 (20211011_06:29)",
              "os": "Debian",
              "release": "buster",
              "serial": "20211011_06:29",
              "type": "squashfs",
              "variant": "default"
            },
            "public": false,
            "expires_at": "1970-01-01T00:00:00Z",
            "profiles": [
              "default"
            ],
            "aliases": [],
            "architecture": "x86_64",
            "cached": true,
            "filename": "lxd.tar.xz",
            "fingerprint": "5eeb3c1b3212a818b074092ae7e2289b180c850daa",
            "size": 78844592,
            "update_source": {
              "alias": "debian/10",
              "certificate": "",
              "protocol": "simplestreams",
              "server": "https://images.linuxcontainers.org",
              "image_type": ""
            },
            "type": "container",
            "created_at": "2021-10-11T00:00:00Z",
            "last_used_at": "2021-10-09T16:24:50.459197242Z",
            "uploaded_at": "2021-10-11T14:55:36.022876455Z"
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/images/a1b2c3").to_return(body: body)

      LXD.images.fetch(fingerprint: "a1b2c3") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Image)
      end
    end
  end

  describe "#update" do
    it "updates image" do
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

      WebMock.stub(:PATCH, "#{LXD.uri}/images/a1b2c3?project=")
        .with(body: %({"public":true}))
        .to_return(body: body)

      LXD.images.update(fingerprint: "a1b2c3", public: true) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates image" do
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

      WebMock.stub(:PUT, "#{LXD.uri}/images/a1b2c3?project=")
        .with(body: %({"public":true}))
        .to_return(body: body)

      LXD.images.replace(fingerprint: "a1b2c3", public: true) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#export" do
    it "downloads image" do
      body_io = IO::Memory.new("Lester::Image::Endpoint#export")
      destination = File.tempname("lester-image-endpoint-export")

      WebMock.stub(:GET, "#{LXD.uri}/images/a1b2/export")
        .with(query: {"project" => "default"})
        .to_return(body_io: body_io)

      LXD.images.export(
        fingerprint: "a1b2",
        project: "default",
        destination: destination
      ) do |response|
        response.success?.should be_true
        File.read_lines(destination).first?.should eq(body_io.to_s)
      ensure
        File.delete(destination)
      end
    end

    it "saves image to IO" do
      body_io = IO::Memory.new("Lester::Image::Endpoint#export")
      destination = IO::Memory.new

      WebMock.stub(:GET, "#{LXD.uri}/images/a1b2/export")
        .with(query: {"project" => "default"})
        .to_return(body_io: body_io)

      LXD.images.export(
        fingerprint: "a1b2",
        project: "default",
        destination: destination
      ) do |response|
        response.success?.should be_true
        destination.to_s.should eq(body_io.to_s)
      end
    end
  end

  describe "#push" do
    it "pushes image to a remote server" do
      body = <<-JSON
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

      WebMock.stub(:POST, "#{LXD.uri}/images/a1b2c3/export?project=")
        .with(body: %({\
          "aliases":[{"description":"Ubuntu image","name":"ubuntu-20.04"}],\
          "target":"https://1.2.3.4:8443"\
        }))
        .to_return(body: body)

      LXD.images.push(
        fingerprint: "a1b2c3",
        aliases: [{description: "Ubuntu image", name: "ubuntu-20.04"}],
        target: "https://1.2.3.4:8443"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#refresh" do
    it "updates local copy of image" do
      body = <<-JSON
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

      WebMock.stub(:POST, "#{LXD.uri}/images/a1b2/refresh")
        .with(query: {"project" => "default"})
        .to_return(body: body)

      LXD.images.refresh(fingerprint: "a1b2", project: "default") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#secret" do
    it "generates secret key" do
      body = <<-JSON
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

      WebMock.stub(:POST, "#{LXD.uri}/images/a1b2c3/secret")
        .with(query: {"project" => "default"})
        .to_return(body: body)

      LXD.images.secret(
        fingerprint: "a1b2c3",
        project: "default"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end
end
