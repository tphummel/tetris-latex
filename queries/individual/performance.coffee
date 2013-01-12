# params = 
#   sort: "asc" or "desc"
#   limit: 10
#   conditions: {}
  
# conditions = [
#   "p.lines >= 100"
#   "p.wrank = GET_NUMPLAYERS_INMATCH(t.matchid)"
#   "t.locationid = 1"
#   ]

fs            = require "fs"
moment        = require "moment"

Query         = require "../query"
toLatexTable  = require "../toLatexTable"

reports = [
    {
      file: "most_lines"
      conditions: []
      stat: "lines"
      sort: "desc"
    }
  ]

columns = [
  {
    title: "Match ID"
    property: "id"
    align: "l"
    sql: "t.matchid AS id"
  }
  {
    title: "Date" 
    property: "match_date"
    align: "l"
    sql: "t.matchdate AS match_date"
    template: (value) -> (moment value).format "MM/DD/YYYY"
  }
  {
    title: "Location" 
    property: "location"
    align: "l"
    sql: "GET_LOCATION_NAME(t.location,'') AS location"
    test: (opts) -> opts.locationId? is false
  }
  {
    title: "Player" 
    property: "player"
    align: "l"
    sql: "GET_PLAYER_NAME(p.playerid,'','') AS player"
    test: (opts) -> opts.playerId? is false
  }
  {
    title: "Lines" 
    property: "lines"
    align: "r"
    sql: "p.`lines` AS `lines`"
  }
  {
    title: "Time" 
    property: "time"
    align: "r"
    sql: "p.`time` AS `time`"
  }
  {
    title: "Win Rank" 
    property: "win_rank"
    align: "r"
    sql: "p.wrank AS win_rank"
  }
  {
    title: "Ratio Rank" 
    property: "ratio_rank"
    align: "r"
    sql: "p.erank AS ratio_rank"
  }
]

applyColumnTemplates = (data) ->
  for column in columns
    if column.template?
      for row in data
        row[column.property] = column.template row[column.property]

module.exports = (opts={}) ->
  # opts passed in from above could be player, location, year, month, dow
  
  # cherrypicking my specific run
  opts.numPlayers = 4
  opts.playerId = 4 # tom
  opts.locationId = null # all locations
  opts.outfilePath = "#{__dirname}/../../parts/tables/"
  opts.limit = 10
  
  fields = []
  for column in columns
    if column.test?
      fields.push column.sql if column.test opts
    else
      fields.push column.sql
      
  select = "SELECT " + (fields.join ", ")
  from = "FROM playermatch p, tntmatch t"
  where = "WHERE t.matchid = p.matchid"
  limit = "LIMIT #{opts.limit}"
  
  for report in reports
    
    for cond in report.conditions
      where += " AND #{cond}"
    
    orderBy = "ORDER BY `#{report.stat}` #{report.sort}"

    fullQuery = [select, from, where, orderBy, limit].join " "
    
    console.log "fullQuery: ", fullQuery
    query = new Query 
      body: fullQuery
    
    query.run (err, rows) ->
      console.log "rows: ", rows
      
      formattedRows = applyColumnTemplates rows
      # ties logic, # records, second order calculations
      
      # convert rows to latex
      tableText = toLatexTable
        data: rows
        columns: columns
        
      console.log "tableText: ", tableText
      
      file = opts.outFilePath + report.file + ".tex"
      
      # row outfile
      fs.writeFileSync file, tableText, "utf8"
  
    return fullQuery