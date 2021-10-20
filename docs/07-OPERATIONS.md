## Operations

An operation is represented as `Lester::Operation`.

See <https://linuxcontainers.org/lxd/api/master/#/operations> for the raw JSON schema.

### Usage Examples

1. List all operations:

   ```crystal
   lxd.operations.list do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |operation|
       puts operation.class
       puts operation.created_at
       puts operation.description
       # ...
     end
   end
   ```

1. Delete operation:

   ```crystal
   lxd.operations.delete(id: "a1b2c3...") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Fetch operation:

   ```crystal
   lxd.operations.fetch(id: "a1b2c3...") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.err
       puts operation.id
       puts operation.location
       # ...
     end
   end
   ```

1. Wait for operation to complete (or time out):

   ```crystal
   lxd.operations.wait(
     id: "a1b2c3...",
     secret: "password",
     timeout: 60 # seconds
   ) do |response|
     return puts response.message unless response.success?

     response.metadata.try do |operation|
       puts operation.may_cancel?
       puts operation.status
       puts operation.status_code
       # ...
     end
   end
   ```

1. Connect to operation's websocket stream:

   ```crystal
   lxd.operations.websocket(id: "a1b2c3...") do |websocket|
     websocket.on_message do |message|
       puts message
     end

     Signal::INT.trap { websocket.close }

     websocket.run
   end
   ```
