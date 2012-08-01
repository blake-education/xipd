fs = require('fs')
aws = require("aws-lib")
config = JSON.parse(fs.readFileSync("./aws.json"))

ec2 = aws.createEC2Client(config.accessKeyId, config.secretAccessKey, {version: '2010-08-31'})


exports.buildDb = (done) ->
  console.log "[aws] - building db"

  tagQuery =
    "Filter.1.Name": "key"
    "Filter.1.Value.1": "Name"
    "Filter.2.Name": "resource-type"
    "Filter.2.Value.1": "instance"

  ec2.call "DescribeTags", tagQuery, (err, result) ->
    return done(err) if err

    instanceNames = {}
    for tag in result.tagSet.item
      instanceNames[tag.resourceId] = tag.value

    instanceQuery = {"Filter.1.Name": "instance-state-name", "Filter.1.Value.1": "running"}
    ec2.call "DescribeInstances", instanceQuery, (err, result) ->
      return done(err) if err

      db = {}
      for resSet in result.reservationSet.item
        instance = resSet.instancesSet.item
        name = instanceNames[instance.instanceId]
        db[name] = instance.ipAddress

      console.log "[aws] - done"
      done(null, db)



exports.updateDb = (cb) ->
  setInterval (=> exports.buildDb(cb)), config.updateInterval * 1000

