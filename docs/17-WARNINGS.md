## Warnings

A warning is represented as `Lester::Warning`.

See <https://linuxcontainers.org/lxd/api/master/#/warnings> for the raw JSON schema.

### Usage Examples

1. List all warnings:

   ```crystal
   lxd.warnings.list do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |warning|
       puts warning.count
       puts warning.entity
       puts warning.first_seen_at
       # ...
     end
   end
   ```

1. Delete warning:

   ```crystal
   lxd.warnings.delete(uuid: "a1b2c3...") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Fetch warning:

   ```crystal
   lxd.warnings.fetch(uuid: "a1b2c3...") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |warning|
       puts warning.last_message
       puts warning.last_seen_at
       puts warning.location
       # ...
     end
   end
   ```

1. Update warning:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.warnings.replace(...)` to use the `PUT` method instead.
   lxd.warnings.update(uuid: "a1b2c3...", status: "new") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```
