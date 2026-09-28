Red [Title: "probe-json2"]
; THE ONE QUESTION THAT MATTERS: can Red parse a chat reply?
;
; The previous probe died at LOAD, not at run, because I tried to build
; a json body out of interleaved quote-strings and set-words. In this
; substrate a load error is indistinguishable from silence, so the
; habit now is: ask one question, in the most boring syntax available.
;
; If `load/as %f 'json` works, conjure.red can grow a mouth without me
; hand-writing a parser — which matters, because a parser written by the
; same hand as the caller agrees with itself while being wrong.

do %src/core.red

PROBE: %/dev/shm/imp/probe-json2.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]
mark "OPENED"

t: try [mold system/codecs/json]
mark rejoin ["A1 json-codec: " either error? t ["absent"] [to string! t]]

d: try [load/as %/dev/shm/imp/probe-reply.json 'json]
either error? d [
    mark rejoin ["PARSE-FAILED " mold d]
][
    t: try [mold type? :d]
    mark rejoin ["B1 type: " either error? t ["threw"] [to string! t]]

    t: try [mold keys-of d]
    mark rejoin ["B2 keys: " either error? t ["threw"] [to string! t]]

    ; the long way down: choices -> first -> message -> content
    t: try [
        c: d/choices
        either block? c ["choices-is-block"][either string? c ["choices-is-string"][mold type? :c]]
    ]
    mark rejoin ["B3 choices-kind: " either error? t ["threw " mold t] [to string! t]]

    t: try [
        c: first d/choices
        mold type? :c
    ]
    mark rejoin ["B4 first-choice-type: " either error? t ["threw " mold t] [to string! t]]

    t: try [mold d/choices/1/message/role]
    mark rejoin ["B5 direct-path-role: " either error? t ["threw " mold t] [to string! t]]

    t: try [
        s: d/choices/1/message/content
        either string? s ["is-string"]["not-string"]
    ]
    mark rejoin ["B6 direct-content-is-string: " either error? t ["threw " mold t] [to string! t]]

    t: try [mold copy/part to string! d/choices/1/message/content 70]
    mark rejoin ["B7 content-first-70: " either error? t ["threw " mold t] [to string! t]]

    t: try [mold length? d/choices/1/message/content]
    mark rejoin ["B8 content-length: " either error? t ["threw"] [to string! t]]

    ; the finish_reason is how the imp knows the mouth actually finished
    t: try [mold d/choices/1/finish_reason]
    mark rejoin ["B9 finish_reason: " either error? t ["threw " mold t] [to string! t]]
]

; and the two functions the old grimoire said were absent
t: try [mold :encode]
mark rejoin ["C1 encode-word: " either error? t ["absent"] [to string! t]]

t: try [mold :decode]
mark rejoin ["C2 decode-word: " either error? t ["absent"] [to string! t]]

t: try [mold :json]
mark rejoin ["C3 json-word: " either error? t ["absent"] [to string! t]]

mark "DONE"
