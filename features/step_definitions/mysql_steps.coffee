MySQL = require '../../MySQL'
config = require '../../config.json'
mysql = new MySQL config
results = false
_ = require 'lodash'
{expect} = require 'chai'
where = {}
columns = []

module.exports = ->

  @When /^I am connected to mysql$/, (done) ->
    mysql.ping (err) ->
      mysql = new MySQL config
      return mysql.connect done if err
      done()


  @Then /^I can ping$/, (done) ->
    mysql.ping done


  @Then /^I close the connection$/, (done) ->
    mysql.close done


  @Then /^I destroy the connection$/, ->
    mysql.destroy()


  @When /^I send the query "([^"]*)"$/, (sql, done) ->
    mysql.query sql, (err, res) ->
      return done err if err
      results = res
      done()


  @Then /^I receive the following results$/, (res) ->
    keys = _.keys results[0]
    values = _.values results[0]
    _.forEach res.raw(), (currentRes, i) ->
      expect(currentRes[0]).to.eql keys[i].toString()
      expect(currentRes[1]).to.eql values[i].toString()


  @When /^I select all columns in "([^"]*)" without where clause/, (table, done) ->
    mysql.selectAll {table}, (err, res) ->
      return done err if err
      results = res
      done()


  @When /^I select all columns in "([^"]*)" where$/, (table, whereClause, done) ->
    where = {}
    _.forEach whereClause.raw(), (el) -> where[el[0]] = el[1]

    mysql.selectAll {table, where}, (err, res) ->
      return done err if err
      results = res
      done()


  @When /^I set to select the following columns$/, (cols) ->
    columns = []
    _.forEach cols.raw(), (el) -> columns.push el[0]


  @When /^I set the where clause to$/, (whereClause) ->
    where = {}
    _.forEach whereClause.raw(), (el) -> where[el[0]] = el[1]


  @When /^I perform the select on "([^"]*)"$/, (table, done) ->
    mysql.select {table, columns, where}, (err, res) ->
      return done err if err
      results = res
      done()
