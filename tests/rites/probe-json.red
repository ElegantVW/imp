Red [Title: "probe-json"]
; CAN RED BUILD AND PARSE JSON, OR DO I HAND-ROLL IT?
;
; The grimoire says `encode` and `decode` are absent. But the json CODEC
; is in system/codecs, next to png — and the png codec turned out to be
; a real native image/ decoder, so the notes written before I looked
; were wrong in the imp's favour once already. Look before assuming.
;
; Two questions, and both must be answered before conjure.red can grow
; a mouth:
;   1. can Red PARSE a chat-completions reply? (load/as 'json)
;   2. can Red BUILD a request body? (json/encode, or hand-rolled)
;
; Hand-rolling (2) is fine — the wish is the only untrusted input and it
; needs exactly two escapes. Hand-rolling (1) is the one I do not want,
; because a JSON parser written by the same hand that writes the caller
; will agree with itself while being wrong.

do %src/core.red

PROBE: %/dev/shm/imp/probe-json.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]
mark "OPENED"

; ── 1. the json codec itself ──────────────────────────────────────────
t: try [mold system/codecs/json]
mark rejoin ["A1 json-codec: " either error? t ["absent"] [to string! t]]

; ── 2. parse a real reply ─────────────────────────────────────────────
d: try [load/as %/dev/shm/imp/probe-reply.json 'json]
either error? d [
    mark rejoin ["PARSE-FAILED " mold d]
][
    t: try [mold type? :d]
    mark rejoin ["B1 type: " either error? t ["threw"] [to string! t]]

    t: try [mold keys-of d]
    mark rejoin ["B2 keys: " either error? t ["threw"] [to string! t]]

    t: try [mold length? d]
    mark rejoin ["B3 length: " either error? t ["threw"] [to string! t]]

    ; choices -> [0] -> message -> content, the long way down
    t: try [mold d/choices]
    mark rejoin ["B4 choices: " either error? t ["threw " mold t] [copy/part to string! t 60]]

    t: try [c: d/choices  either integer? c ["int"] [either block? c ["block"] [mold type? :c]]]
    mark rejoin ["B5 choices-kind: " either error? t ["threw " mold t] [to string! t]]

    t: try [m: first d/choices  mold type? :m]
    mark rejoin ["B6 first-choice-type: " either error? t ["threw " mold t] [to string! t]]

    t: try [m: first d/choices  mold m/message]
    mark rejoin ["B7 message: " either error? t ["threw " mold t] [copy/part to string! t 60]]

    t: try [m: first d/choices  mold m/message/content]
    mark rejoin ["B8 content: " either error? t ["threw " mold t] [copy/part to string! t 90]]

    t: try [m: first d/choices  either string? m/message/content ["is-string"]["not-string"]]
    mark rejoin ["B9 content-is-string: " either error? t ["threw " mold t] [to string! t]]
]

; ── 3. building a request. hand-rolled is acceptable; prove the two
;       escapes the wish actually needs. ──────────────────────────────
t: try [mold replace "a \"quoted\" wish" {"\""} "\\\""]
mark rejoin ["C1 escape-quote: " either error? t ["threw " mold t] [to string! t]]

t: try [mold replace "back\slash" {"\"} "\\\\"]
mark rejoin ["C2 escape-backslash: " either error? t ["threw " mold t] [to string! t]]

t: try [mold replace "plain wish" {"\""} "\\\""]
mark rejoin ["C3 plain-unchanged: " either error? t ["threw " mold t] [to string! t]]

; ── 4. and the body, assembled the way conjure.red will assemble it ──
t: try [
    w: "a lighthouse in a storm"
    body: rejoin [
        "{"{"model":"imp",""messages":["
        "{"{"role":""system"",""content"":""obey"","}"
        "{"{"role"":""user"",""content"":"" " w " ""}"
        "],""temperature"":0.7,""max_tokens"":120,""stream"":false}"
    ]
    mold body
]
mark rejoin ["D1 hand-built-body: " either error? t ["threw " mold t] [to string! t]]

; ── 5. does a json ENCODER exist, so the body need not be hand-built?
t: try [mold :json]
mark rejoin ["E1 json-word: " either error? t ["absent"] [to string! t]]

t: try [mold :encode]
mark rejoin ["E2 encode-word: " either error? t ["absent"] [to string! t]]

mark "DONE"
