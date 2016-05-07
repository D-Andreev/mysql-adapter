MySQL = require '../../MySQL'
chai = require 'chai'
chai.use require 'sinon-chai'
{expect} = chai
sinon = require 'sinon'


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
    @mysql.conn.ping = sinon.stub()
    @done = sinon.stub()

    @table = 'users'
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
      @mysql.query sql, @done
      expect(@mysql.conn.query).to.have.been.calledWith sql


  describe 'selectAll', ->

    context 'without where clause', ->

      beforeEach ->
        @mysql.selectAll {@table}, @done
        @expectedSql = 'SELECT * FROM users'

      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with where clause', ->

      beforeEach ->
        @mysql.selectAll {@table, @where}, @done
        @expectedSql = 'SELECT * FROM users WHERE `id` = 1'


      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with where clause and OR operator', ->
      beforeEach ->
        where = id: 1, name: 'name'
        @mysql.selectAll {@table, where, whereOperator: 'OR'}, @done
        @expectedSql = "SELECT * FROM users WHERE `id` = 1 OR `name` = 'name'"


      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


  describe 'select', ->

    context 'without where clause', ->

      beforeEach ->
        @mysql.select {@table, @columns}, @done
        @expectedSql = 'SELECT `id`, `first_name` FROM users'


      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with where clause', ->

      beforeEach ->
        @mysql.select {@table, @columns, @where}, @done
        @expectedSql = 'SELECT `id`, `first_name` FROM users WHERE `id` = 1'


      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with where clause and OR operator', ->
      beforeEach ->
        where =
          id: 1, name: 'name'
        @mysql.select {@table, where, whereOperator: 'OR'}, @done
        @expectedSql = "SELECT * FROM users WHERE `id` = 1 OR `name` = 'name'"


      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


  describe 'join', ->

    beforeEach ->
      @table1 = @table
      @table2 = 'pictures'
      @joinType = 'RIGHT'
      @joinBy = id: 'picture_id'

    context 'without where clause', ->

      context 'without columns', ->

        beforeEach ->
          @mysql.join {@table1, @table2, @joinBy, @joinType}, @done
          @expectedSql = '
                    SELECT * FROM `users`
                    RIGHT JOIN `pictures` on users.id=pictures.picture_id'


        it 'builds the sql and sends it', ->
          expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


      context 'with columns', ->

        beforeEach ->
          @mysql.join {@table1, @table2, @columns, @joinBy, @joinType}, @done
          @expectedSql = '
                              SELECT `id`, `first_name` FROM `users`
                              RIGHT JOIN `pictures` on users.id=pictures.picture_id'


        it 'builds the sql and sends it', ->
          expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with where clause', ->

      context 'without columns', ->

        beforeEach ->
          @mysql.join {@table1, @table2, @where, @joinBy, @joinType}, @done
          @expectedSql = '
            SELECT * FROM `users`
            RIGHT JOIN `pictures` on users.id=pictures.picture_id WHERE `id` = 1'


        it 'builds the sql and sends it', ->
          expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


      context 'with columns', ->

        beforeEach ->
          @mysql.join {@table1, @table2, @columns, @where, @joinBy, @joinType}, @done
          @expectedSql = '
            SELECT `id`, `first_name` FROM `users`
            RIGHT JOIN `pictures` on users.id=pictures.picture_id WHERE `id` = 1'


        it 'builds the sql and sends it', ->
          expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


      context 'with OR operator', ->
        beforeEach ->
          where =
            id: 1, name: 'name'
          @mysql.join {@table1, @table2, @columns, where, whereOperator: 'OR', @joinBy, @joinType}, @done
          @expectedSql = "
                                SELECT `id`, `first_name` FROM `users`
                                RIGHT JOIN `pictures` on users.id=pictures.picture_id WHERE `id` = 1 OR `name` = 'name'"


        it 'builds the sql and sends it', ->
          expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


  describe 'insertOne', ->

    context 'without ignore', ->

      beforeEach ->
        @mysql.insertOne {@table, @row, ignore: false}, @done
        @expectedSql = "
          INSERT  INTO `users` (`first_name`, `last_name`, `email`)
          VALUES ('firstName', 'lastName', 'email')"


      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with ignore', ->

      beforeEach ->
        @mysql.insertOne {@table, @row, ignore: true}, @done
        @expectedSql = "
                  INSERT IGNORE INTO `users` (`first_name`, `last_name`, `email`)
                  VALUES ('firstName', 'lastName', 'email')"


      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


  describe 'update', ->

    context 'without where clause', ->

      beforeEach ->
        @mysql.update {@table, @row}, @done
        @expectedSql = "
          UPDATE users
           SET first_name = 'firstName', last_name = 'lastName', email = 'email'"

      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with where clause', ->

      beforeEach ->
        @mysql.update {@table, @row, @where}, @done
        @expectedSql = "
                  UPDATE users
                   SET first_name = 'firstName', last_name = 'lastName', email = 'email'
                   WHERE `id` = 1"

      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


    context 'with where clause and OR operator', ->
      beforeEach ->
        where =
          id: 1, name: 'name'
        @mysql.update {@table, @row, where, whereOperator: 'OR'}, @done
        @expectedSql = "
                                  UPDATE users
                                   SET first_name = 'firstName', last_name = 'lastName', email = 'email'
                                   WHERE `id` = 1 OR `name` = 'name'"

      it 'builds the sql and sends it', ->
        expect(@mysql.conn.query).to.have.been.calledWith @expectedSql


  describe 'ping', ->

    it 'pings', ->
      @mysql.ping @done
      expect(@mysql.conn.ping).to.have.been.calledWithExactly @done
