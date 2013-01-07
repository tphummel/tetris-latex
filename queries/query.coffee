mysql = require "mysql"
db = require "../config/db"

class Query
  
  constructor: (options={}) ->
    @connection = mysql.createConnection db
    @connection.connect()
    @query = options.body or "SELECT 'this is the default query. pass a query body' FROM dual"
  
  run: (done) ->
    @connection.query @query, (err, rows, fields) =>
      console.log "err: ", err
      console.log "rows: ", rows
      console.log "fields: ", fields
      if err?
        done err
      else
        done rows
      
      @connection.end()

module.exports = Query