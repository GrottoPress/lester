## Network ACLs

A network ACL is represented as `Lester::Network::Acl`.

See <https://linuxcontainers.org/lxd/api/master/#/network-acls> for the raw JSON schema.

### Usage Examples

1. List all network ACLs:

   ```crystal
   lxd.networks.acls.list(project: "default") do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |acl|
       puts acl.config.try &.["user.mykey"]?
       puts acl.description
       puts acl.egress.try &.first?.try &.action
       # ...
     end
   end
   ```

1. Create network ACL:

   ```crystal
   lxd.networks.acls.create(
     name: "http-out",
     egress: [{
       action: "allow",
       state: "enabled",
       destination_port: "80,443",
       protocol: "tcp",
       # ...
     }],
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Delete network ACL:

   ```crystal
   lxd.networks.acls.delete(name: "web-out") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Fetch network ACL:

   ```crystal
   lxd.networks.acls.fetch(name: "web-in") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |acl|
       puts acl.ingress.try &.first?.try &.state
       puts acl.name
       puts acl.used_by.try &.first?
       # ...
     end
   end
   ```

1. Update network ACL:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.networks.acls.replace(...)` to use the `PUT` method instead.
   lxd.networks.acls.update(
     name: "web-out",
     config: {"user.mykey": "bar"},
     egress: [{
       state: "disabled",
       # ...
     }],
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Rename network ACL:

   ```crystal
   lxd.networks.acls.rename(
     name: "web-out",
     new_name: "http-out",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```
