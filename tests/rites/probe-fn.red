Red [Title: "probe-fn"]
do %src/core.red
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-fn.txt rejoin ledger]

say "OPENED"

f1: func [/local a][a: copy []  append a "hello"  rejoin a "^/"]
set [r1 e1] try [f1]
say rejoin ["f1 err? " mold error? e1 " len " mold (length? r1)]

; while inside a function
f2: func [n [integer!] /local a][a: copy []  append a "hi"  while [2 < n][append a "x"]  rejoin a "^/"]
set [r2 e2] try [f2 5]
say rejoin ["f2 err? " mold error? e2 " len " mold (length? r2)]

; foreach inside a function, /local collector
f3: func [items [block!] /local a i it][a: copy []  i: 0  foreach it items [i: i + 1  append a "x"]  rejoin a "^/"]
set [r3 e3] try [f3 ["one" "two"]]
say rejoin ["f3 err? " mold error? e3 " len " mold (length? r3)]

; foreach WITHOUT declaring the loop word in /local
f4: func [items [block!] /local a][a: copy []  foreach q items [append a "y"]  rejoin a "^/"]
set [r4 e4] try [f4 ["one" "two"]]
say rejoin ["f4 err? " mold error? e4 " len " mold (length? r4)]

; assignment to a /local inside an if inside a function
f5: func [n [integer!] /local a k][a: copy []  k: 3  if k < n [k: 9]  append a "z"  rejoin a "^/"]
set [r5 e5] try [f5 1]
say rejoin ["f5 err? " mold error? e5 " len " mold (length? r5)]

; a func CALL inside a rejoin inside a function
f6: func [w [integer!] /local a][a: copy []  append a rejoin ["q" repeat-chars "-" 3 "w"]  rejoin a "^/"]
set [r6 e6] try [f6 20]
say rejoin ["f6 err? " mold error? e6 " len " mold (length? r6)]

say "DONE"
