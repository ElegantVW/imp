Red [Title: "rite-flay"]
do %src/core.red
; FLESHLESS FLay: plain ascii, no escapes at all
p: flay-line "hi" 'ascii 8 1
; WITH one escape
e: flay-line rejoin [to char! 27 "[0mhi" to char! 27 "[0m"] 'unicode 8 1
out: copy ""
append out rejoin ["plain=" mold p "^/"]
append out rejoin ["escape=" mold e "^/"]
write %rite-flay.txt out
