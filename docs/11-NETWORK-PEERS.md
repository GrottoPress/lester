## Network Peers

A network peer is represented as `Lester::Network::Peer`.

See <https://linuxcontainers.org/lxd/api/master/#/network-peers> for the raw JSON schema.

### Usage Examples

1. List all network peers:

   ```crystal
   lxd.networks.peers.list(
     network_name: "lxdbr0",
     project: "default"
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |peer|
       puts peer.config.try &.["user.mykey"]?
       puts peer.description
       puts peer.name
       # ...
     end
   end
   ```

1. Create network peer:

   ```crystal
   lxd.networks.peers.create(
     network_name: "lxdbr0",
     name: "peer1",
     config: {"user.mykey": "foo"},
     description: "Peering with lxdbr0",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Delete network peer:

   ```crystal
   lxd.networks.peers.delete(
     network_name: "lxdbr0",
     name: "peer0",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Fetch network peer:

   ```crystal
   lxd.networks.peers.fetch(
     network_name: "lxdbr0",
     name: "peer0",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |peer|
       puts peer.status
       puts peer.target_network
       puts peer.target_project
       # ...
     end
   end
   ```

1. Update network peer:

   ```crystal
   # Uses the `PATCH` request method.
   # Call `lxd.networks.peers.replace(...)` to use the `PUT` method instead.
   lxd.networks.peers.update(
     network_name: "lxdbr0",
     name: "peer0",
     config: {"user.mykey": "foo"},
     description: "Peering with lxdbr0",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```
