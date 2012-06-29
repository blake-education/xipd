xip = require ".."
{createServer, dig, digShort} = require "./support/helpers"

module.exports =
  "subdomain lookup": (test) ->
    test.expect 1

    subdomain = "ci2"
    ip = "10.2.3.4"
    db = xip.MappedSubdomain.db = {}
    db[subdomain] = ip

    createServer (port, done) ->
      hostname = "#{subdomain}.xip.io"
      digShort port, "A", hostname, (result) ->
        test.equal ip, result
        done test.done

