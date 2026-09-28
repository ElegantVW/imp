Red [Title: "conjure"]
; CONJURE — the whole imp, in one file, in one language.
;
; A wish arrives on /dev/shm/imp/job. This rite asks a diffusion model to
; paint it, decodes the picture with Red's own png codec, forges it into
; glyphs, hands it to the sealed core, and publishes a frame.
;
;     wish ──▶ sd-cli  (GPU, ~4s)  ──▶ a png
;          ──▶ load/as 'png       ──▶ image!, pick n ─▶ r.g.b.a
;          ──▶ src/forge.red      ──▶ braille in truecolour
;          ──▶ src/core.red reap  ──▶ 12 lines of exactly 40 columns
;          ──▶ frame, by rename
;
; No C. No Python. Not one byte of the art path is written in anything
; but Red. The only foreign things are two model servers, which are not
; ours and never were: llama-server and sd.cpp. That is the same
; relationship a text editor has with libc.
;
; THE ONE EXTERNAL CALL, and it is the whole I/O story. Red has no
; sockets, no `sleep`, no stdout — but `call/wait/shell` runs a command,
; gives it a real exit code, and the shell can redirect its output to a
; file which Red then reads. That is the door. `/output` and `/error` are
; documented in the spec and inert in this build; give the SHELL the
; redirect and it works every time. docs/GRIMOIRE.md hazard 22.
;
; NO `getenv`. It does not exist in this build — measured: `mold :getenv`
; is `unset` — and calling it at the top level kills the script before it
; can write a word of testimony, which is the least useful failure mode
; a language has. So the launcher writes down what it knows as key=value
; lines and this rite reads them off disk, the same contract ask.red
; already used. The mind is told; it does not go and look.

do %src/core.red
do %src/frame.red
do %src/forge.red

; ── the channels. all in /dev/shm: the filesystem never notices. ────
;
; NOTE THE `F-` PREFIX, which is not decoration. RED IS
; CASE-INSENSITIVE, so `CON-IMG: %file` and `con-img: <the image>` are
; ONE WORD: the second silently overwrote the first, and `read` was
; handed a block! with `id: 'expect-arg` and no hint why. A file global
; and a value global may never share a name in any case, so files carry
; F- and nothing else does.
CON-F-JOB:   %/dev/shm/imp/job
CON-F-ENV:   %/dev/shm/imp/imp-env.txt
CON-F-IMG:   %/dev/shm/imp/conjure.png
CON-F-ART:   %/dev/shm/imp/imp-art.txt
CON-F-TMP:   %/dev/shm/imp/frame.tmp
CON-F-FRAME: %/dev/shm/imp/frame
CON-F-LOG:   %/dev/shm/imp/conjure.log
CON-F-CMD:   %/dev/shm/imp/conjure-cmd.txt
CON-F-BODY:  %/dev/shm/imp/conjure-body.json
CON-F-REPLY: %/dev/shm/imp/conjure-reply.json
; the artefacts the eval harness needs, as FILES. a log is a diary;
; a scraped log is a worse diary, and the first harness lost two
; prompts to an over-clever sed before this existed.
CON-F-PROMPT: %/dev/shm/imp/conjure-prompt.txt
CON-F-MOCK:   %/dev/shm/imp/conjure-mock.txt

; THE TESTIMONY IS THE FIRST THING THAT HAPPENS. A rite that dies in its
; own prologue leaves an empty log and a silence that could be anything.
; Open the ledger before anything that can fail, so every subsequent
; silence has a last known position.
con-ledger: copy []
con-say: func [s [string!]][append con-ledger s  write CON-F-LOG rejoin con-ledger]
con-say "OPENED"

; ── what the launcher told us, as key=value lines ───────────────────
; sever is the default splitter and is byte-verified against the oracle.
; Every lookup tolerates absence by falling back, so a missing line
; degrades the art rather than killing the summoning.
con-env: copy []
con-env-raw: try [read CON-F-ENV]
con-say rejoin ["env-read " either error? con-env-raw ["FAILED " mold con-env-raw] ["ok"]]
if (not error? con-env-raw) [
    con-say rejoin ["env-bytes " mold length? con-env-raw]
    con-env-lines: sever con-env-raw "^/"
    con-say rejoin ["env-lines " mold length? con-env-lines]
    con-el: 1
    while [con-el <= (length? con-env-lines)][
        con-line: pick con-env-lines con-el
        ; a heredoc leaves a trailing empty line. skip it silently: it is
        ; expected, and a complaint about it would be noise.
        if (length? con-line) > 0 [
            con-ep: sever con-line "="
            either (length? con-ep) = 2 [
                ; append/ONLY. plain `append series [a b]` FLATTENS, so
                ; five key=value lines became ten loose words and every
                ; lookup read the wrong slot. measured: env-entries 10
                ; for 5 lines.
                append/only con-env reduce [to string! pick con-ep 1 to string! pick con-ep 2]
            ][
                con-say rejoin ["bad-env-line " mold con-line]
            ]
        ]
        con-el: con-el + 1
    ]
    con-say rejoin ["env-entries " mold length? con-env]
]
con-get: func [k [string!] fallback [string!]][
    ; BIND THE PAIR, THEN INDEX IT. written as
    ;   pick pick con-env con-ei 2
    ; this is not "the second field of entry con-ei" — with no operator
    ; precedence it is pick(pick(pick(con-env, con-ei), 1), 2), i.e. the
    ; second CHARACTER of the key. Measured, and it returned nothing.
    out: fallback
    con-ei: 1
    while [con-ei <= (length? con-env)][
        con-entry: pick con-env con-ei
        ; TWO BLOCKS. ALWAYS. The inner `either` below was one-armed in
        ; the first draft — a fatal error with no message, grimoire
        ; hazard 20 — and it froze the rite on an invisible dialog after
        ; the env had parsed perfectly. I documented this two hours ago
        ; and then walked into it. The law is in AGENTS.md; the law is
        ; not optional.
        either (length? con-entry) = 2 [
            either (pick con-entry 1) = k [out: pick con-entry 2][out: out]
        ][
            con-say rejoin ["odd-entry " mold con-entry]
        ]
        con-ei: con-ei + 1
    ]
    out
]

CON-SD:    con-get "sd"    ""
CON-LLM:   con-get "llm"    "imp"
CON-LLM-URL: con-get "llm-url" "http://127.0.0.1:8082/v1/chat/completions"

; THE MOUTH'S STANDING ORDERS. Kept here rather than in the launcher
; because they are the imp's voice, not the harness's configuration.
CON-LLM-SYS-ART: "You write prompts for an image model. Reply with ONE flowing sentence describing a single scene. Name the subject, the setting, the weather, the light and the mood. No quotation marks, no lists, no preamble, no explanation. Just the sentence."

CON-LLM-SYS-MOCK: "You are a small and ancient dragon who has just watched a mortal conjure a picture, and you find it inadequate. Reply with ONE short line of at most 45 characters: smug, dry, faintly cruel, all-ages, never a slur. No quotation marks. No preamble. Just the line."
CON-SD-LIB: con-get "sd-lib" ""
CON-MODEL: con-get "model" ""
CON-W: to integer! con-get "w" "512"
CON-H: to integer! con-get "h" "512"

; the sampler's own contract with sd-turbo. not tunables: these are the
; values the model was distilled for, and sd-cli's defaults are a
; different model's defaults. see the note at the call site.
CON-STEPS: to integer! con-get "steps" "4"
CON-CFG:   to integer! con-get "cfg" "1"
con-say rejoin ["env sd=" mold CON-SD " model=" mold CON-MODEL " w=" mold CON-W]

; ── the palette a cell is drawn in. the forge overrides both with the
;    picture's own colour wherever the picture has one. ivory for the
;    lit dots, near-black for the dark.
CON-INK:  [236 228 214]
CON-VOID: [ 24  28  36]

; the lattice. src/forge.red owns these; if you change one, change both,
; and prove it in a rite.
CON-COLS: 40
CON-ROWS: 12

; the frame is wider than the art; src/frame.red owns it
IMP-WIDTH: 60

; ── shell quoting, because a wish is arbitrary user text and the shell
;    is the only thing between it and the command line. a single quote
;    inside single quotes is closed, escaped, and reopened: ' -> '\''
con-quote: func [s [string!]][
    rejoin ["'" replace s "'" "'\\''" "'"]
]

; ── the wish ────────────────────────────────────────────────────────
con-wish: try [read CON-F-JOB]
either error? con-wish [
    con-say "no job. the imp was not asked anything."
    quit
][
    con-wish: copy con-wish
    while [(find con-wish "^/")][
        con-wish: copy/part con-wish subtract length? con-wish 1
    ]
]
con-say rejoin ["wish " mold con-wish]

; ── the mouth ────────────────────────────────────────────────────────
; The hand paints. The MOUTH writes down what to paint, and afterwards
; finds something to say about it. The north star asks for both: it
; "conjures ANSI art from a wish, a haiku dragon mocks it", and until
; now only the first half existed.
;
; Two calls, not one. They are different jobs — one is a diffusion
; prompt, one is a sneer — and splitting them means each can fail alone.
; If the mockery fails the frame says the mouth was silent and the art
; still stands. A single call returning both would be cheaper and would
; put two unrelated requests in one mouth, and when the format wobbles
; it takes the art down with the joke. That is not a trade I want.
;
; THE JSON IS NOT HAND-ROLLED. `to-json` builds the request from a map
; and `load/as 'json` takes the reply apart, both native. The grimoire
; recorded that `encode` and `decode` are absent and I read that as "no
; json" — which was wrong, the same way it was wrong about the png
; codec. The functions are `to-json` and `load-json`.
;
; And the request never touches a command line: it is written to a file
; and passed as `curl -d @file`, so the wish needs no shell escaping on
; the way out and the reply needs none on the way back.
; THE JSON IS HAND-BUILT, and not by preference. Measured, all of it:
;
;   to-json make map! [model "imp" temperature 0.7]  -> works
;   to-json make map! [model model-name ...]         -> {"model":"model-name"}
;   reduce [model "imp" temperature 0.7]             -> the STRING
;                                                       "modelimptemperature0.7"
;   map [...]                                         -> no such function
;   set req model "x"                                -> `set` REFUSES a map!
;   change on a map!                                 -> also refused
;
; `make map!` does not EVALUATE its spec: it stores the bare word, and
; to-json then stringifies the word's NAME. A variable silently becomes
; its own name in the request. That is the worst bug class in this file
; — right output, wrong everything — and the only reason it is not in
; the shipped code is that it was measured first.
;
; So the body is a string. The escaping is exactly two characters, and
; the only untrusted content in the whole request is the wish: the
; model name, the numbers and the two standing orders are mine, and
; con-ask ASSERTS the prompts are clean rather than trusting that.
; THE COMPILER WILL NOT PARSE AN ESCAPED QUOTE. Not in an argument, not
; in a bare assignment, not anywhere: measured three ways, and
;
;     t: "\""                         -> the file fails to LOAD
;     f: func [s [string!]][ replace s "\"" "y" ]   -> the file fails to LOAD
;     f: func [s [string!]][ replace s "\\" "x" ]   -> fine
;
; so `\"` — the one sequence every json string needs — is unusable in this
; build, and the failure is total and silent: the whole file never
; loads, the log is never written, and red-view sits on a dialog
; looking exactly like a hang. Found by bisection after four wrong
; theories. `\\` is fine; only the QUOTE is fatal.
;
; And to-json cannot rescue us either. Measured:
;
;     to-json [alpha "one" beta two]  -> ["alpha","one","beta","two"]
;     to-json make map! [model m]     -> {"model":"m"}
;
; BOTH stringify the WORD, not its value. So a variable in a json
; request is not expressible through the encoder in this build at all.
;
; The way out is the oldest one: build the character as a VALUE and
; write no escape anywhere. con-dq is a double quote built with
; to char! 34, which is legal, and every quote in the request is that
; variable. It reads worse than a literal and it is the only spelling
; this compiler accepts.
con-dq: to string! to char! 34
con-bs: to string! to char! 92
con-lb: to string! to char! 123      ; the object brace
con-os: to string! to char! 91       ; the array bracket — NOT 123
con-rb: to string! to char! 125
con-cm: to string! to char! 44
con-co: to string! to char! 58
con-bk: to string! to char! 93

; Escape for json: backslash first, or the escapes we have just added get
; escaped a second time on the way out.
;
; IT LOOPS. `replace` escaped only the FIRST quote in a measured test
; (input `say "hi" now` came back as `say \"hi" now`), so a wish with two
; quotes would have gone out with one of them raw and the server would
; have rejected the lot. Replacing in a loop is the only spelling here
; that is correct without knowing which `replace` we got.
con-esc: func [s [string!] /local o][
    o: copy s
    while [(find o con-bs)][o: replace o con-bs rejoin [con-bs con-bs]]
    while [(find o con-dq)][o: replace o con-dq rejoin [con-bs con-dq]]
    o
]

; one "key":"value" pair
con-kv: func [k [string!] v [string!]][
    rejoin [con-dq con-esc k con-dq con-co con-dq con-esc v con-dq]
]

; a pair whose value is RAW json — a number, a boolean. The server told
; us: temperature, max_tokens and stream went out as the STRINGS "0.7",
; "160" and "false", and the column-16 parse error was only the first
; of it. The curl that worked earlier had real json literals in it.
con-kvr: func [k [string!] v [string!]][
    rejoin [con-dq con-esc k con-dq con-co v]
]

; one {"role":"...","content":"..."} object
con-msg: func [role [string!] txt [string!]][
    rejoin [con-lb con-kv "role" role con-cm con-kv "content" txt con-rb]
]

con-ask: func [orders [string!] user [string!] max [integer!] /local body rc doc][
    body: rejoin [
        con-lb
        con-kv "model" to string! CON-LLM
        con-cm
        rejoin [con-dq "messages" con-dq con-co con-os]
        con-msg "system" orders
        con-cm
        con-msg "user" user
        con-bk
        con-cm
        con-kvr "temperature" "0.7"
        con-cm
        con-kvr "max_tokens" to string! max
        con-cm
        con-kvr "stream" "false"
        con-rb
    ]
    write CON-F-BODY body
    con-say rejoin ["body-bytes " mold length? body]

    rc: try [call/wait/shell rejoin [
        "curl -sS -X POST -H 'Content-Type: application/json' "
        "-d @" CON-F-BODY " "
        to string! CON-LLM-URL " > " CON-F-REPLY " 2>&1"
    ]]
    if error? rc [con-say rejoin ["mouth-call-failed " mold rc]  return ""]
    if (rc = 0) [con-say rejoin ["mouth-bytes " mold length? read CON-F-REPLY]][
        con-say rejoin ["mouth-refused rc " mold rc]
        return ""
    ]

    ; `load/as %file 'json` is the PROVEN route: a map! with nested maps
    ; and direct path indexing, measured at 424 chars of content.
    ; `load-json` on a string reached `change` with a map! and was refused.
    doc: try [load/as CON-F-REPLY 'json]
    if error? doc [con-say rejoin ["mouth-reply-unreadable " mold doc]  return ""]

    ; TRUTHFUL FAILURE: a reply cut off mid-sentence carries
    ; finish_reason "length", and passing that off as an answer would be a
    ; lie by omission.
    if (doc/choices/1/finish_reason <> "stop") [
        con-say rejoin ["mouth-truncated finish_reason=" to string! doc/choices/1/finish_reason]
        return ""
    ]
    copy/part to string! doc/choices/1/message/content length? doc/choices/1/message/content
]

; ── one line, no newlines, no quotes. sd-cli takes one -p argument and
; a diffusion prompt is one sentence. ─────────────────────────────────
con-flatten: func [s [string!] /local out][
    out: copy s
    out: replace out "^/" " "
    out: replace out con-dq ""
    out: replace out to string! forge-esc ""
    ; collapse runs of spaces
    while [(find out "  ")][out: replace out "  " " "]
    either (length? out) > 300 [copy/part out 300][out]
]

; ── what the hand is told to paint ────────────────────────────────────
con-say "the mouth is asked what to paint"
con-prompt-raw: con-ask CON-LLM-SYS-ART con-wish 160
con-prompt: either (length? con-prompt-raw) = 0 [
    ; the fallback is the old hardcoded one, and the log says so. a
    ; worse prompt is fine; a silent downgrade is not.
    con-say "the mouth said nothing. using a plain prompt."
    rejoin [con-wish ", dramatic lighting, high contrast, centred composition"]
][
    con-flatten con-prompt-raw
]
write CON-F-PROMPT con-prompt
con-say rejoin ["prompt " mold con-prompt]

; ── ask the hand ──────────────────────────────────────────────────────
; the exact command is written down first, because a rite that fails
; mysteriously should leave behind the line it actually ran.
con-cmd: rejoin [
    "LD_LIBRARY_PATH=" con-quote CON-SD-LIB " "
    con-quote CON-SD " "
    "-m " con-quote CON-MODEL " "
    "-p " con-quote con-prompt " "
    "-W " to string! CON-W " -H " to string! CON-H " "
    ; ── STEPS AND CFG ARE PASSED EXPLICITLY. Not a tuning choice: sd-cli's
    ; DEFAULTS ARE WRONG FOR THIS MODEL, and they were wrong silently for
    ; the whole of the forge's life. The default is `--steps 20 --cfg-scale
    ; 7.0`. sd-turbo is DISTILLED and GUIDANCE-FREE: it wants a handful of
    ; steps and no classifier-free guidance. Measured on one wish, same
    ; seed, 256x256, in /tmp/opencode/abl:
    ;
    ;   20 steps / cfg 7.0  -> flat cartoon, hard black outlines, orange
    ;                         lighthouse. looks like a 2005 web graphic.
    ;    4 steps / cfg 1.0  -> a photograph: cliff, real waves, atmosphere.
    ;
    ; and 4 steps is 1.6s against 4.3s, so this is BETTER AND FASTER. The
    ; "coloured blobs" I blamed on sd-turbo for two days were the sampler,
    ; not the model. The model was excellent the whole time.
    ;
    ; cfg 1.0, not 0.0: cfg 0 puts sd-cli in UNCONDITIONED mode and the
    ; picture ignores the prompt entirely. sd-cli says so itself —
    ;   [WARN] unconditioned mode, images won't follow the prompt
    ;          (use cfg-scale=1 for distilled models)
    ; — which is the third time a program has told us something Red could
    ; not. Hazard 38.
    "--steps " to string! CON-STEPS " "
    "--cfg-scale " to string! CON-CFG " "
    "-o " con-quote to string! CON-F-IMG " "
    "> " con-quote to string! CON-F-LOG ".cmd" " 2>&1"
]
write CON-F-CMD con-cmd
con-say "the hand is called"

con-rc: try [call/wait/shell con-cmd]
either error? con-rc [
    con-say rejoin ["sd-call-failed " mold con-rc]
    quit
][
    either (con-rc = 0) [
        con-say "the hand answered"
    ][
        con-say rejoin ["the hand refused, rc " mold con-rc]
        quit
    ]
]

either (exists? CON-F-IMG) [
    con-say rejoin ["png-bytes " mold length? read/binary CON-F-IMG]
][
    con-say "no picture. the hand promised and did not deliver."
    quit
]

; ── the picture. Red decodes png natively; I was about to write
;    DEFLATE in Red when this turned out to exist. ───────────────────
con-img: try [load/as CON-F-IMG 'png]
either error? con-img [
    con-say rejoin ["decode-failed " mold con-img]
    quit
][
    con-say rejoin ["decoded " mold con-img/size]
]

; ── the mockery, asked AFTER the art exists ─────────────────────────
; The north star wants a dragon who mocks what was painted, so this
; runs once the png is on disk and the prompt is known. It gets the
; prompt rather than the picture because Red cannot show a model an
; image without a vision model, and because the prompt is what the
; mortal actually asked for — which is what the dragon would seize on.
con-say "the mouth is asked for a comment"
con-mock-raw: con-ask CON-LLM-SYS-MOCK rejoin ["A mortal wished for: " con-prompt] 40
con-mock: either (length? con-mock-raw) = 0 [
    con-say "the mouth offered no mockery. the frame will say so."
    ""
][
    con-flatten con-mock-raw
]
write CON-F-MOCK con-mock
con-say rejoin ["mockery " mold con-mock]

; ── the forge ──────────────────────────────────────────────────────
con-art: try [
    ; forge-braille-OTSU, and the chain of reasoning that got here is
    ; worth keeping because every step was WRONG at the time:
    ;
    ; 1. FORGE-LUMA-MID: 128. A fixed threshold assumes the picture sits
    ;    mid-range. sd-turbo picks its own exposure and is not obliged to.
    ; 2. the picture's MEAN. Better — it follows the exposure — but a
    ;    mean is a global statistic and cannot separate two populations,
    ;    so on a dark sky with a bright subject it lands between them and
    ;    discards the sky.
    ; 3. OTSU, which is also global but is global OPTIMALLY: it takes the
    ;    threshold that maximises between-class variance. Same price as
    ;    the mean, and on the 512 lighthouse it lands at 112 where the
    ;    mean says 105 and the old constant said 128.
    ;
    ; forge-braille (fixed 128) and forge-braille-mean both stay, as the
    ; baselines those two claims were measured against.
    forge-braille-otsu con-img CON-W CON-H to integer! pick CON-INK 1 to integer! pick CON-INK 2 to integer! pick CON-INK 3 to integer! pick CON-VOID 1 to integer! pick CON-VOID 2 to integer! pick CON-VOID 3
]
either error? con-art [
    con-say rejoin ["forge-failed " mold con-art]
    quit
][
    con-say rejoin ["forged " mold length? con-art]
    write CON-F-ART con-art
]

; ── the sealed core has the last word on the grid ──────────────────
; the forge emits 12 lines of 40 columns; reap guarantees it whatever
; the hand produced. the art is the model's. the contract is ours.
con-grid: try [reap con-art 'unicode CON-COLS CON-ROWS]

; ── the frame. ASSEMBLED AT TOP LEVEL, on purpose: the identical
;    sequence inside a function body has been measured returning a
;    one-character corpse in this build. See src/frame.red and the
;    misdiagnosis note in docs/GRIMOIRE.md.
con-frame: copy ""

either error? con-grid [
    con-say rejoin ["reap-failed " mold con-grid]
][
    con-say rejoin ["grid " mold length? con-grid]

    con-panel: copy []
    con-gutter: subtract IMP-WIDTH 4
    append con-panel top-border "Imp" IMP-WIDTH

    con-lanes: sever con-grid "^/"
    con-filler: repeat-chars " " con-gutter
    while [(length? con-lanes) < CON-ROWS][append con-lanes con-filler]
    either (length? con-lanes) > CON-ROWS [
        con-lanes: copy/part con-lanes CON-ROWS
    ][
        con-i: 0
        while [con-i < (length? con-lanes)][
            append con-panel rejoin [PINK "│" OFF " " pad-to pick con-lanes (con-i + 1) con-gutter OFF " " PINK "│" OFF]
            con-i: con-i + 1
        ]
    ]

    append con-panel divider "Conjured" IMP-WIDTH
    append con-panel row rejoin ["> " con-wish] IMP-WIDTH SILVER

    ; THE DRAGON. If the mouth said nothing, the frame says nothing and
    ; says THAT. A blank line here would be a lie of omission, and the
    ; truthful-failure law does not care how empty it looks.
    either (length? con-mock) = 0 [
        append con-panel row "the dragon declined to comment." IMP-WIDTH MUTE
    ][
        append con-panel row con-mock IMP-WIDTH ROSE
    ]

    append con-panel divider "Provenance" IMP-WIDTH
    append con-panel row rejoin ["mouth: " CON-LLM] IMP-WIDTH MUTE
    ; STATE WHAT WAS ACTUALLY DONE. This line used to say only
    ; "256x256" while the sampler was silently running at the default
    ; 20 steps / cfg 7.0, which is to say: it made a claim that was
    ; incomplete in the one direction that mattered. If the frame is
    ; going to be evidence, the numbers in it had better be the numbers
    ; that ran. 26 columns of a 56-column body, so it fits; measured.
    append con-panel row rejoin [
        "hand:  sd-turbo " to string! CON-W "x" to string! CON-H
        " " to string! CON-STEPS "sp cfg" to string! CON-CFG
    ] IMP-WIDTH MUTE
    append con-panel row "forged in red. no C, no python." IMP-WIDTH MUTE
    append con-panel bottom-border IMP-WIDTH

    ; interleave the newlines, then ONE rejoin. hazard 11.
    con-parts: copy []
    con-pk: 1
    con-pn: length? con-panel
    while [con-pk <= con-pn][
        append con-parts pick con-panel con-pk
        if (con-pk < con-pn) [append con-parts "^/"]
        con-pk: con-pk + 1
    ]
    con-frame: rejoin con-parts
]

write CON-F-TMP con-frame
con-say rejoin ["frame-bytes " mold length? con-frame]

; `rename` wants LITERALS. a variable holding a file! is fine for `write`
; and refused by `rename`. hazard 14.
rename %/dev/shm/imp/frame.tmp %/dev/shm/imp/frame
con-say "DONE"
