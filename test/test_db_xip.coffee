xip = require ".."
{createServer, dig, digShort} = require "./support/helpers"

module.exports =
  "subdomain lookup": (test) ->
    test.expect 1
    createServer (port, done) ->
      address = "10.0.0.4"
      hostname = "foo.#{address}.xip.io"
      digShort port, "A", hostname, (result) ->
        test.equal address, result
        done test.done

