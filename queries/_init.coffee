# load functions and procs

fs = require "fs"
walk = require "walk"
mysql = require "mysql"

db = require "#{__dirname}/../config/db"

connection = mysql.createConnection db
connection.connect()

load = ->

  walker = walk.walk "#{__dirname}/support/", {}

  walker.on "file", (root, stats, next) ->
    source = "#{root}/#{stats.name}"
    console.log "loading support file: #{source}"
    fs.readFile source, 'utf8', (fsErr, queryBody) ->
      console.log "fs err: ", fsErr if fsErr?
      connection.query queryBody, (mysqlErr, rows, fields) ->
        console.log "mysql err: ", mysqlErr if mysqlErr?
        
        next()

  walker.on "end", ->
    console.log "Init Finished!"
    connection.end()

load()