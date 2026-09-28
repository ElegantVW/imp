Red [Title: "probe-net"]
; CAN THE DEMON SPEAK TO THE MOUTH?
; red 0.6.6 has no async io, but the vendored runtime/simple-io.reds
; carries libcurl bindings and a request-http path. this asks.
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-net.txt rejoin ledger]

say "OPENED"

; 1 — is there a `post`?
say rejoin ["post " mold type? :post]
say rejoin ["get " mold type? :get]
say rejoin ["url? " mold type? :url?]
say rejoin ["write-args " mold spec-of :write]

; 2 — a plain GET of the health endpoint
g: try [read http://127.0.0.1:8082/health]
say rejoin ["get-err? " mold error? g]
either error? g [say rejoin ["get-err " mold g]][
    say rejoin ["get-ok len " mold (length? g)]
    say rejoin ["get-body " mold g]
]

say "DONE"
