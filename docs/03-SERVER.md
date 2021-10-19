## Server

A server is represented as `Lester::Server`.

See <https://linuxcontainers.org/lxd/api/master/#/server> for the raw JSON schema.

### Usage Examples

1. Get server details:

   ```crystal
   lxd.server.fetch do |response|
     return puts response.message unless response.success?

     response.metadata.try do |server|
       puts server.api_extensions.try &.first?
       puts server.api_status
       puts server.api_version
       # ...
     end
   end
   ```

1. Update server configuration:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.server.replace(...)` to use `PUT` instead.
   lxd.server.update(
     config: {
       "core.https_address": ":8443",
       "core.trust_password": true
     }
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Get server events via websocket:

   ```crystal
   lxd.server.events(type: "logging") do |websocket|
     websocket.on_message do |message|
       puts message
     end

     Signal::INT.trap { websocket.close }

     websocket.run
   end
   ```

1. Get server resources:

   ```crystal
   lxd.server.resources do |response|
     return puts response.message unless response.success?

     response.metadata.try do |resources|
       puts resources.cpu.try &.architecture
       puts resources.gpu.try &.cards.try &.first?.try &.driver
       puts resources.memory.try &.hugepages_size
       # ...
     end
   end
   ```
