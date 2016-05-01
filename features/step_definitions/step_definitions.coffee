MySQL = require '../../MySQL'
mysql = new MySQL require '../../config.json'

module.exports = ->

  @When /^I connect to mysql$/, (done) ->
    mysql.connect done


  @Then /^I can ping$/, (done) ->
    mysql.ping done


  @Then /^I should see "(.*)" as the page title$/, (title, callback) ->
    callback()
