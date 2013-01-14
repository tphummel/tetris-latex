_       = require "underscore"
fs      = require "fs"
mkdirp  = require "mkdirp"

majors =
  all: 
    values: ["all"]
  year: 
    sql: "YEAR(t.matchdate) = ?"
    values: [2004,2007,2008,2009,2010,2011,2012]
  player: 
    sql: "GET_PLAYER_NAME(p.playerid,'','') = '?'"
    values: ["Dan", "Tom", "JD", "Jeran", "Guest", "Spirk"]    
  location: 
    sql: "GET_LOCATION_NAME(t.location, 'ADDY') = '?'"
    values: [
      "1217 (Pomona, CA)"
      "23C (Pomona, CA)"
      "Mt. Johnson (Rancho Cucamonga, CA)"
      "425 (Upland, CA)"
      "207E (Encino, CA)"
      "14211 (Sherman Oaks, CA)"
    ]

minors = 
  all: 
    values: ["all"]
  # month: ["January", "February", "March", "April", "May", "June"]
  # dom: []
  # dow: 
  #   sql: "DAYNAME(t.matchdate) = '?'"
  #   values: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

# dom = 1
# while dom <= 31
#   minors.dom.push dom
#   dom += 1

scripts = ["performance"] # ["summary", "performance", "time-span", "match-span", "match-streak"]

game_types = 
  sql: "GET_NUMPLAYERS_INMATCH(t.matchid) = ?"
  values: [2,3,4]

outfile_path_root = "#{__dirname}/../parts/tables/"
list_item_limit = 10

for major_name, major of majors
  sql = {}
  for major_value in major.values
    if major.sql
      sql.major = major.sql.replace "?", major_value
    else
      delete sql.major
    
    for minor_name, minor of minors
      
      for minor_value in minor.values
        
        for script in scripts
          script_filename = "#{__dirname}/individual/#{script}"
          
          for game_type in game_types.values
            do (game_type) ->
              caption = "#{game_type}-player Games"
            
              sql.game_type = game_types.sql.replace "?", game_type
            
              sql_pieces = [sql.major, sql.minor, sql.game_type]
              sql_pieces = _.compact sql_pieces
            
              sql_string = sql_pieces.join " AND "
            
              path_pieces = [major_name, major_value, minor_name, minor_value, script, game_type+"p"]
              path = outfile_path_root + path_pieces.join "/"
            
              mkdirp path, (err) ->
            
                opts = 
                  caption: caption
                  where_sql_snippet: sql_string
                  outfile_path: path
                  limit: list_item_limit
            
                require(script_filename)(opts)