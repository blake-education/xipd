aws = require('../lib/aws')

# TODO stub AWS somehow
module.exports =
  "create AWS db": (test) ->
    test.expect 1

    aws.buildDb (err, db) ->
      console.log db
      test.ok db['ci'].match(/\d+\.\d+\.\d+\.\d+/)
      test.done()

