# Lester

*Lester* is a low-level API client for [*LXD*](https://linuxcontainers.org/lxd/). It features an intuitive interface that maps perfectly to the *LXD* API.

### Usage Examples

1. Create client:

   ```crystal
   lxd = Lester.new(socket: "/var/snap/lxd/common/lxd/unix.socket")

   # OR:
   #
   # lxd = Lester.new(
   #   base_uri: "https://1.2.3.4:8443",
   #   private_key: "priv.key",
   #   certificate: "cert.pem",
   #   # ca_certificates: "ca.pem",
   #   # verify_mode: "none"
   # )
   ```

1. List all images:

   ```crystal
   lxd.images.list(project: "default") do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |image|
       puts image.architecture
       puts image.auto_update?
       puts image.cached?
       # ...
     end
   end
   ```

1. Download instance backup:

   ```crystal
   lxd.instances.backups.export(
     instance_name: "instance-04",
     name: "backup0",
     destination: "/home/user/Downloads/backup.zip"
   ) do |response|
     puts response.message
   end
   ```

## Documentation

Find the complete documentation in the `docs/` directory of this repository.

## Todo

- [ ] Certificates
- [ ] Cluster
- [x] Images
- [x] Instances
- [ ] Metrics
- [ ] Network ACLs
- [ ] Networks
- [ ] Network Forwards
- [ ] Operations
- [ ] Profiles
- [ ] Projects
- [ ] Storage
- [ ] Warnings

## Development

1. Create a `.env.sh` file:

   ```bash
   #!/bin/bash
   #

   export LXD_SOCKET='/var/snap/lxd/common/lxd/unix.socket'

   # Set these if you need to test against a remote LXD server
   export LXD_BASE_URI='https://1.2.3.4:8443'
   export LXD_TLS_KEY_PATH='priv.key'
   export LXD_TLS_CERT_PATH='cert.pem'
   export LXD_TLS_CA_PATH=''
   export LXD_TLS_VERIFY_MODE='none'
   ```

   Update the file with your own details.

1. Run tests with `source .env.sh && crystal spec`.

## Contributing

1. [Fork it](https://github.com/GrottoPress/lester/fork)
1. Switch to the `master` branch: `git checkout master`
1. Create your feature branch: `git checkout -b my-new-feature`
1. Make your changes, updating changelog and documentation as appropriate.
1. Commit your changes: `git commit`
1. Push to the branch: `git push origin my-new-feature`
1. Submit a new *Pull Request* against the `GrottoPress:master` branch.
