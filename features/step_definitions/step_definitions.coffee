module.exports = ->

  @Given /^I am on the Cucumber.js GitHub repository$/, (callback) ->
    callback()

  @When /^I go to the README file$/, (callback) ->
    callback()

  @Then /^I should see "(.*)" as the page title$/, (title, callback) ->
    callback()
