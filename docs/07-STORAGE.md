## Storage Pools

A storage pool is represented as `Lester::Pool`.

See <https://linuxcontainers.org/lxd/api/master/#/storage> for the raw JSON schema.

### Usage Examples

1. List all storage pools:

   ```crystal
   lxd.pools.list do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |pool|
       puts pool.config.try &.["volume.size"]?
       puts pool.description
       puts pool.driver
       # ...
     end
   end
   ```

1. Add new storage pool:

   ```crystal
   lxd.pools.create(
     project: "default",
     target: "lxd0",
     config: {"volume.block.filesystem": "ext4", "volume.size": "50GiB"},
     description: "Local SSD pool",
     driver: "zfs",
     name: "local",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Delete storage pool:

   ```crystal
   lxd.pools.delete(name: "pool0") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Fetch storage pool:

   ```crystal
   lxd.pools.fetch(name: "pool0") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |pool|
       puts pool.locations.try &.first?
       puts pool.name
       puts pool.status
       # ...
     end
   end
   ```

1. Update storage pool:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.pools.replace(...)` to use `PUT` instead.
   lxd.pools.update(
     name: "pool0",
     description: "Local SSD pool"
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Get storage pool resource usage:

   ```crystal
   lxd.pools.resources(name: "pool0") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |resources|
       puts resources.inodes.try &.total
       puts resources.inodes.try &.used
       puts resources.space.try &.total
       # ...
     end
   end
   ```
