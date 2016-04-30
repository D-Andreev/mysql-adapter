### MySQL Adapter

#### Examples

```coffeescript
# Require the package
MySql = require 'mysql-adapter'

# Make your mysql config
config = 
  host: 'localhost'
  password: ''
  database: 'database'
  
# Make new instance of MySQL
conn = new MySQL config

# Connect
conn.connect (err) ->
  # Do stuff
```

```coffeescript
# Making a custom query
conn.query 'SELECT * from table', (err, res) ->
```

```coffeescript
table = 'table'

# Select all columns in a table without where clause
# SELECT * FROM `table`
conn.selectAll {table}, (err, res) ->

# Select all columns in a table with where clause
# SELECT * FROM `table` WHERE `id` = 1
where = id: 1
conn.selectAll {table, where}, (err, res) ->
```

```coffeescript
# Select specific columns in a table
# SELECT `id`, `first_name` FROM `table` WHERE `id` = 1
table = 'table'
columns = ['id', 'first_name']
where = id: 1
conn.select {table, columns, where}, (err, res) ->
```

```coffeescript
# Query with join
###
  SELECT * FROM `users`
  RIGHT JOIN `pictures` on users.id = pictures.picture_id
  where pictures.id = 1
###
table1 = 'users'
table2 = 'pictures'
joinType = 'RIGHT'
columns = ['id', 'first_name']
joinBy = 
  'id': 'picture_id'
where = id: 1
conn.join {table1, table2, joinType, columns, joinBy, where}, (err, res) ->
```

```coffeescript
# Insert a row
# INSERT IGNORE INTO `users` (`first_name`, `last_name`, `email`) VALUES ('first', 'last', 'email')
table = 'users'
row = 
  first_name: 'first'
  last_name: 'last'
  email: 'email'
ignore = true
conn.insertOne {table, row, ignore}, (err, res) ->
```

```coffeescript
# Update a row
###
 UPDATE `users`
 SET `first_name`='new_first_name' && `last_name`='new_last_name' && `email`='new_email'
 WHERE `id` = 1
###
table = 'users'
row =
  first_name: 'new_first_name'
  last_name: 'new_last_name'
  email: 'new_email'
where = id: 1
conn.insertOne {table, row, where}, (err, res) ->
```
