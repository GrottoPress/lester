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

### Storage Volumes

A storage volume is represented as `Lester::Volume`.

#### Usage examples

1. List all storage volumes:

   ```crystal
   lxd.volumes.list(pool_name: "pool0", type: "custom") do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |volume|
       puts volume.config.try &.["size"]?
       puts volume.content_type
       puts volume.description
       # ...
     end
   end
   ```

1. Create storage volume:

   ```crystal
   lxd.volumes.create(
     pool_name: "pool0",
     type: "custom",
     content_type: "filesystem",
     description: "My custom volume",
     name: "volume0",
     restore: "snap0"
     # ...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.class
       puts operation.created_at
       puts operation.description
       # ...
     end
   end
   ```

1. Delete storage volume:

   ```crystal
   lxd.volumes.delete(
     pool_name: "pool0",
     name: "volume0",
     type: "some_type",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Fetch storage volume:

   ```crystal
   lxd.volumes.fetch(
     pool_name: "pool0",
     name: "volume0",
     type: "some_type",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |volume|
       puts volume.location
       puts volume.name
       puts volume.restore
       # ...
     end
   end
   ```

1. Update storage volume:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.volumes.replace(...)` to use `PUT` instead.
   lxd.volumes.update(
     pool_name: "pool0",
     name: "volume0",
     type: "custom",
     description: "My awesome volume",
     restore: "snap0",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Rename a storage volume:

   ```crystal
   lxd.volumes.rename(
     pool_name: "pool0",
     name: "current-name",
     new_name: "new-name",
     type: "custom",
     migration: false,
     volume_only: false,
     pool: "remote",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.err
       puts operation.id
       puts operation.location
       # ...
     end
   end
   ```

1. Get storage volume state:

   ```crystal
   lxd.volumes.state(
     pool_name: "pool0",
     name: "volume0",
     type: "custom",
     #...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |state|
       puts state.usage.try &.used
       # ...
     end
   end
   ```

### Storage Volume Backups

A storage volume backup is represented as `Lester::Volume::Backup`.

#### Usage examples

1. List all volume backups:

   ```crystal
   lxd.volumes.backups.list(
     pool_name: "pool0",
     volume_name: "volume0",
     volume_type: "custom",
     project: "default",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |backup|
       puts backup.created_at
       puts backup.expires_at
       puts backup.name
       # ...
     end
   end
   ```

1. Create volume backup:

   ```crystal
   lxd.volumes.backups.create(
     pool_name: "pool0",
     volume_name: "volume0",
     volume_type: "custom",
     name: "backup0",
     compression_algorithm: "gzip"
     # ...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.class
       puts operation.created_at
       puts operation.description
       # ...
     end
   end
   ```

1. Delete volume backup:

   ```crystal
   lxd.volumes.backups.delete(
     pool_name: "pool0",
     volume_name: "volume0",
     volume_type: "custom",
     name: "backup0"
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.err
       puts operation.id
       puts operation.location
       # ...
     end
   end
   ```

1. Fetch volume backup:

   ```crystal
   lxd.volumes.backups.fetch(
     pool_name: "pool0",
     volume_name: "volume0",
     volume_type: "custom",
     name: "backup0"
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |backup|
       puts backup.optimized_storage?
       puts backup.volume_only?
       puts backup.name
       # ...
     end
   end
   ```

1. Rename volume backup:

   ```crystal
   lxd.volumes.backups.rename(
     pool_name: "pool0",
     volume_name: "volume0",
     volume_type: "custom",
     name: "backup0",
     new_name: "backup-2021-10-14"
     # ...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.id
       puts operation.location
       puts operation.metadata.try &.status
     end
   end
   ```

1. Download volume backup:

   ```crystal
   lxd.volumes.backups.export(
     pool_name: "pool0",
     volume_name: "volume0",
     volume_type: "custom",
     name: "backup0",
     destination: "/home/user/Downloads/backup.zip" # May be an `IO`
   ) do |response|
     puts response.message
   end
   ```

### Storage Volume Snapshots

#### Usage examples

1. List all storage volume snapshots:

   ```crystal
   lxd.volumes.snapshots.list(
     pool_name: "pool0",
     volume_name: "volume0",
     volume_type: "custom",
     target: "lxd0",
     # ...
    ) do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |volume|
       puts volume.config.try &.["size"]?
       puts volume.content_type
       puts volume.description
       # ...
     end
   end
   ```

1. Create storage volume snapshot:

   ```crystal
   lxd.volumes.snapshots.create(
     pool_name: "pool0",
     volume_name: "volume0",
     volume_type: "custom",
     name: "snap0",
     stateful: false,
     # ...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.class
       puts operation.created_at
       puts operation.description
       # ...
     end
   end
   ```

1. Delete storage volume snapshot:

   ```crystal
   lxd.volumes.snapshots.delete(
     pool_name: "pool0",
     volume_name: "volume0",
     volume_type: "custom",
     name: "snap0",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.err
       puts operation.id
       puts operation.location
       # ...
     end
   end
   ```

1. Fetch storage volume snapshot:

   ```crystal
   lxd.volumes.snapshots.fetch(
     pool_name: "pool0",
     volume_name: "volume0",
     volume_type: "custom",
     name: "snap0",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |volume|
       puts volume.expires_at
       puts volume.name
       puts volume.description
       # ...
     end
   end
   ```

1. Update storage volume snapshot:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.volumes.snapshots.replace(...)` to use `PUT` instead.
   lxd.volumes.snapshots.update(
     pool_name: "pool0",
     volume_name: "volume0",
     volume_type: "custom",
     name: "snap0",
     expires_at: 10.days.from_now,
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Rename storage volume snapshot:

   ```crystal
   lxd.volumes.snapshots.rename(
     pool_name: "pool0",
     volume_name: "volume0",
     volume_type: "custom",
     name: "snap0",
     new_name: "snapshot-2021-10-14"
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.id
       puts operation.location
       puts operation.metadata.try &.status
     end
   end
   ```
