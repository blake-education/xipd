xip = require ".."
{createServer, dig, digShort} = require "./support/helpers"

module.exports =
  "subdomain lookup": (test) ->
    test.expect 1

    subdomain = "ci2"
    cname = "ec2.etc"
    db = xip.MappedSubdomain.db = {}
    db[subdomain] = cname

    # XXX for this testing approach to work, server needs to resolve CNAME-mapped A's, Hmmm.
    createServer (port, done) ->
      hostname = "#{subdomain}.xip.io"
      digShort port, "A", hostname, (result) ->
        test.equal cname, result
        done test.done

