require "../spec_helper"

describe Lester::Instance::Endpoint do
  describe "#list" do
    it "lists instances" do
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
              "architecture": "x86_64",
              "config": {
                "image.architecture": "amd64",
                "image.description": "Debian buster amd64 (20211008_07:18)",
                "image.os": "Debian",
                "image.release": "buster",
                "image.serial": "20211008_07:18",
                "image.type": "squashfs",
                "image.variant": "default",
                "limits.cpu": "1",
                "limits.cpu.allowance": "60%",
                "limits.memory": "256MiB",
                "volatile.base_image": "9dc93b76d950128ddc21752481acb3aa9c",
                "volatile.eth0.host_name": "veth3008957b",
                "volatile.eth0.hwaddr": "00:16:3e:4e:db:cf",
                "volatile.idmap.base": "0",
                "volatile.idmap.current": "[{\\"Isuid\\":true}]",
                "volatile.idmap.next": "[{\\"Isuid\\":true,\\"Isgid\\":false}]",
                "volatile.last_state.idmap": "[{\\"Isuid\\":true}]",
                "volatile.last_state.power": "RUNNING",
                "volatile.uuid": "ba2dd73d-db40-4c53-86f3-28f59ca510f8"
              },
              "devices": {
                "root": {
                  "path": "/",
                  "pool": "lxdzfs",
                  "size": "5GiB",
                  "type": "disk"
                }
              },
              "ephemeral": false,
              "profiles": [
                "default"
              ],
              "stateful": false,
              "description": "",
              "created_at": "2021-10-08T16:32:07.698836235Z",
              "expanded_config": {
                "image.architecture": "amd64",
                "image.description": "Debian buster amd64 (20211008_07:18)",
                "image.os": "Debian",
                "image.release": "buster",
                "image.serial": "20211008_07:18",
                "image.type": "squashfs",
                "image.variant": "default",
                "limits.cpu": "1",
                "limits.cpu.allowance": "60%",
                "limits.memory": "256MiB",
                "volatile.base_image": "9dc93b76d950128ddc21752481acb3aa9cc4f",
                "volatile.eth0.host_name": "veth3008957b",
                "volatile.eth0.hwaddr": "00:16:3e:4e:db:cf",
                "volatile.idmap.base": "0",
                "volatile.idmap.current": "[{\\"Isuid\\":true}]",
                "volatile.idmap.next": "[{\\"Isuid\\":true,\\"Isgid\\":false}]",
                "volatile.last_state.idmap": "[{\\"Isuid\\":true}]",
                "volatile.last_state.power": "RUNNING",
                "volatile.uuid": "ba2dd73d-db40-4c53-86f3-28f59ca510f8"
              },
              "expanded_devices": {
                "eth0": {
                  "name": "eth0",
                  "network": "lxdbr0",
                  "type": "nic"
                },
                "root": {
                  "path": "/",
                  "pool": "lxdzfs",
                  "size": "5GiB",
                  "type": "disk"
                }
              },
              "name": "debian-10",
              "status": "Running",
              "status_code": 103,
              "last_used_at": "2021-10-13T11:55:15.666426875Z",
              "location": "none",
              "type": "container"
            }
          ]
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/instances")
        .with(query: {"recursion" => "1", "filter" => "default"})
        .to_return(body_io: body_io)

      LXD.instances.list(filter: "default") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Array(Lester::Instance))
      end
    end
  end

  describe "#create" do
    it "creates instance" do
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
            "class": "websocket",
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

      WebMock.stub(
        :POST,
        "#{LXD_BASE_URI}/1.0/instances?project=&target=default"
      )
        .with(body: %({"architecture":"x86_64"}))
        .to_return(body_io: body_io)

      LXD.instances.create(
        target: "default",
        architecture: "x86_64"
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#delete" do
    it "deletes instance" do
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

      WebMock.stub(:DELETE, "#{LXD_BASE_URI}/1.0/instances/debian-10")
        .with(query: {"project" => "default"})
        .to_return(body_io: body_io)

      LXD.instances.delete(name: "debian-10", project: "default") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#fetch" do
    it "fetches instance" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "sync",
          "status": "Success",
          "status_code": 200,
          "operation": "",
          "error_code": 0,
          "error": "",
          "metadata": {
            "architecture": "x86_64",
            "config": {
              "image.architecture": "amd64",
              "image.description": "Debian buster amd64 (20211008_07:18)",
              "image.os": "Debian",
              "image.release": "buster",
              "image.serial": "20211008_07:18",
              "image.type": "squashfs",
              "image.variant": "default",
              "limits.cpu": "1",
              "limits.cpu.allowance": "60%",
              "limits.memory": "256MiB",
              "volatile.base_image": "9dc93b76d950128ddc21752481acb3aa9c",
              "volatile.eth0.host_name": "veth3008957b",
              "volatile.eth0.hwaddr": "00:16:3e:4e:db:cf",
              "volatile.idmap.base": "0",
              "volatile.idmap.current": "[{\\"Isuid\\":true}]",
              "volatile.idmap.next": "[{\\"Isuid\\":true,\\"Isgid\\":false}]",
              "volatile.last_state.idmap": "[{\\"Isuid\\":true}]",
              "volatile.last_state.power": "RUNNING",
              "volatile.uuid": "ba2dd73d-db40-4c53-86f3-28f59ca510f8"
            },
            "devices": {
              "root": {
                "path": "/",
                "pool": "lxdzfs",
                "size": "5GiB",
                "type": "disk"
              }
            },
            "ephemeral": false,
            "profiles": [
              "default"
            ],
            "stateful": false,
            "description": "",
            "created_at": "2021-10-08T16:32:07.698836235Z",
            "expanded_config": {
              "image.architecture": "amd64",
              "image.description": "Debian buster amd64 (20211008_07:18)",
              "image.os": "Debian",
              "image.release": "buster",
              "image.serial": "20211008_07:18",
              "image.type": "squashfs",
              "image.variant": "default",
              "limits.cpu": "1",
              "limits.cpu.allowance": "60%",
              "limits.memory": "256MiB",
              "volatile.base_image": "9dc93b76d950128ddc21752481acb3aa9cc4f",
              "volatile.eth0.host_name": "veth3008957b",
              "volatile.eth0.hwaddr": "00:16:3e:4e:db:cf",
              "volatile.idmap.base": "0",
              "volatile.idmap.current": "[{\\"Isuid\\":true}]",
              "volatile.idmap.next": "[{\\"Isuid\\":true,\\"Isgid\\":false}]",
              "volatile.last_state.idmap": "[{\\"Isuid\\":true}]",
              "volatile.last_state.power": "RUNNING",
              "volatile.uuid": "ba2dd73d-db40-4c53-86f3-28f59ca510f8"
            },
            "expanded_devices": {
              "eth0": {
                "name": "eth0",
                "network": "lxdbr0",
                "type": "nic"
              },
              "root": {
                "path": "/",
                "pool": "lxdzfs",
                "size": "5GiB",
                "type": "disk"
              }
            },
            "name": "debian-10",
            "status": "Running",
            "status_code": 103,
            "last_used_at": "2021-10-13T11:55:15.666426875Z",
            "location": "none",
            "type": "container"
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD_BASE_URI}/1.0/instances/debian-10")
        .to_return(body_io: body_io)

      LXD.instances.fetch(name: "debian-10") do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Instance)
      end
    end
  end

  describe "#update" do
    it "updates instance" do
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

      WebMock.stub(:PATCH, "#{LXD_BASE_URI}/1.0/instances/debian-10?project=")
        .with(body: %({"architecture":"x86_64"}))
        .to_return(body_io: body_io)

      LXD.instances.update(
        name: "debian-10",
        architecture: "x86_64"
      ) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#rename" do
    it "renames instance" do
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
            "class": "websocket",
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

      WebMock.stub(:POST, "#{LXD_BASE_URI}/1.0/instances/debian-10?project=")
        .with(body: %({"container_only":false,"name":"debian-buster"}))
        .to_return(body_io: body_io)

      LXD.instances.rename(
        name: "debian-10",
        new_name: "debian-buster",
        container_only: false
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#replace" do
    it "updates all instances" do
      body_io = IO::Memory.new <<-JSON
        {
          "metadata": {
            "class": "websocket",
            "created_at": "2021-03-23T17:38:37.753398689-04:00",
            "description": "Executing command",
            "err": "Some error message",
            "id": "6916c8a6-9b7d-4abd-90b3-aedfec7ec7da",
            "location": "lxd01",
            "may_cancel": false,
            "metadata": {
              "command": [
                "bash"
              ],
              "environment": {
                "HOME": "/root",
                "LANG": "C.UTF-8",
                "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin",
                "TERM": "xterm",
                "USER": "root"
              },
              "fds": {
                "0": "da3046cf02c0116febf4ef3fe4eaecdf308e720c05e5a9c73",
                "1": "05896879d8692607bd6e4a09475667da3b5f6714418ab0ee0"
              },
              "interactive": true
            },
            "resources": {
              "containers": [
                "/1.0/containers/foo"
              ],
              "instances": [
                "/1.0/instances/foo"
              ]
            },
            "status": "Running",
            "status_code": 0,
            "updated_at": "2021-03-23T17:38:37.753398689-04:00"
          },
          "operation": "/1.0/operations/66e83638-9dd7-4a26-aef2-5462814869a1",
          "status": "Operation created",
          "status_code": 100,
          "type": "async"
        }
        JSON

      WebMock.stub(:PUT, "#{LXD_BASE_URI}/1.0/instances?project=")
        .with(body: %({"state":{"action":"start"}}))
        .to_return(body_io: body_io)

      LXD.instances.replace(state: {action: "start"}) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end

    it "updates single instance" do
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
            "class": "websocket",
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

      WebMock.stub(:PUT, "#{LXD_BASE_URI}/1.0/instances/debian-10?project=")
        .with(body: %({"architecture":"x86_64","ephemeral":false}))
        .to_return(body_io: body_io)

      LXD.instances.replace(
        name: "debian-10",
        architecture: "x86_64",
        ephemeral: false
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end

  describe "#exec" do
    it "executes command inside instance" do
      body_io = IO::Memory.new <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": "",
          "metadata": {
            "class": "websocket",
            "created_at": "2021-03-23T17:38:37.753398689-04:00",
            "description": "Executing command",
            "err": "Some error message",
            "id": "6916c8a6-9b7d-4abd-90b3-aedfec7ec7da",
            "location": "lxd01",
            "may_cancel": false,
            "metadata": {
              "command": [
                "bash"
              ],
              "environment": {
                "HOME": "/root",
                "LANG": "C.UTF-8",
                "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin",
                "TERM": "xterm",
                "USER": "root"
              },
              "fds": {
                "0": "da3046cf02c0116febf4ef3fe4eaecdf308e720c05e5a9c730ce1a",
                "1": "05896879d8692607bd6e4a09475667da3b5f6714418ab0ee0e5720"
              },
              "interactive": true
            },
            "resources": {
              "containers": [
                "/1.0/containers/foo"
              ],
              "instances": [
                "/1.0/instances/foo"
              ]
            },
            "status": "Running",
            "status_code": 0,
            "updated_at": "2021-03-23T17:38:37.753398689-04:00"
          }
        }
        JSON

      WebMock.stub(:POST, "#{LXD_BASE_URI}/1.0/instances/a1b2/exec?project=")
        .with(body: %({\
          "command":["bash"],\
          "cwd":"/home/foo/",\
          "environment":{"FOO":"BAR"}\
        }))
        .to_return(body_io: body_io)

      LXD.instances.exec(
        name: "a1b2",
        command: ["bash"],
        cwd: "/home/foo/",
        environment: {FOO: "BAR"}
      ) do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Operation)
      end
    end
  end
end
