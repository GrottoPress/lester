## Network Peers

See <https://linuxcontainers.org/lxd/api/master/#/metrics>.

### Usage Examples

1. Get metrics:

   ```crystal
   lxd.metrics.fetch(project: "default") do |response|
     puts response
   end
   ```
