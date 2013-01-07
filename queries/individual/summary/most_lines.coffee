Query = require "../../query"

mostLines = new Query
  body: "
    SELECT IF(get_player_name(p.playerid) in ('JD','Tom','Dan','Jeran'), get_player_name(p.playerid), 'guest') AS name, 
           SUM(p.lines) AS nlines 
    FROM   playermatch p, 
           tntmatch t 
    WHERE  t.matchid = p.matchid 
           AND get_numplayers_inmatch(t.matchid) = 4
    GROUP  BY IF(get_player_name(p.playerid) in ('JD','Tom','Dan','Jeran'), get_player_name(p.playerid), 'guest') AS name
    ORDER  BY nlines DESC
  "

module.exports = mostLines