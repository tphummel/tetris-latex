mysql = require "mysql"
db = require "../config/db"

connection = mysql.createConnection db

connection.connect()

q = "
  SELECT IF(p.username in ('JD','Tom','Dan','Jeran'), p.username, 'guest') AS name, 
         SUM(m.lines) AS nlines 
  FROM   player p, 
         playermatch m, 
         tntmatch t 
  WHERE  p.playerid = m.playerid 
         AND t.matchid = m.matchid 
         AND (SELECT COUNT(playerid) FROM playermatch p2 WHERE t.matchid = p2.matchid) = 4
  GROUP  BY IF(p.username in ('JD','Tom','Dan','Jeran'), p.username, 'guest')
  ORDER  BY nlines DESC
"

connection.query q, (err, rows, fields) ->
  console.log "err: ", err if err?
  console.log "rows: ", rows
  
connection.end()