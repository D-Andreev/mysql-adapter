MySQL = require './MySQL'
config = require './config.json'
###
      SELECT * FROM `table1`
      RIGHT JOIN `table2` on table1.id = table2.country_id
      where table2.movie_id = 1
    ###
conn = new MySQL config
conn.connect ->
  columns = ['id', 'first_name']
  where =
    id: 1
  row =
    first_name: 'changed1234'
    last_name: 'changed12ads3'
    email: 'changeadsdaadsadsd123'
  table = 'users'

  conn.update {table, row, ignore: false}, (err, res) ->
    return console.log err if err
    console.log res
