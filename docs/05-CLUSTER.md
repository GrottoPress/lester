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
