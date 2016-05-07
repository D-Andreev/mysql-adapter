mysql = require 'mysql'
_ = require 'lodash'

module.exports = class MySQL

  constructor: (config, usePool) ->
    if usePool
      @conn = mysql.createPool config
    else
      @conn = mysql.createConnection config


  connect: (done) ->
    @conn.connect done


  close: (done) ->
    @conn.end done


  destroy: ->
    @conn.destroy()


  query: (query, done) ->
    @conn.query query.trim(), done


  selectAll: ({table, where, whereOperator}, done) ->
    sql = "SELECT * FROM #{table} #{@_buildWhereClause where, whereOperator}"

    @query sql, done


  select: ({table, columns, where, whereOperator}, done) ->
    sql = "SELECT #{@_buildColumns columns} FROM #{table} #{@_buildWhereClause where, whereOperator}"

    @query sql, done

    
  join: ({table1, table2, joinType, columns, joinBy, where, whereOperator}, done) ->
    sql = "SELECT #{@_buildColumns columns} FROM `#{table1}` #{joinType} "
    sql += "JOIN `#{table2}` on #{@_buildJoin table1, table2, joinBy} #{@_buildWhereClause where, whereOperator}"

    @query sql, done


  insertOne: ({table, row, ignore}, done) ->
    ignore = if ignore then 'IGNORE' else ''
    sql = "INSERT #{ignore} INTO `#{table}` (#{@_buildColumns _.keys row}) VALUES (#{@_escape _.values row})"

    @query sql, done


  update: ({table, row, where, whereOperator}, done) ->
    sql = "UPDATE #{table} #{@_buildSetClause row} #{@_buildWhereClause where, whereOperator}"

    @query sql, done


  ping: (done) ->
    @conn.ping done


  _escape: (string) ->
    @conn.escape string


  _buildJoin: (table1, table2, joinBy) ->
    joinBy = [joinBy] unless Array.isArray joinBy
    sql = ''
    _.forEach joinBy, (el) ->
      key = _.head _.keys el
      value = _.head _.values el
      sql += "#{table1}.#{key}=#{table2}.#{value} && "

    sql.substring 0, sql.length - 4


  _buildWhereClause: (where, whereOperator) ->
    return '' if _.isUndefined where

    sql = 'WHERE '
    whereOperator ?= 'AND'
    _.forEach where, (v, k) => sql += "`#{k}` = #{@_escape v} #{whereOperator} "

    sql.substring 0, sql.length - 4


  _buildSetClause: (row) ->
    sql = 'SET '
    _.forEach row, (v, k) => sql += "#{k} = #{@_escape v}, "

    sql.substring 0, sql.length - 2


  _buildColumns: (columns) ->
    return '*' if _.isUndefined columns
    columnsStr = ''
    _.forEach columns, (v) -> columnsStr += "`#{v}`, "

    columnsStr.substring 0, columnsStr.length - 2
