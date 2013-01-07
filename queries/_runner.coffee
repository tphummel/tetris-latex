walk = require 'walk'
async = require 'async'

queryDirs = ['combined', 'individual']

async.forEachSeries queryDirs, (dir, forEachNext) ->
  console.log "query dir: #{dir}"
  walker = walk.walk "#{__dirname}/#{dir}"
  
  walker.on "file", (root, stats, next) ->
    source = "#{root}/#{stats.name}"
    console.log "source: ", source
    query = require source
    query.run (err, rows) ->
      console.log "rows: ", rows
      next()
  
  walker.on "end", ->
    console.log "all queries run in #{dir}"
    forEachNext()