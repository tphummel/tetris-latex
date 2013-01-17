_ = require "underscore"

longtableHeadText = "-- continued from previous page"
longtableFootText = "Continued on next page"

objectToTable = (opts) ->
  data = opts.data
  return "can't create latex table, no data" unless data
  
  useLongTable = opts.useLongTable or false
  title = opts.title
  
  
  columns = opts.columns
  
  warning = "% auto compiled by tom at #{new Date}\n\n"
  
  aligns = _.pluck columns, "align"
  # columnAligns = "| " + aligns.join(" | ") + " |"
  columnAligns = aligns.join " "
  
  tableType = if useLongTable then "longtable" else "tabular"
  
  preamble = "\\begin{table} \n"
  preamble += "\t\\caption{#{title}} \n"
  preamble += "\t\\begin{#{tableType}}{ #{columnAligns} } \\toprule "
  
  for column, i in columns
    # align = if i is 0 then "|c|" else "c|"
    align = "c"
    preamble += "\n\t\t \\multicolumn{1}{#{align}}{\\textbf{#{column.title}}}"
    preamble += " &" unless i is (columns.length - 1)
    
  preamble += "\\\\ \\midrule\n"
  
  # longtable = "\\multicolumn{#{columns.length}}{c} \n"
  # longtable += "{{\\bfseries \\tablename \\thetable{} #{longtableHeadText}}} \\\\ \n"
  # longtable += "\\hline \n"
  #   
  # for column, i in columns
  #   align = if i is 0 then "|c|" else "c|"
  #   longtable += "\\multicolumn{1}{#{align}}{\\textbf{#{column.title}}} "
  #   longtable += " & \n" unless i is (columns.length - 1)
  # 
  # longtable += "\\\\ \\hline \n \\endhead \n\n"
  # longtable += "\\hline \\multicolumn{#{columns.length}}{|r|}{{#{longtableFootText}}} \\\\ \\hline \n"
  # longtable += "\\endfoot\n \\hline\n \\endlastfoot\n\n"
  
  # body = "\\bottomrule\n"
  body = ""
  for row in data
    for column, j in columns
      body += row[column.property]
      body += if j is (columns.length - 1) then " \\\\\n " else " & "
  body += "\\bottomrule\n"
  
  footer = "\\end{#{tableType}}\n \\end{table}"
  
  fullTable = warning + preamble
  fullTable += longtable if useLongTable
  fullTable += body + footer
  return fullTable

module.exports = objectToTable