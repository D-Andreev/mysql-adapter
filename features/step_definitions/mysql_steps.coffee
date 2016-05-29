{MySQL} = require '../../index'
config = require '../../config.json'
mysql = new MySQL config
results = false
_ = require 'lodash'
{expect} = require 'chai'
where = {}
columns = []
joinBy = []
joinType = ''
table1 = ''
table2 = ''
updatedRow = {}
whereOperator = null

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

    mysql.selectAll {table, where, whereOperator}, (err, res) ->
      whereOperator = null
      return done err if err
      results = res
      done()


  @When /^I delete from "([^"]*)" where$/, (table, whereClause, done) ->
    where = {}
    _.forEach whereClause.raw(), (el) ->
      where[el[0]] = el[1]

    mysql.delete {table, where, whereOperator}, (err, res) ->
      whereOperator = null
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


  @When /^I set to join the results from the tables "([^"]*)", "([^"]*)"$/, (t1, t2) ->
    table1 = t1
    table2 = t2


  @When /^I set the join type to "([^"]*)"$/, (type) ->
    joinType = type


  @When /^I set to join by$/, (cols) ->
    columns = []
    joinBy = _.map cols.raw(), (el) ->
      obj = {}
      obj[el[0]] = el[1]
      obj


  @When /^I perform the join$/, (done) ->
    mysql.join {table1, table2, joinType, joinBy}, (err, res) ->
      return done err if err
      results = res
      done()


  @When /^I insert into "([^"]*)" the row$/, (table, data, done) ->
    row = {}
    _.forEach data.raw(), (el) ->
      row[el[0]] = el[1]

    mysql.insertOne {table, row, ignore: false}, (err, res) ->
      return done err if err
      results = res
      done()


  @When /^I insert into "([^"]*)" the rows$/, (table, data, done) ->
    rows = []
    i = 0
    c = 0
    while i < 2
      row = {}
      j = 0
      while j < 4
        el = data.raw()[c]
        row[el[0]] = el[1]
        j++
        c++
      rows.push row
      i++

    mysql.insertMany {table, rows, ignore: false}, (err, res) ->
      return done err if err
      results = res
      done()


  @When /^I set the updated row to$/, (row) ->
    updatedRow = {}
    _.forEach row.raw(), (el) ->
      updatedRow[el[0]] = el[1]


  @When /^I update the row in "([^"]*)"/, (table, done) ->
    mysql.update {table, row: updatedRow, where}, (err, res) ->
      return done err if err
      results = res
      done()


  @When /^I set the where operator to "([^"]*)"$/, (operator) ->
    whereOperator = operator


  @Then /^I truncate "([^"]*)"$/, (table, done) ->
    mysql.truncate {table}, (err, res) ->
      return done err if err
      done()
