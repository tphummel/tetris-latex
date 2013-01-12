_ = require "underscore"

longtableHeadText = "-- continued from previous page"
longtableFootText = "Continued on next page"

objectToTable = (opts) ->
  data = opts.data
  return "can't create latex table, no data" unless data
  
  columns = opts.columns
  
  warning = "% auto compiled by tom at #{new Date}\n\n"
  
  aligns = _.pluck columns, "align"
  columnAligns = "| " + aligns.join(" | ") + " |"
  
  preamble = "\\begin{center} \n \\begin{longtable}{ #{columnAligns} } \n \\hline \n"
  
  for column, i in columns
    align = if i is 0 then "|c|" else "c|"
    preamble += "\\multicolumn{1}{#{align}}{\\textbf{#{column.title}}}"
    preamble += " & \n" unless i is (columns.length - 1)
    
  preamble += "\\\\ \\hline \n \\endfirsthead \n\n"
  
  longtable = "\\multicolumn{#{columns.length}}{c} \n"
  longtable += "{{\\bfseries \\tablename \\thetable{} #{longtableHeadText}}} \\\\ \n"
  longtable += "\\hline \n"
    
  for column, i in columns
    align = if i is 0 then "|c|" else "c|"
    longtable += "\\multicolumn{1}{#{align}}{\\textbf{#{column.title}}} "
    longtable += " & \n" unless i is (columns.length - 1)
  
  longtable += "\\\\ \\hline \n \\endhead \n\n"
  longtable += "\\hline \\multicolumn{#{columns.length}}{|r|}{{#{longtableFootText}}} \\\\ \\hline \n"
  longtable += "\\endfoot\n \\hline\n \\endlastfoot\n\n"
  
  body = "\\hline\n"
  for row in data
    for column, j in columns
      body += row[column.property]
      body += if j is (columns.length - 1) then " \\\\ \n" else " & "
    body += "\\hline\n"
  
  
  footer = "\n\n"
  footer += "\\end{longtable}\n \\end{center}"
  
  fullTable = warning + preamble + longtable + body + footer
  return fullTable

module.exports = objectToTable