db = require "../lib/db"

class Query
  
  constructor: (options={}) ->
    @body = options.body or "SELECT 'this is the default query. pass a query body' FROM dual"
  
  run: (done) ->
    db.conn.query @body, (err, rows, fields) =>
      done err, rows

module.exports = Query