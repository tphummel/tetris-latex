tetris-latex
------------

some tex scripts for a tetris record book


## Roadmap

- query framework
  - parameterize (num players, playerid, locationid, year, month, day of week)
  - standard invocation
  
  - define parameter sets
  - iterate over query directory. run each script for each split
  
- latex table library
  - meta data + table data => latex table
  

  
## Query Organization

file structure:

- combined 
  - perf
  - summary
- individual
  - perf
  - summary
  - streak
  - match span
  - time span
  
output structure: 
  
  - foreach [overall, year, location, player]
    - foreach [overall, month, DOW]
      - foreach [alltime, timespan, matchspan, matchstreak, singlematch]
        - foreach [all, 4p, 3p, 2p]

standard naming:  

ind-perf_query-name
ind-sum_query-name
ind-stk_query-name

all files under queries/ need standard invocation

standard facilities for applying parameters

perf
- most lines
- most time
- 
