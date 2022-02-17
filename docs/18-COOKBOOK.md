## Recipes

1. Start/stop instance:

   ```crystal
   # `action` may be any of `start`, `stop`, `freeze`, `unfreeze`, `restart`
   lxd.instances.state.replace("instance-name", action: "start") do |response|
     # ...
   end
   ```

1. Wait on operation to complete:

   ```crystal
   lxd.instances.files.delete("instance-name", "/path/to/file") do |response|
     return false unless response.success?

     response.metadata.try do |operation|
       operation.id.try { |id| lxd.operations.wait(id) if operation.success? }
     end || response
   end
   ```

1. Execute command in instance and check if successful (checks command status code):

   ```crystal
   lxd.instances.exec(
     "instance-name",
     command: ["systemctl", "restart", "nginx"]
   ) do |response|
     return false unless response.success?

     success = response.metadata.try do |operation|
       # ...You may wait on operation to complete here...

       break false unless operation.success?
       operation.metadata.try(&.return.try &.success?)
     end

     success.nil? ? true : success
   end
   ```

1. Copy instance to another server:

   ```crystal
   src = lxd
   dest = Lester.new(...) # <= Use destination server's URI and certificates
   src_cert = src.server.fetch(&.metadata).try(&.environment).try(&.certificate)

   migration = src.instances.rename(
     "instance-name",
     "instance-name", #<= Use same name unless you wish to change at destination
     migration: true,
     live: false
   )

   migration.metadata.try do |operation|
     src_cert.try do |cert|
       dest.instances.create(
         architecture: "x86_64",
         name: "instance-name",
         source: {
           type: "migration",
           mode: "pull",
           operation: "#{src.operations.uri}/#{operation.id}",
           secrets: {
             control: operation.metadata.try(&.control),
             fs: operation.metadata.try(&.fs)
           },
           live: false,
           certificate: cert,
         }
       ) do |response|
         # ...You may wait on operation to complete here...
       end
     end
   end
   ```
