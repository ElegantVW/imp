Red [Title: "esc-walk"]
do %src/core.red
ledger: copy ["OPENED"]
say: func [s [string!]][append ledger s  write %esc-walk.txt rejoin ledger]

esc: to char! 27
line: rejoin ["hi" esc "[0m      "]
say rejoin ["built len=" mold (length? line) "^/"]

say rejoin ["esc-is " mold (esc = to char! 27) "^/"]
say rejoin ["literal-eq " mold (esc = #"^(1B)") "^/"]
say rejoin ["m-literal-eq " mold (#"m" = pick line 5) "^/"]

j: m-end line 3
say rejoin ["m-end " mold j "^/"]

b: bare line
say rejoin ["bare " mold b "^/"]
say "DONE"
