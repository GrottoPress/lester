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
