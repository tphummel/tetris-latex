mysql = require "mysql"
db = require "../config/db"

class Query
  
  constructor: (options={}) ->
    @connection = mysql.createConnection db
    @connection.connect()
    @body = options.body or "SELECT 'this is the default query. pass a query body' FROM dual"
  
  run: (done) ->
    @connection.query @body, (err, rows, fields) =>
      done err, rows
      @connection.end()

module.exports = Query