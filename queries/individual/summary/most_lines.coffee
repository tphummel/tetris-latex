Query = require "../../query"

mostLines = new Query
  body: "
    SELECT GET_PLAYER_NAME(p.playerid,'','') AS name, 
           SUM(p.lines) AS nlines 
    FROM   playermatch p, 
           tntmatch t 
    WHERE  t.matchid = p.matchid 
           AND get_numplayers_inmatch(t.matchid) = 4
    GROUP  BY GET_PLAYER_NAME(p.playerid,'','')
    ORDER  BY nlines DESC
  "

module.exports = mostLines