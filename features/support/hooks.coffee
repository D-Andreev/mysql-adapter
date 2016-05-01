{exec} = require 'child_process'

module.exports = ->

  @Before (scenario, done) ->
    cmd = 'mysql -u root < ./features/scripts/database.sql'
    exec cmd, (error, stdout, stderr) ->
      console.log 'ERROR'
      console.log '='.repeat(20)
      console.log error
      console.log '='.repeat(20)

      console.log 'stdout'
      console.log '='.repeat(20)
      console.log stdout
      console.log '='.repeat(20)

      console.log 'stderr'
      console.log '='.repeat(20)
      console.log stderr
      console.log '='.repeat(20)
      done()
