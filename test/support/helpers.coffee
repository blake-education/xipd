xip = require "../.."
{exec} = require "child_process"

exports.createServer = (callback) ->
  server = xip.createServer "xip.io", "1.2.3.4"
  server.bind 0
  {port} = server.address()
  callback port, (done) ->
    server.close()
    done()

exports.dig = (port, type, hostname, callback) ->
  exec "dig @0.0.0.0 -p #{port} #{type} #{hostname}", (err, stdout, stderr) ->
    callback stdout

exports.digShort = (port, type, hostname, callback) ->
  exec "dig +short @0.0.0.0 -p #{port} #{type} #{hostname}", (err, stdout, stderr) ->
    result = stdout.split("\n")[0] unless err
    callback result
  
