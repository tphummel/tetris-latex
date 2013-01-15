_       = require "underscore"
fs      = require "fs"
async   = require "async"
mkdirp  = require "mkdirp"
db      = require "../lib/db"

majors = [
  {
    name: "all"
    values: ["all"]
  }
  {
    name: "player"
    sql: "GET_PLAYER_NAME(p.playerid,'','') = '?'"
    values: ["Dan", "Tom", "JD", "Jeran", "Guest", "Spirk"]
  }
  {
    name: "year"
    sql: "YEAR(t.matchdate) = ?"
    values: [2004,2007,2008,2009,2010,2011,2012]
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


sql = {}
fn_vals = {}

ts_start = new Date

major_fn = (major, cb) ->
  fn_vals.major = major
  sql = {}
  async.forEachSeries major.values, major_value_fn, (err) ->
    cb err

major_value_fn = (major_value, cb) ->
  fn_vals.major_value = major_value
  if fn_vals.major.sql
    sql.major = fn_vals.major.sql.replace "?", major_value
  else
    delete sql.major

  async.forEachSeries minors, minor_fn, cb

minor_fn = (minor, cb) ->
  fn_vals.minor = minor
  async.forEachSeries minor.values, minor_value_fn, cb

minor_value_fn = (minor_value, cb) ->
  fn_vals.minor_value = minor_value
  if fn_vals.minor.sql
    sql.minor = fn_vals.minor.sql.replace "?", minor_value
  else
    delete sql.minor
  
  async.forEachSeries scripts, script_fn, cb

script_fn = (script, cb) ->
  fn_vals.script_filename = "#{__dirname}/individual/#{script}"

  async.forEachSeries game_types.values, game_type_fn, cb

game_type_fn = (game_type, cb) ->
  fn_vals.game_type = game_type
  sql.game_type = game_types.sql.replace "?", game_type

  path = build_path fn_vals
  
  opts = 
    caption: build_caption fn_vals
    where_sql_snippet: build_where_snippet sql
    outfile_path: path
    limit: list_item_limit

  query_fn = require fn_vals.script_filename
  
  if fs.existsSync path
    query_fn opts, cb
  else
    mkdirp path, (err) -> 
      query_fn opts, cb

build_where_snippet = (opts) ->
  sql_pieces = [opts.major, opts.minor, opts.game_type]
  sql_pieces = _.compact sql_pieces

  sql_string = sql_pieces.join " AND "
  return sql_string

build_path = (opts) ->
  path_pieces = [
    opts.major.name
    opts.major_value
    opts.minor.name
    opts.minor_value
    opts.script
    opts.game_type+"p"
  ]
  
  path = outfile_path_root + path_pieces.join "/"
  return path

build_caption = (opts) ->
  caption_pieces = []
  unless opts.major.name is "all"
    caption_pieces.push "#{opts.major.name}: #{opts.major_value}" 
  unless opts.minor.name is "all"
    caption_pieces.push "#{opts.minor.name}: #{opts.minor_value}"
  
  caption_pieces.push "#{opts.game_type}P Games"
  
  caption = caption_pieces.join ", "
  return caption

async.forEachSeries majors, major_fn, (major_err) ->
  ts_end = new Date
  console.log "duration: #{(ts_end-ts_start)/1000} s"
  console.log "major callback, closing db"
  db.closeConn()