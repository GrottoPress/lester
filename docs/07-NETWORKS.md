## Networks

A network is represented as `Lester::Network`.

See <https://linuxcontainers.org/lxd/api/master/#/networks> for the raw JSON schema.

### Usage Examples

1. List all networks:

   ```crystal
   lxd.networks.list(project: "default") do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |network|
       puts network.description
       puts network.locations.try &.first?
       puts network.managed?
       # ...
     end
   end
   ```

1. Create network:

   ```crystal
   lxd.networks.create(
     name: "lxdbr1",
     type: "bridge",
     config: {"ipv4.address": "10.0.0.1/24", "ipv6.address": "none"},
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Delete network:

   ```crystal
   lxd.networks.delete(name: "lxdbr0") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Fetch network:

   ```crystal
   lxd.networks.fetch(name: "lxdbr0") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |network|
       puts network.name
       puts network.status
       puts network.type
       # ...
     end
   end
   ```

1. Update network:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.networks.replace(...)` to use the `PUT` method instead.
   lxd.networks.update(
     name: "lxdbr0",
     config: {"ipv4.nat": "true"},
     description: "My new LXD bridge",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Rename network:

   ```crystal
   lxd.networks.rename(
     name: "lxdbr0",
     new_name: "lxdbr1",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. List DHCP leases for a network:

   ```crystal
   lxd.networks.leases(name: "lxdbr0") do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |lease|
       puts lease.address
       puts lease.hostname
       puts lease.hwaddr
       # ...
     end
   end
   ```

1. Fetch network state information:

   ```crystal
   lxd.networks.state(name: "lxdbr0") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |state|
       puts state.addresses.try &.first?.try &.family
       puts state.host_name
       puts state.hwaddr
       # ...
     end
   end
   ```
