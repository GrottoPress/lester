## Profiles

A profile is represented as `Lester::Profile`.

See <https://linuxcontainers.org/lxd/api/master/#/profiles> for the raw JSON schema.

### Usage Examples

1. List all profiles:

   ```crystal
   lxd.profiles.list(project: "default") do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |profile|
       puts profile.config.try &.["limits.cpu"]?
       puts profile.description
       puts profile.name
       # ...
     end
   end
   ```

1. Create profile:

   ```crystal
   lxd.profiles.create(
     config: {"limits.cpu": "4", "limits.memory": "4GiB"},
     description: "Medium size instances",
     devices: {
       eth0: {name: "eth0", network: "lxdbr0", type: "nic"},
       root: {path: "/", pool: "default", type: "disk"}
     },
     name: "foo"
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Delete profile:

   ```crystal
   lxd.profiles.delete(name: "profile0") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Fetch profile:

   ```crystal
   lxd.profiles.fetch(name: "profile0") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |profile|
       puts profile.used_by.try &.first?
       puts profile.devices.try &.["root"]?.try &.["path"]?
       puts profile.config.try &.["limits.memory"]?
       # ...
     end
   end
   ```

1. Update profile:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.profiles.replace(...)` to use the `PUT` method instead.
   lxd.profiles.update(
     name: "profile0",
     config: {"limits.cpu": "4", "limits.memory": "4GiB"},
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Rename profile:

   ```crystal
   lxd.profiles.rename(
     name: "profile0",
     new_name: "profile1",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```
