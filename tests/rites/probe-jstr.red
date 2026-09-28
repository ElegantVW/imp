Red [Title: "probe-jstr"]
; THE MOUTH'S FOUR HELPERS, EXERCISED ONE AT A TIME.
;
; conjure.red now LOADS — the log reaches "the mouth is asked what to
; paint" — and then dies with no body file written, which puts the
; failure inside the `rejoin` that builds the request. Four helpers
; make that rejoin: con-dq, con-esc, con-kv, con-msg. Each is isolated
; here, in its own try, with a witness after it, so the log names the
; guilty one instead of the whole assembly.
;
; The constraint being worked around is documented in conjure.red: this
; compiler cannot parse an escaped double quote anywhere, and to-json
; stringifies a variable's NAME rather than its value. So the quote is
; built as a value with to char! 34.

PROBE: %/dev/shm/imp/probe-jstr.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]
mark "OPENED"

; 1. the quote, built the only legal way
dq: to string! to char! 34
bs: to string! to char! 92
t: try [to string! dq]
mark rejoin ["A1 dq: " either error? t ["threw " mold t] [to string! t]]

t: try [to string! bs]
mark rejoin ["A2 bs: " either error? t ["threw " mold t] [to string! t]]

; 2. replace with a variable as the needle. this is the untested step:
;    everywhere else the needle has been a literal.
t: try [o: replace rejoin ["a" dq "b" bs "c"] dq "X"  to string! o]
mark rejoin ["B1 replace-by-var: " either error? t ["threw " mold t] [to string! t]]

t: try [o: replace rejoin ["a" dq "b" bs "c"] bs "X"  to string! o]
mark rejoin ["B2 replace-bs-var: " either error? t ["threw " mold t] [to string! t]]

; 3. the escape helper, as written in conjure.red
esc: func [s [string!] /local o][
    o: replace s bs rejoin [bs bs]
    replace o dq rejoin [bs dq]
]
t: try [to string! esc rejoin ["say " dq "hi" dq " now"]]
mark rejoin ["C1 escape: " either error? t ["threw " mold t] [to string! t]]

; 4. the pair helper
kv: func [k [string!] v [string!]][
    rejoin [dq esc k dq dq to char! 58 dq esc v dq]
]
t: try [to string! kv "model" "imp"]
mark rejoin ["D1 kv: " either error? t ["threw " mold t] [to string! t]]

t: try [to string! kv "content" "a lighthouse in a storm"]
mark rejoin ["D2 kv-long: " either error? t ["threw " mold t] [to string! t]]

; 5. the message helper
msg: func [role [string!] txt [string!]][
    rejoin [dq kv "role" role rejoin [dq to char! 44 dq] kv "content" txt dq]
]
t: try [to string! msg "system" "obey the brief"]
mark rejoin ["E1 msg: " either error? t ["threw " mold t] [to string! t]]

; 6. the whole request, assembled the way conjure.red assembles it
t: try [
    model-name: "imp"
    orders: "write image prompts"
    wish: "a lighthouse in a storm"
    max: 160
    body: rejoin [
        dq
        kv "model" to string! model-name
        rejoin [dq to char! 44 dq]
        rejoin [dq messages dq dq to char! 58 dq dq]
        msg "system" orders
        rejoin [dq to char! 44 dq]
        msg "user" wish
        rejoin [dq to char! 93 dq to char! 44 dq]
        kv "temperature" "0.7"
        rejoin [dq to char! 44 dq]
        kv "max_tokens" to string! max
        rejoin [dq to char! 44 dq]
        kv "stream" "false"
        dq
    ]
    to string! body
]
mark rejoin ["F1 whole-body: " either error? t ["THREW " mold t] [to string! t]]

; 7. and would the server take it? this is the real acceptance test.
;    `load-json` is deliberately not used to check it — to-json of a
;    STRING is a different path, and the codec's own decode refused a
;    map! on a nested value earlier.
t: try [
    back: load/as %/dev/shm/imp/probe-jstr-body.json 'json
    mold back/model
]
mark rejoin ["G1 reparse-model: " either error? t ["threw " mold t] [to string! t]]

mark "DONE"
