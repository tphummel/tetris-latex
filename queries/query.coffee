mysql = require "mysql"
db = require "../config/db"

class Query
  
  constructor: (options={}) ->
    @connection = mysql.createConnection db
    @connection.connect()
    @query = options.body or "SELECT 'this is the default query. pass a query body' FROM dual"
    @columns = options.columns
  
  run: (done) ->
    @connection.query @query, (err, rows, fields) =>
      done err, rows
      @connection.end()

module.exports = Query