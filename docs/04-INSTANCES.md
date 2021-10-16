## Instances

An instance is represented as `Lester::Instance`.

See <https://linuxcontainers.org/lxd/api/master/#/instances> for the raw JSON schema.

### Usage Examples

1. List all instances:

   ```crystal
   lxd.instances.list(filter: "default") do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |instance|
       puts instance.architecture
       puts instance.config.try &.["image.os"]?
       puts instance.ephemeral?
       # ...
     end
   end
   ```

1. Create new instance:

   ```crystal
   # To create from backup file, call:
   #   `lxd.instances.create(backup: "/path/to/file", ...)
   lxd.instances.create(
     source: {
       protocol: "simplestreams",
       server: "https://images.linuxcontainers.org",
       source: "foo/snap0",
       type": "image"
     },
     profiles: ["default"],
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

1. Delete instance:

   ```crystal
   lxd.instances.delete(name: "my-instance") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.err
       puts operation.id
       puts operation.location
       # ...
     end
   end
   ```

1. Fetch single instance:

   ```crystal
   lxd.instances.fetch(name: "my-instance") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |instance|
       puts instance.profiles.try &.first?
       puts instance.stateful?
       puts instance.description
       # ...
     end
   end
   ```

1. Update instance:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.instances.replace(...)` to use `PUT` instead.
   lxd.instances.update(
     name: "my-instance",
     description: "My awesome instance",
     ephemeral: true,
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Rename instance:

   ```crystal
   lxd.instances.rename(
     name: "awesome-instance",
     new_name: "super-awesome-instance",
     live: false,
     migration: false,
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

#### Instance backups

1. List all instance backups:

   ```crystal
   lxd.instances.backups.list(
     instance_name: "instance-10",
     project: "default"
    ) do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |backup|
       puts backup.container_only?
       puts backup.created_at
       puts backup.expires_at
       # ...
     end
   end
   ```

1. Create instance backup:

   ```crystal
   lxd.instances.backups.create(
     instance_name: "instance-04",
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

1. Delete instance backup:

   ```crystal
   lxd.instances.backups.delete("instance-04", "backup0") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.err
       puts operation.id
       puts operation.location
       # ...
     end
   end
   ```

1. Fetch instance backup:

   ```crystal
   lxd.instances.backups.fetch("instance-04", name: "backup0") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |backup|
       puts backup.instance_only?
       puts backup.name
       puts backup.optimized_storage?
       # ...
     end
   end
   ```

1. Rename instance backup:

   ```crystal
   lxd.instances.backups.rename(
     instance_name: "instance-04",
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

#### Instance console

1. Connect to console:

   ```crystal
   lxd.instances.console.connect(
     instance_name: "instance-04",
     height: 24,
     type: "console",
     width: 80,
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

1. Show console log:

   ```crystal
   lxd.instances.console.output(
     instance_name: "instance-04",
     outfile: "/home/user/console.log"
   ) do |response|
     puts response.message
   end
   ```

1. Clear console log:

   ```crystal
   lxd.instances.console.clear(instance_name: "instance-04") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

#### Instance files

1. Create file in instance:

   ```crystal
   lxd.instances.files.create(
     instance_name: "instance-04",
     path: "/path/to/file",
     content: "may be a String or IO",
     # ...
   ) do |response|
     puts response.message
   end
   ```

1. Download file from instance:

   ```crystal
   lxd.instances.files.fetch(
     instance_name: "instance-04",
     path: "/path/to/file",
     destination: "/home/user/Downloads/file.txt"
   ) do |response|
     puts response.message
   end
   ```

1. Delete file from instance:

   ```crystal
   lxd.instances.files.delete("instance-04", "/path/to/file") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

#### Instance directories

1. Create directory in instance:

   ```crystal
   lxd.instances.directories.create(
     instance_name: "instance-04",
     path: "/path/to/directory",
     # ...
   ) do |response|
     puts response.message
   end
   ```

1. Get directory content:

   ```crystal
   lxd.instances.directories.fetch(
     instance_name: "instance-04",
     path: "/path/to/directory",
     #...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |file|
       puts file
     end
   end
   ```

1. Delete directory from instance:

   ```crystal
   lxd.instances.directories.delete(
     instance_name: "instance-04",
     path: "/path/to/directory"
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

#### Instance logs

1. List log files:

   ```crystal
   lxd.instances.logs.list(
     instance_name: "instance-04",
     project: "default"
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |file|
       puts file
     end
   end
   ```

1. Delete log file:

   ```crystal
   lxd.instances.logs.delete(
     instance_name: "instance-04",
     filename: "file.log"
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Download log file:

   ```crystal
   lxd.instances.logs.fetch(
     instance_name: "instance-04",
     filename: "file.log",
     destination: "/home/user/Downloads/file.log",
     #...
   ) do |response|
     puts response.message
   end
   ```

#### Instance metadata

1. Retrieve instance image's metadata:

   ```crystal
   lxd.instances.metadata.fetch(
     instance_name: "instance-04",
     project: "default"
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |metadata|
       puts metadata.architecture
       puts metadata.creation_date
       puts metadata.expiry_date
       # ...
     end
   end
   ```

1. Update instance image's metadata:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.instances.metadata.replace(...)` to use `PUT` instead.
   lxd.instances.metadata.update(
     instance_name: "instance-04",
     architecture: "x86_64",
     expiry_date: 1620685757,
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

#### Instance templates

1. List all instance templates:

   ```crystal
   lxd.instances.templates.list(
     instance_name: "instance-04"
     #...
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |template|
       puts template
     end
   end
   ```

1. Create instance template:

   ```crystal
   lxd.instances.templates.create(
     instance_name: "instance-04",
     path: "/path/to/file",
     content: "may be a String or IO",
     # ...
   ) do |response|
     puts response.message
   end
   ```

1. Delete template from instance:

   ```crystal
   lxd.instances.templates.delete(
     instance_name: "instance-04",
     path: "/path/to/file"
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Download template from instance:

   ```crystal
   lxd.instances.templates.fetch(
     instance_name: "instance-04",
     path: "/path/to/file",
     destination: "/home/user/Downloads/file.tpl"
   ) do |response|
     puts response.message
   end
   ```

#### Instance snapshots

1. List all instance snapshots:

   ```crystal
   lxd.instances.snapshots.list(
     instance_name: "instance-10",
     project: "default"
    ) do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |instance|
       puts instance.architecture
       puts instance.config.try &.["image.os"]?
       puts instance.ephemeral?
       # ...
     end
   end
   ```

1. Create instance snapshot:

   ```crystal
   lxd.instances.snapshots.create(
     instance_name: "instance-04",
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

1. Delete instance snapshot:

   ```crystal
   lxd.instances.snapshots.delete("instance-04", "snap0") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.err
       puts operation.id
       puts operation.location
       # ...
     end
   end
   ```

1. Fetch instance snapshot:

   ```crystal
   lxd.instances.snapshots.fetch("instance-04", name: "snap0") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |instance|
       puts instance.architecture
       puts instance.config.try &.["image.os"]?
       puts instance.ephemeral?
       # ...
     end
   end
   ```

1. Update instance snapshot:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.instances.snapshots.replace(...)` to use `PUT` instead.
   lxd.instances.snapshots.update(
     instance_name: "instance-04",
     name: "snap0",
     expires_at: 10.days.from_now,
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

1. Rename instance snapshot:

   ```crystal
   lxd.instances.snapshots.rename(
     instance_name: "instance-04",
     name: "snap0",
     new_name: "backup-2021-10-14",
     live: false,
     migration: false,
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
