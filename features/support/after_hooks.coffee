{exec} = require 'child_process'


module.exports = ->

  @After (scenario, done) ->
    cmd = 'mysql -u root -D users -e "DROP DATABASE users"'
    exec cmd, (error, stdout, stderr) ->
      console.log error, stdout, stderr
      done()
