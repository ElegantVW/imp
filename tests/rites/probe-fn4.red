Red [Title: "probe-fn4"]
; the functions here RETURN NOTHING. they write what they found, because
; return values in this build are not trustworthy.
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-fn4.txt rejoin ledger]

say "OPENED"

; a: block accumulator, declared /local
probe-a: func [/local panel][
    panel: copy []
    append panel "one"
    append panel "two"
    append %fn-a.txt rejoin ["type " mold type? :panel " len " mold (length? panel) " val " mold panel]
]

; b: string accumulator, declared /local
probe-b: func [/local s][
    s: copy ""
    append s "one"
    append s "^/"
    append s "two"
    append %fn-b.txt rejoin ["type " mold type? :s " len " mold (length? s) " val " mold s]
]

; c: block accumulator, NO /local
probe-c: func [
    gpanel: copy []
    append gpanel "one"
    append gpanel "two"
    append %fn-c.txt rejoin ["type " mold type? :gpanel " len " mold (length? gpanel) " val " mold gpanel]
]

set [e1 x1] try [probe-a]
say rejoin ["a err? " mold error? e1]
set [e2 x2] try [probe-b]
say rejoin ["b err? " mold error? e2]
set [e3 x3] try [probe-c]
say rejoin ["c err? " mold error? e3]

; and the top-level control, for contrast
ctl: copy []
append ctl "one"
append ctl "two"
append %fn-ctl.txt rejoin ["type " mold type? :ctl " len " mold (length? ctl) " val " mold ctl]

say "DONE"
