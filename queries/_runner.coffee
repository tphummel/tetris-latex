_       = require "underscore"
fs      = require "fs"
mkdirp  = require "mkdirp"

majors = [
  {
    name: "all"
    values: ["all"]
  }
  {
    name: "year"
    sql: "YEAR(t.matchdate) = ?"
    values: [2004,2007,2008,2009,2010,2011,2012]
  }
  {
    name: "player"
    sql: "GET_PLAYER_NAME(p.playerid,'','') = '?'"
    values: ["Dan", "Tom", "JD", "Jeran", "Guest", "Spirk"]
  }
  {
    name: "location"
    sql: "GET_LOCATION_NAME(t.location, 'ADDY') = '?'"
    values: [
      "1217 (Pomona, CA)"
      "23C (Pomona, CA)"
      "Mt. Johnson (Rancho Cucamonga, CA)"
      "425 (Upland, CA)"
      "207E (Encino, CA)"
      "14211 (Sherman Oaks, CA)"
    ]
  }
]


minors = [
  {
    name: "all"
    values: ["all"]
  }
  # {
  #   name: "month"
  #   values: ["January", "February", "March", "April", "May", "June"]
  # }
  # {
  #   name: "dom"
  #   values: []
  # }
  # {
  #   name: "dow"
  #   sql: "DAYNAME(t.matchdate) = '?'"
  #   values: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  # }
]

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

for major in majors
  sql = {}
  for major_value in major.values
    if major.sql
      sql.major = major.sql.replace "?", major_value
    else
      delete sql.major
    
    for minor in minors
      
      for minor_value in minor.values
        if minor.sql
          sql.minor = minor.sql.replace "?", minor_value
        else
          delete sql.major
        
        for script in scripts
          script_filename = "#{__dirname}/individual/#{script}"
          
          for game_type in game_types.values
            do (game_type) ->
              caption = "#{game_type}-player Games"
            
              sql.game_type = game_types.sql.replace "?", game_type
            
              sql_pieces = [sql.major, sql.minor, sql.game_type]
              sql_pieces = _.compact sql_pieces
            
              sql_string = sql_pieces.join " AND "
            
              path_pieces = [major.name, major_value, minor.name, minor_value, script, game_type+"p"]
              path = outfile_path_root + path_pieces.join "/"
              
              opts = 
                caption: caption
                where_sql_snippet: sql_string
                outfile_path: path
                limit: list_item_limit
              
              exists = fs.existsSync path
              
              if exists
                require(script_filename)(opts)
              else
                mkdirp path, (err) -> require(script_filename)(opts)
            
                  
            
                  