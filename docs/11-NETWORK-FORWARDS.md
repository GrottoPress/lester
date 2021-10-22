## Network Forwards

A network address forward is represented as `Lester::Network::Forward`.

See <https://linuxcontainers.org/lxd/api/master/#/network-forwards> for the raw JSON schema.

### Usage Examples

1. List all network address forwards:

   ```crystal
   lxd.networks.forwards.list(
     network_name: "lxdbr0",
     project: "default"
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |forward|
       puts forward.config.try &.["user.mykey"]?
       puts forward.description
       puts forward.listen_address
       # ...
     end
   end
   ```

1. Create network address forward:

   ```crystal
   lxd.networks.forwards.create(
     network_name: "lxdbr0",
     listen_address: "4.5.6.7",
     config: {"user.mykey": "foo"},
     description: "My public IP forward",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Delete network address forward:

   ```crystal
   lxd.networks.forwards.delete(
     network_name: "lxdbr0",
     listen_address: "1.2.3.4",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Fetch network address forward:

   ```crystal
   lxd.networks.forwards.fetch(
     network_name: "lxdbr0",
     listen_address: "1.2.3.4",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |forward|
       puts forward.location
       puts forward.ports.try &.first?.try &.description
       puts forward.ports.try &.first?.try &.listen_port
       # ...
     end
   end
   ```

1. Update network address forward:

   ```crystal
   # Uses the `PATCH` request method.
   # Call `lxd.networks.forwards.replace(...)` to use the `PUT` method instead.
   lxd.networks.forwards.update(
     network_name: "lxdbr0",
     listen_address: "1.2.3.4",
     config: {"user.mykey": "foo"},
     description: "My public IP forward",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```
