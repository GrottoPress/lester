require "../spec_helper"

describe Lester::Server::Endpoint do
  describe "#fetch" do
    it "retrieves server information" do
      body = <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": "",
          "metadata": {
            "api_extensions": [
              "etag",
              "patch",
              "network",
              "storage"
            ],
            "api_status": "stable",
            "api_version": "1.0",
            "auth": "untrusted",
            "auth_methods": [
              "tls",
              "candid"
            ],
            "config": {
              "core.https_address": ":8443",
              "core.trust_password": true
            },
            "environment": {
              "addresses": [
                ":8443"
              ],
              "architectures": [
                "x86_64",
                "i686"
              ],
              "certificate": "X509 PEM certificate",
              "certificate_fingerprint": "fd200419b271f1dc2a5591b693cc5774",
              "driver": "lxc | qemu",
              "driver_version": "4.0.7 | 5.2.0",
              "firewall": "nftables",
              "kernel": "Linux",
              "kernel_architecture": "x86_64",
              "kernel_features": {
                "netnsid_getifaddrs": "true",
                "seccomp_listener": "true"
              },
              "kernel_version": "5.4.0-36-generic",
              "lxc_features": {
                "cgroup2": "true",
                "devpts_fd": "true",
                "pidfd": "true"
              },
              "os_name": "Ubuntu",
              "os_version": "20.04",
              "project": "default",
              "server": "lxd",
              "server_clustered": false,
              "server_name": "castiana",
              "server_pid": 1453969,
              "server_version": "4.11",
              "storage": "dir | zfs",
              "storage_supported_drivers": [
                {
                  "Name": "zfs",
                  "Remote": false,
                  "Version": "0.8.4-1ubuntu11"
                }
              ],
              "storage_version": "1 | 0.8.4-1ubuntu11"
            },
            "public": false
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}").to_return(body: body)

      LXD.server.fetch do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Server)
      end
    end
  end

  describe "#update" do
    it "updates server configuration" do
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

      WebMock.stub(:PATCH, "#{LXD.uri}?target=")
        .with(body: %({"config":{"core.https_address":":8443"}}))
        .to_return(body: body)

      LXD.server.update(config: {"core.https_address" => ":8443"}) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#replace" do
    it "updates server configuration" do
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

      WebMock.stub(:PUT, "#{LXD.uri}?target=")
        .with(body: %({"config":{"core.https_address":":8443"}}))
        .to_return(body: body)

      LXD.server.replace(config: {"core.https_address": ":8443"}) do |response|
        response.success?.should be_true
      end
    end
  end

  describe "#events" do
    pending "retrieves events via websocket" do
      # TODO
    end
  end

  describe "#resources" do
    it "retrieves server resources" do
      body = <<-JSON
        {
          "type": "async",
          "status": "Operation created",
          "status_code": 100,
          "operation": "/1.0/operations/a84e4e56-1ca0-4afa-b9a6-186eae0fc46e",
          "error_code": 0,
          "error": "",
          "metadata": {
            "cpu": {
              "architecture": "x86_64",
              "sockets": [
                {
                  "cache": [
                    {
                      "level": 1,
                      "size": 32768,
                      "type": "Data"
                    }
                  ],
                  "cores": [
                    {
                      "core": 0,
                      "die": 0,
                      "frequency": 3500,
                      "threads": [
                        {
                          "id": 0,
                          "isolated": false,
                          "numa_node": 0,
                          "online": true,
                          "thread": 0
                        }
                      ]
                    }
                  ],
                  "frequency": 3499,
                  "frequency_minimum": 400,
                  "frequency_turbo": 3500,
                  "name": "Intel(R) Core(TM) i5-7300U CPU @ 2.60GHz",
                  "socket": 0,
                  "vendor": "GenuineIntel"
                }
              ],
              "total": 1
            },
            "gpu": {
              "cards": [
                {
                  "driver": "i915",
                  "driver_version": "5.8.0-36-generic",
                  "drm": {
                    "card_device": "226:0",
                    "card_name": "card0",
                    "control_device": "226:0",
                    "control_name": "controlD64",
                    "id": 0,
                    "render_device": "226:128",
                    "render_name": "renderD128"
                  },
                  "mdev": null,
                  "numa_node": 0,
                  "nvidia": {
                    "architecture": "3.5",
                    "brand": "GeForce",
                    "card_device": "195:0",
                    "card_name": "nvidia0",
                    "cuda_version": "11.0",
                    "model": "GeForce GT 730",
                    "nvrm_version": "450.102.04",
                    "uuid": "GPU-6ddadebd-dafe-2db9-f10f-125719770fd3"
                  },
                  "pci_address": "0000:00:02.0",
                  "product": "HD Graphics 620",
                  "product_id": "5916",
                  "sriov": {
                    "current_vfs": 0,
                    "maximum_vfs": 0,
                    "vfs": null
                  },
                  "usb_address": "2:7",
                  "vendor": "Intel Corporation",
                  "vendor_id": "8086"
                }
              ],
              "total": 1
            },
            "memory": {
              "hugepages_size": 2097152,
              "hugepages_total": 429284917248,
              "hugepages_used": 429284917248,
              "nodes": null,
              "total": 687194767360,
              "used": 557450502144
            },
            "network": {
              "cards": [
                {
                  "driver": "atlantic",
                  "driver_version": "5.8.0-36-generic",
                  "firmware_version": "3.1.100",
                  "numa_node": 0,
                  "pci_address": "0000:0d:00.0",
                  "ports": [
                    {
                      "address": "00:23:a4:01:01:6f",
                      "auto_negotiation": true,
                      "id": "eth0",
                      "infiniband": {
                        "issm_device": "231:64",
                        "issm_name": "issm0",
                        "mad_device": "231:0",
                        "mad_name": "umad0",
                        "verb_device": "231:192",
                        "verb_name": "uverbs0"
                      },
                      "link_detected": true,
                      "link_duplex": "full",
                      "link_speed": 10000,
                      "port": 0,
                      "port_type": "twisted pair",
                      "protocol": "ethernet",
                      "supported_modes": [
                        "100baseT/Full",
                        "1000baseT/Full",
                        "2500baseT/Full",
                        "5000baseT/Full",
                        "10000baseT/Full"
                      ],
                      "supported_ports": [
                        "twisted pair"
                      ],
                      "transceiver_type": "internal"
                    }
                  ],
                  "product": "AQC107 NBase-T/IEEE",
                  "product_id": "87b1",
                  "sriov": {
                    "current_vfs": 0,
                    "maximum_vfs": 0,
                    "vfs": null
                  },
                  "usb_address": "2:7",
                  "vendor": "Aquantia Corp.",
                  "vendor_id": "1d6a"
                }
              ],
              "total": 1
            },
            "pci": {
              "devices": [
                {
                  "driver": "mgag200",
                  "driver_version": "5.8.0-36-generic",
                  "iommu_group": 20,
                  "numa_node": 0,
                  "pci_address": "0000:07:03.0",
                  "product": "MGA G200eW WPCM450",
                  "product_id": "0532",
                  "vendor": "Matrox Electronics Systems Ltd.",
                  "vendor_id": "102b"
                }
              ],
              "total": 1
            },
            "storage": {
              "disks": [
                {
                  "block_size": 512,
                  "device": "259:0",
                  "device_id": "nvme-eui.0000000001000000e4d25cafae2e4c00",
                  "device_path": "pci-0000:05:00.0-nvme-1",
                  "firmware_version": "PSF121C",
                  "id": "nvme0n1",
                  "model": "INTEL SSDPEKKW256G7",
                  "numa_node": 0,
                  "partitions": [
                    {
                      "device": "259:1",
                      "id": "nvme0n1p1",
                      "partition": 1,
                      "read_only": false,
                      "size": 254933278208
                    }
                  ],
                  "pci_address": "0000:05:00.0",
                  "read_only": false,
                  "removable": false,
                  "rpm": 0,
                  "serial": "BTPY63440ARH256D",
                  "size": 256060514304,
                  "type": "nvme",
                  "usb_address": "3:5",
                  "wwn": "eui.0000000001000000e4d25cafae2e4c00"
                }
              ],
              "total": 1
            },
            "system": {
              "chassis": {
                "serial": "PY3DD4X9",
                "type": "Notebook",
                "vendor": "Lenovo",
                "version": "None"
              },
              "family": "ThinkPad X1 Carbon 5th",
              "firmware": {
                "date": "10/14/2020",
                "vendor": "Lenovo",
                "version": "N1MET64W (1.49)"
              },
              "motherboard": {
                "product": "20HRCTO1WW",
                "serial": "L3CF4FX003A",
                "vendor": "Lenovo",
                "version": "None"
              },
              "product": "20HRCTO1WW",
              "serial": "PY3DD4X9",
              "sku": "string",
              "type": "physical",
              "uuid": "7fa1c0cc-2271-11b2-a85c-aab32a05d71a",
              "vendor": "LENOVO",
              "version": "ThinkPad X1 Carbon 5th"
            },
            "usb": {
              "devices": [
                {
                  "bus_address": 1,
                  "device_address": 3,
                  "interfaces": [
                    {
                      "class": "Human Interface Device",
                      "class_id": 3,
                      "driver": "usbhid",
                      "driver_version": "5.8.0-36-generic",
                      "number": 0,
                      "subclass": "Boot Interface Subclass",
                      "subclass_id": 1
                    }
                  ],
                  "product": "Hermon USB hidmouse Device",
                  "product_id": "2221",
                  "speed": 12,
                  "vendor": "ATEN International Co., Ltd",
                  "vendor_id": "0557"
                }
              ],
              "total": 1
            }
          }
        }
        JSON

      WebMock.stub(:GET, "#{LXD.uri}/resources").to_return(body: body)

      LXD.server.resources do |response|
        response.success?.should be_true
        response.metadata.should be_a(Lester::Server::Resources)
      end
    end
  end
end
