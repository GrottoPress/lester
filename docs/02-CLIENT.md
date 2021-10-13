## Client

A *client* is responsible for querying all API *endpoints*, and returning *response*s from the API server.

You may instantiate a client in one of two ways:

1. With a local UNIX socket

   ```crystal
   lxd = Lester.new(socket: "/var/snap/lxd/common/lxd/unix.socket")
   ```

1. With a remote URL

   ```crystal
   lxd = Lester.new(
     base_uri: "https://1.2.3.4:8443",
     private_key: "priv.key",
     certificate: "cert.pem",
     # ca_certificates: "ca.pem",
     # verify_mode: "none"
   )
   ```

From here on, you are ready to query *endpoint*s using the `lxd` client you just created.
