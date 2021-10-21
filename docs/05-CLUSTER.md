## Cluster

A cluster is represented as `Lester::Cluster`.

See <https://linuxcontainers.org/lxd/api/master/#/cluster> for the raw JSON schema.

### Usage Examples

1. Get cluster configuration:

   ```crystal
   lxd.cluster.fetch do |response|
     return puts response.message unless response.success?

     response.metadata.try do |cluster|
       puts cluster.enabled?
       puts cluster.member_config.try &.first?.try &.description
       puts cluster.server_name
       # ...
     end
   end
   ```

1. Update cluster configuration:

   ```crystal
   # Uses the `PUT` request method
   lxd.cluster.replace(
     cluster_address": "10.0.0.1:8443",
     cluster_certificate": "X509 PEM certificate",
     cluster_password": "blah",
     enabled": true,
     member_config": [],
     server_address": "10.0.0.2:8443",
     server_name": "lxd01"
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

### Cluster Members

A cluster member is represented as `Lester::Cluster::Member`.

#### Usage examples

1. List all cluster members:

   ```crystal
   lxd.cluster.members.list do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |member|
       puts member.architecture
       puts member.database?
       puts member.description
       # ...
     end
   end
   ```

1. Request a join token to add a cluster member:

   ```crystal
   lxd.cluster.members.add(server_name: "lxd02") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.err
       puts operation.id
       puts operation.location
       # ...
     end
   end
   ```

1. Delete cluster member:

   ```crystal
   lxd.cluster.members.delete(name: "lxd01") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Fetch cluster member:

   ```crystal
   lxd.cluster.members.fetch(name: "lxd01") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |member|
       puts member.failure_domain
       puts member.message
       puts member.roles.try &.first?
       # ...
     end
   end
   ```

1. Update cluster member:

   ```crystal
   # Uses the `PATCH` request method.
   # Call `lxd.cluster.members.replace(...)` to use the `PUT` method instead.
   lxd.cluster.members.update(
     name: "lxd01",
     config: {"scheduler.instance": "all"},
     description: "AMD Epyc 32c/64t",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Rename cluster member:

   ```crystal
   lxd.cluster.members.rename(
     name: "lxd01",
     new_name: "lxd02",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Evacuate or restore a cluster member:

   ```crystal
   lxd.cluster.members.state(name: "lxd01", action: "evacuate") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.class
       puts operation.created_at
       puts operation.description
       # ...
     end
   end
   ```
