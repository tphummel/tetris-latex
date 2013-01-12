# filenames = []
# for lv_one in ["all", "year", "location", "player"]
#   for lv_two in ["all", "month", "dow"]
#     for lv_three in ["summary", "performance", "time-span", "match-span", "match-streak"]
#       for lv_four in ["all", "4p", "3p", "2p"]
#         filename = ([lv_one, lv_two, lv_three, lv_four].join "_") + ".tex"
#         filenames.push filename
# 
# console.log "filenames: ", filenames
# console.log "filenames.length: ", filenames.length
        
performance = require "#{__dirname}/individual/performance"

performance()