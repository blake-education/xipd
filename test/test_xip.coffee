xip = require ".."
{createServer, dig, digShort} = require "./support/helpers"

module.exports =

  "xip.io": (test) ->
    test.expect 1
    createServer (port, done) ->
      digShort port, "A", "xip.io", (result) ->
        test.equal "1.2.3.4", result
        done test.done

  "ns-1.xip.io": (test) ->
    test.expect 1
    createServer (port, done) ->
      digShort port, "A", "ns-1.xip.io", (result) ->
        test.equal "1.2.3.4", result
        done test.done

  "NS query": (test) ->
    test.expect 1
    createServer (port, done) ->
      dig port, "NS", "xip.io", (result) ->
        test.ok result.match /xip\.io\.\s+600\s+IN\s+SOA\s+ns-1\.xip\.io\.\s+hostmaster\.xip\.io\.\s+\d+\s+28800\s+7200\s+604800\s+3600/
        done test.done


  "lookup": (test) ->
    test.expect 1
    createServer (port, done) ->
      address = "10.0.0.2"
      hostname = "#{address}.xip.io."
      digShort port, "A", hostname, (result) ->
        test.equal address, result
        done test.done


  "subdomain lookup": (test) ->
    test.expect 1
    createServer (port, done) ->
      address = "10.0.0.4"
      hostname = "foo.#{address}.xip.io"
      digShort port, "A", hostname, (result) ->
        test.equal address, result
        done test.done

