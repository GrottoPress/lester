## Projects

A project is represented as `Lester::Project`.

See <https://linuxcontainers.org/lxd/api/master/#/projects> for the raw JSON schema.

### Usage Examples

1. List all projects:

   ```crystal
   lxd.projects.list do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |project|
       puts project.config.try &.["features.networks"]?
       puts project.description
       puts project.name
       # ...
     end
   end
   ```

1. Create project:

   ```crystal
   lxd.projects.create(
     config: {"features.networks": "false", "features.profiles": "true"},
     description: "My new project",
     name: "foo",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Delete project:

   ```crystal
   lxd.projects.delete(name: "project0") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Fetch project:

   ```crystal
   lxd.projects.fetch(name: "project0") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |project|
       puts project.used_by.try &.first?
       puts project.config.try &.["features.profiles"]?
       puts project.description
       # ...
     end
   end
   ```

1. Update project:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.projects.replace(...)` to use the `PUT` method instead.
   lxd.projects.update(
     name: "project0",
     config: {"features.networks": "false", "features.profiles": "true"},
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Rename project:

   ```crystal
   lxd.projects.rename(name: "project0", new_name: "project1") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Get project state:

   ```crystal
   lxd.projects.state(name: "project0") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |state|
       puts state.resources.try &.containers.try &.limit
       puts state.resources.try &.containers.try &.usage
       puts state.resources.try &.cpu.try &.limit
       # ...
     end
   end
   ```
