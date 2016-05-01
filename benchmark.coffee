config = require './config.json'
MySQL = require './MySQL'
fs = require 'fs'
fs.writeFileSync './benchmark.txt', ''
# Single connection
mysql = new MySQL config

i = 0
startTime = new Date()
query = (i, done) ->
  return done() if i is 10000
  mysql.query 'SELECT * FROM users', ->
    i++
    query i, done

query i, ->
  endTime = new Date()
  fs.appendFileSync './benchmark.txt', "Single Connection - #{endTime - startTime}\n"

  # Pool connection
  mysql = new MySQL config, true

  i = 0
  startTime = new Date()
  query = (i, done) ->
    return done() if i is 10000
    mysql.query 'SELECT * FROM users', ->
      i++
      query i, done

  query i, ->
    endTime = new Date()
    fs.appendFileSync './benchmark.txt', "Pool Connection - #{endTime - startTime}\n"
    process.exit 1
