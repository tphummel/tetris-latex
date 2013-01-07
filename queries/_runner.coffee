walk = require 'walk'
async = require 'async'
_ = require "underscore"

queryDirs = ['combined', 'individual']

longtableHeadText = "-- continued from previous page"
longtableFootText = "Continued on next page"

objectToTable = (opts) ->
  data = opts.data
  columns = opts.columns
  
  aligns = _.pluck columns, "align"
  columnAligns = "| " + aligns.join(" | ") + " |"
  
  preamble = "\\begin{center}\\begin{longtable}{ #{columnAligns} }\\hline"
  
  for column, i in columns
    align = if i is 0 then "|c|" else "c|"
    preamble += "\\multicolumn{1}{#{align}}{\\textbf{#{column.title}}}"
    preamble += " & " unless i is columns.length - 1
    
  preamble += "\\\\ \\hline \\endfirsthead"
  
  longtable = "
    \\multicolumn{#{columns.length}}{c}%
    {{\\bfseries \\tablename\ \\thetable{} #{longtableHeadText}}} \\\\
    \\hline "
    
  for column, i in columns
    align = if i is 0 then "|c|" else "c|"
    longtable += "\\multicolumn{1}{#{align}}{\\textbf{#{column.title}}}"
    longtable += " & " unless i is columns.length - 1
  
  longtable += "
    \\\\ \\hline \\endhead
    \\hline \\multicolumn{#{columns.length}}{|r|}{{#{longtableFootText}}} \\\\ \\hline
    \\endfoot \\hline \\hline \\endlastfoot"
  
  body = "\\hline"
  console.log "data: ", data
  for row in data
    console.log "row: ", row
    for column, j in columns
      console.log "j: ", j
      console.log "column: ", column
      body += row[column.property]
      body += if j is columns.length - 1 then " \\" else " & "
    body += "\\hline"
  
  footer = "\\end{longtable} \\end{center}"
  
  fullTable = preamble + longtable + body + footer
  return fullTable
  
async.forEachSeries queryDirs, (dir, forEachNext) ->
  walker = walk.walk "#{__dirname}/#{dir}"
  
  walker.on "file", (root, stats, next) ->
    source = "#{root}/#{stats.name}"
    query = require source
    query.run (err, rows) ->
      latexTable = objectToTable 
        data: rows
        columns: query.columns
      
      console.log "rows: ", rows
      console.log "latexTable: ", latexTable
      next()
  
  walker.on "end", ->
    console.log "all queries run in #{dir}"
    forEachNext()