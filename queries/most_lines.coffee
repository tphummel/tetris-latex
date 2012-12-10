mysql = require "mysql"
db = require "../config/db"

connection = mysql.createConnection db

connection.connect()

q = "select count(*) as match_count from tntmatch"

connection.query q, (err, rows, fields) ->
  console.log "err: ", err if err?
  console.log "fields: ", fields
  console.log "rows: ", rows
  
connection.end()