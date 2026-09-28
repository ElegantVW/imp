Red [Title: "probe-build"]
; HOW DOES RED BUILD A MAP TO HAND to-json?
;
; conjure.red died inside con-ask, right after the log said "the mouth
; is asked what to paint". The suspect is the request body:
;
;     to-json reduce [model X messages ... temperature 0.7]
;
; `reduce` makes a BLOCK of alternating keys and values, not a map!, and
; to-json may or may not accept that. The grimoire is actively
; contradictory on this point — hazard 1 says `make map!` is REFUSED, the
; changelog says it works, and nobody has measured it. So: measure all
; three routes and print what each actually produces.
;
; The answer decides whether the mouth ever speaks.

do %src/core.red

PROBE: %/dev/shm/imp/probe-build.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]
mark "OPENED"

; route 1 — reduce, i.e. a flat block
t: try [mold type? :reduce [model "imp" temperature 0.7]]
mark rejoin ["A1 reduce-type: " either error? t ["threw"] [to string! t]]

t: try [to-json reduce [model "imp" temperature 0.7]]
mark rejoin ["A2 to-json-of-reduce: " either error? t ["THREW " mold t] [to string! t]]

; route 2 — the map construction spec
t: try [mold map [model "imp" temperature 0.7]]
mark rejoin ["B1 map-spec: " either error? t ["threw"] [to string! t]]

t: try [to-json map [model "imp" temperature 0.7]]
mark rejoin ["B2 to-json-of-map-spec: " either error? t ["THREW " mold t] [to string! t]]

; route 3 — make map!
t: try [mold type? :make map! [model "imp"]]
mark rejoin ["C1 make-map-type: " either error? t ["THREW " mold t] [to string! t]]

t: try [to-json make map! [model "imp" temperature 0.7]]
mark rejoin ["C2 to-json-of-make-map: " either error? t ["THREW " mold t] [to string! t]]

; route 4 — set, for the nested case the request actually needs
t: try [
    req: make map! []
    set req model "imp"
    set req temperature 0.7
    to-json req
]
mark rejoin ["D1 set-then-json: " either error? t ["THREW " mold t] [to string! t]]

; the WHOLE request, the way conjure.red needs it, on the winning route
t: try [
    sys: reduce [role "system" content "obey"]
    usr: reduce [role "user" content "a wish"]
    to-json reduce [
        model "imp"
        messages reduce [sys usr]
        temperature 0.7
        max_tokens 120
        stream false
    ]
]
mark rejoin ["E1 whole-request-reduce: " either error? t ["THREW " mold t] [to string! t]]

t: try [
    sys: map [role "system" content "obey"]
    usr: map [role "user" content "a wish"]
    to-json map [
        model "imp"
        messages reduce [sys usr]
        temperature 0.7
        max_tokens 120
        stream false
    ]
]
mark rejoin ["E2 whole-request-map-spec: " either error? t ["THREW " mold t] [to string! t]]

; and the round trip: does what we build come back through load-json?
t: try [
    txt: to-json map [alpha "one" beta 2 nested map [gamma "three"]]
    back: load-json txt
    mold back/alpha
]
mark rejoin ["F1 roundtrip-nested: " either error? t ["THREW " mold t] [to string! t]]

mark "DONE"
