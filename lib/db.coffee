db_config   = require "../config/db"
mysql       = require "mysql"

connection  = mysql.createConnection db_config
connection.connect()

module.exports = 
  conn: connection
  closeConn: ->
    connection.end()