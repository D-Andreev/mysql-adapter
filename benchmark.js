// Generated by CoffeeScript 1.10.0
(function() {
  var MySQL, config, fs, i, mysql, query, startTime;

  config = require('./config.json');

  MySQL = require('./MySQL');

  fs = require('fs');

  fs.writeFileSync('./benchmark.txt', '');

  mysql = new MySQL(config);

  i = 0;

  startTime = new Date();

  query = function(i, done) {
    if (i === 10000) {
      return done();
    }
    return mysql.query('SELECT * FROM users', function() {
      i++;
      return query(i, done);
    });
  };

  query(i, function() {
    var endTime;
    endTime = new Date();
    fs.appendFileSync('./benchmark.txt', "Single Connection - " + (endTime - startTime) + "\n");
    mysql = new MySQL(config, true);
    i = 0;
    startTime = new Date();
    query = function(i, done) {
      if (i === 10000) {
        return done();
      }
      return mysql.query('SELECT * FROM users', function() {
        i++;
        return query(i, done);
      });
    };
    return query(i, function() {
      endTime = new Date();
      fs.appendFileSync('./benchmark.txt', "Pool Connection - " + (endTime - startTime) + "\n");
      return process.exit(1);
    });
  });

}).call(this);
