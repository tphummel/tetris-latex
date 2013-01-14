fs            = require "fs"
moment        = require "moment"
_             = require "underscore"

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

allColumns = [
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

applyColumnTemplates = (data, activeColumns) ->
  for column in activeColumns
    if column.template?
      for row in data
        row[column.property] = column.template row[column.property]

module.exports = (opts={}) ->
  # opts passed in from above could be player, location, year, month, dow
  
  fields = []
  activeColumns = []
  for column in allColumns
    if column.test?
      activeColumns.push column if column.test opts
    else
      activeColumns.push column
  
  fieldsSql = _.pluck activeColumns, "sql"
      
  select = "SELECT " + (fieldsSql.join ", ")
  from = "FROM playermatch p, tntmatch t"
  where = "WHERE t.matchid = p.matchid"
  limit = "LIMIT #{opts.limit}"
  
  for report in reports
    
    for cond in report.conditions
      where += " AND #{cond}"
    
    where += " AND #{opts.where_sql_snippet}" if opts.where_sql_snippet
    
    orderBy = "ORDER BY `#{report.stat}` #{report.sort}"

    fullQuery = [select, from, where, orderBy, limit].join " "
    
    query = new Query 
      body: fullQuery
    
    query.run (err, rows) ->
      
      formattedRows = applyColumnTemplates rows, activeColumns
      # ties logic, # records, second order calculations
      
      tableText = toLatexTable
        data: rows
        columns: activeColumns
      
      # row outfile
      outFile = opts.outfile_path + "/" + report.file + ".tex"
      fs.writeFileSync outFile, tableText, "utf8"
      process.stdout.write "."