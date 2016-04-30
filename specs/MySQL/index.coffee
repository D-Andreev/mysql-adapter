MySQL = require '../../MySQL'
chai = require 'chai'
{expect} = chai
sinon = require 'sinon'
chai.use require 'sinon-chai'


describe 'MySQL', ->

  before ->
    @config =
      host: 'localhost'
      user: 'root'
      password: ''
      database: 'users'
    @mysql = new MySQL @config

    @mysql.conn.createConnection = sinon.stub()
    @mysql.conn.connect = sinon.stub()
    @mysql.conn.end = sinon.stub()
    @mysql.conn.destroy = sinon.stub()
    @mysql.conn.query = sinon.stub()
    @done = sinon.stub()

    @table1 = 'users'
    @table2 = 'pictures'
    @where = id: 1
    @columns = ['id', 'first_name']
    @row =
      first_name: 'firstName'
      last_name: 'lastName'
      email: 'email'


  describe 'constructor', ->

    it 'returns a mysql object', ->
      expect(@mysql).to.be instanceof MySQL


  describe 'connect', ->

    it 'connects', ->
      @mysql.connect @done
      expect(@mysql.conn.connect).to.have.been.calledWith @done


  describe 'close', ->

    it 'closes the connection', ->
      @mysql.close @done
      expect(@mysql.conn.end).to.have.been.calledWith @done


  describe 'destroy', ->

    it 'destroys the connection', ->
      @mysql.destroy()
      expect(@mysql.conn.destroy).to.have.been.called


  describe 'query', ->

    it 'sends the query', ->
      sql = 'SELECT * FROM users'
      @mysql.query sql, ->
      expect(@mysql.conn.query).to.have.been.calledWith sql


  describe 'selectAll', ->

    context 'without where clause', ->

      beforeEach ->
        @mysql.selectAll {table: @table1}, @done
        @expectedSql = 'SELECT * FROM users'

      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with where clause', ->

      beforeEach ->
        @mysql.selectAll {table: @table1, @where}, @done
        @expectedSql = 'SELECT * FROM users WHERE `id` = 1'


      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


  describe 'select', ->

    context 'without where clause', ->

      beforeEach ->
        @mysql.select {table: @table1, @columns}, @done
        @expectedSql = 'SELECT `id`, `first_name` FROM users'


      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with where clause', ->

      beforeEach ->
        @mysql.select {table: @table1, @columns, @where}, @done
        @expectedSql = 'SELECT `id`, `first_name` FROM users WHERE `id` = 1'


      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


  describe 'join', ->

    context 'without where clause', ->

      context 'without columns', ->

        beforeEach ->
          joinType = 'RIGHT'
          joinBy = id: 'picture_id'
          @mysql.join {@table1, @table2, joinBy, joinType}, @done
          @expectedSql = '
                    SELECT * FROM `users`
                    RIGHT JOIN `pictures` on users.id=pictures.picture_id'


        it 'builds the sql and sends it', ->
          expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


      context 'with columns', ->

        beforeEach ->
          joinType = 'RIGHT'
          joinBy = id: 'picture_id'
          @mysql.join {@table1, @table2, @columns, joinBy, joinType}, @done
          @expectedSql = '
                              SELECT `id`, `first_name` FROM `users`
                              RIGHT JOIN `pictures` on users.id=pictures.picture_id'


        it 'builds the sql and sends it', ->
          expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with where clause', ->

      context 'without columns', ->

        beforeEach ->
          joinType = 'RIGHT'
          joinBy = id: 'picture_id'
          @mysql.join {@table1, @table2, @where, joinBy, joinType}, @done
          @expectedSql = '
            SELECT * FROM `users`
            RIGHT JOIN `pictures` on users.id=pictures.picture_id WHERE `id` = 1'


        it 'builds the sql and sends it', ->
          expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


      context 'with columns', ->

        beforeEach ->
          joinType = 'RIGHT'
          joinBy = id: 'picture_id'
          @mysql.join {@table1, @table2, @columns, @where, joinBy, joinType}, @done
          @expectedSql = '
            SELECT `id`, `first_name` FROM `users`
            RIGHT JOIN `pictures` on users.id=pictures.picture_id WHERE `id` = 1'


        it 'builds the sql and sends it', ->
          expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


  describe 'insertOne', ->

    context 'without ignore', ->

      beforeEach ->
        @mysql.insertOne {table: @table1, @row, ignore: false}, @done
        @expectedSql = "
          INSERT  INTO `users` (`first_name`, `last_name`, `email`)
          VALUES ('firstName', 'lastName', 'email')"


      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with ignore', ->

      beforeEach ->
        @mysql.insertOne {table: @table1, @row, ignore: true}, @done
        @expectedSql = "
                  INSERT IGNORE INTO `users` (`first_name`, `last_name`, `email`)
                  VALUES ('firstName', 'lastName', 'email')"


      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


  describe 'update', ->

    context 'without where clause', ->

      beforeEach ->
        @mysql.update {table: @table1, @row}, @done
        @expectedSql = "
          UPDATE users
           SET first_name = 'firstName', last_name = 'lastName', email = 'email'"

      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with where clause', ->

      beforeEach ->
        @mysql.update {table: @table1, @row, @where}, @done
        @expectedSql = "
                  UPDATE users
                   SET first_name = 'firstName', last_name = 'lastName', email = 'email'
                   WHERE `id` = 1"

      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


  describe 'escape', ->

    it 'escapes', ->
      expect(@mysql.conn.escape 'string').to.eql "'string'"
