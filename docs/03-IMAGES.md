## Images

An image is represented as `Lester::Image`.

See <https://linuxcontainers.org/lxd/api/master/#/images> for the raw JSON schema.

### Usage Examples

1. List all images:

   ```crystal
   lxd.images.list(project: "default") do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |image|
       puts image.architecture
       puts image.auto_update?
       puts image.cached?
       # ...
     end
   end
   ```

1. Add new image:

   ```crystal
   lxd.images.create(
     fingerprint: "a1b2c3...",
     secret: "super-secret",
     aliases: ["my-image"],
     auto_update: true,
     compression_algorithm: "gzip",
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

1. Delete image:

   ```crystal
   lxd.images.delete(fingerprint: "a1b2c3...") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.err
       puts operation.id
       puts operation.location
       # ...
     end
   end
   ```

1. Fetch single image:

   ```crystal
   lxd.images.fetch(fingerprint: "a1b2c3...") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |image|
       puts image.created_at
       puts image.expires_at
       puts image.filename
       # ...
     end
   end
   ```

1. Update image:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.images.replace(...)` to use the `PUT` method instead.
   lxd.images.update(
     fingerprint: "a1b2c3...",
     auto_update: true,
     public: true,
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Download image:

   ```crystal
   lxd.images.export(
     fingerprint: "a1b2c3...",
     destination: "/home/user/Downloads/image.zip",
     project: "my-project",
   ) do |response|
     puts response.message
   end
   ```

1. Push image to a remote server:

   ```crystal
   lxd.images.push(
     fingerprint: "a1b2c3...",
     target: "https://1.2.3.4:8443",
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.may_cancel?
       puts operation.status
       puts operation.status_code
       # ...
   end
   ```

1. Update local copy of image:

   ```crystal
   lxd.images.refresh(fingerprint: "a1b2c3...") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.metadata.try &.interactive?

       puts operation.metadata.try &.command.try &.each do |command|
         puts command
       end
       
       operation.resources.try &.containers.try &.each do |container|
         puts container
       end
       # ...
   end
   ```

1. Generate secret for use by untrusted clients:

   ```crystal
   lxd.images.generate_secret(fingerprint: "a1b2c3...") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.err
       puts operation.id
       puts operation.location
       # ...
   end
   ```
