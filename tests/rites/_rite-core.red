Red [Title: "rite-core"]
; does the core even load? ask it one question, nothing else.
do %src/core.red
write %rite-core.txt rejoin [
    "sever-exists" mold either (length? sever "a" "^/") = 2 ["yes"]["no"]
]
