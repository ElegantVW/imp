Red [Title: "probe-req"]
; THE LAST UNKNOWN BEFORE THE MOUTH SPEAKS.
;
; Measured already, and all of it surprising:
;   to-json make map! [model "imp" temperature 0.7]
;     -> {"model":"imp","temperature":0.7}          WORKS
;   reduce [model "imp" temperature 0.7]
;     -> the STRING "modelimptemperature0.7"        not a block at all
;   map [...]          -> `map` is not a function
;   set req model "x"  -> `set` REFUSES a map! (expect-arg, arg1: map!)
;
; So the route is `make map!` and the only question left is whether the
; spec block EVALUATES its values or stores the bare words. A literal
; worked; a variable is what conjure.red actually has. And `messages`
; has to be a two-element ARRAY of maps, which `reduce` cannot build.

do %src/core.red

PROBE: %/dev/shm/imp/probe-req.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]
mark "OPENED"

model-name: "imp"
temp: 0.7
want: 120

; 1. a variable as a map value
t: try [to-json make map! [model model-name temperature temp]]
mark rejoin ["A1 var-value: " either error? t ["THREW " mold t] [to string! t]]

; 2. the same, inspected, so we know whether it held the value or a word
t: try [mold make map! [model model-name]]
mark rejoin ["A2 make-map-molded: " either error? t ["THREW " mold t] [to string! t]]

; 3. an ARRAY of two maps. `reduce` flattens, so build it by append.
t: try [
    sys: make map! [role "system" content "obey"]
    usr: make map! [role "user" content "a wish"]
    msgs: copy []
    append/only msgs sys
    append/only msgs usr
    to-json msgs
]
mark rejoin ["B1 array-of-two-maps: " either error? t ["THREW " mold t] [to string! t]]

; 4. THE WHOLE REQUEST, assembled the way conjure.red must.
t: try [
    sys: make map! [role "system" content "obey"]
    usr: make map! [role "user" content "a wish"]
    msgs: copy []
    append/only msgs sys
    append/only msgs usr
    to-json make map! [
        model model-name
        messages msgs
        temperature temp
        max_tokens want
        stream false
    ]
]
mark rejoin ["C1 whole-request: " either error? t ["THREW " mold t] [to string! t]]

; 5. does it survive the round trip through load-json? that is what the
;    mouth actually does with it.
t: try [
    sys: make map! [role "system" content "obey"]
    usr: make map! [role "user" content "a round trip"]
    msgs: copy []
    append/only msgs sys
    append/only msgs usr
    back: load-json to-json make map! [
        model model-name
        messages msgs
        temperature temp
        max_tokens want
        stream false
    ]
    mold back/model
]
mark rejoin ["D1 roundtrip-model: " either error? t ["THREW " mold t] [to string! t]]

t: try [
    sys: make map! [role "system" content "obey"]
    usr: make map! [role "user" content "a wish"]
    msgs: copy []
    append/only msgs sys
    append/only msgs usr
    back: load-json to-json make map! [model model-name messages msgs]
    mold back/messages/1/content
]
mark rejoin ["D2 roundtrip-inner-content: " either error? t ["THREW " mold t] [to string! t]]

; 6. and a string containing a quotation mark, which is the one escape
;    that matters for an arbitrary wish. if to-json mangles it, the
;    wish is a shell injection and the mouth must sanitise first.
t: try [
    tricky: to string! {"say \""} 
    to-json make map! [content tricky]
]
mark rejoin ["E1 escaped-quote: " either error? t ["THREW " mold t] [to string! t]]

mark "DONE"
