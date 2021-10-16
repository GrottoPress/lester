## Certificates

A trusted certificate is represented as `Lester::Certificate`.

See <https://linuxcontainers.org/lxd/api/master/#/certificates> for the raw JSON schema.

### Usage Examples

1. List all trusted certificates:

   ```crystal
   lxd.certificates.list do |response|
     return puts response.message unless response.success?

     response.metadata.try &.each do |certificate|
       puts certificate.certificate
       puts certificate.fingerprint
       puts certificate.name
       # ...
     end
   end
   ```

1. Add new trusted certificate:

   ```crystal
   lxd.certificates.add(
     certificate: "X509 PEM certificate...",
     name: "castiana",
     password: "secret",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Delete trusted certificate:

   ```crystal
   lxd.certificates.delete(fingerprint: "a1b2c3...") do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```

1. Fetch trusted certificate:

   ```crystal
   lxd.certificates.fetch(fingerprint: "a1b2c3...") do |response|
     return puts response.message unless response.success?

     response.metadata.try do |certificate|
       puts certificate.projects.try &.first?
       puts certificate.restricted?
       puts certificate.type
       # ...
     end
   end
   ```

1. Update trusted certificate:

   ```crystal
   # Uses the `PATCH` request method
   # Call `lxd.certificates.replace(...)` to use `PUT` instead.
   lxd.certificates.update(
     name: "castiana",
     restricted: true,
     type: "client",
     # ...
   ) do |response|
     return puts response.message unless response.success?

     puts response.type
     puts response.code
   end
   ```
