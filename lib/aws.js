(function() {
  var aws, config, ec2, fs;

  fs = require('fs');

  aws = require("aws-lib");

  config = JSON.parse(fs.readFileSync("./aws.json"));

  ec2 = aws.createEC2Client(config.accessKeyId, config.secretAccessKey, {
    version: '2010-08-31'
  });

  exports.buildDb = function(done) {
    var tagQuery;
    tagQuery = {
      "Filter.1.Name": "key",
      "Filter.1.Value.1": "Name",
      "Filter.2.Name": "resource-type",
      "Filter.2.Value.1": "instance"
    };
    return ec2.call("DescribeTags", tagQuery, function(err, result) {
      var instanceNames, instanceQuery, tag, _i, _len, _ref;
      if (err) return done(err);
      instanceNames = {};
      _ref = result.tagSet.item;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tag = _ref[_i];
        instanceNames[tag.resourceId] = tag.value;
      }
      instanceQuery = {
        "Filter.1.Name": "instance-state-name",
        "Filter.1.Value.1": "running"
      };
      return ec2.call("DescribeInstances", instanceQuery, function(err, result) {
        var db, instance, name, resSet, _j, _len2, _ref2;
        if (err) return done(err);
        db = {};
        _ref2 = result.reservationSet.item;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          resSet = _ref2[_j];
          instance = resSet.instancesSet.item;
          name = instanceNames[instance.instanceId];
          db[name] = instance.dnsName;
        }
        return done(null, db);
      });
    });
  };

}).call(this);
