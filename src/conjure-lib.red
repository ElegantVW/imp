Red [Title: "conjure-lib"]
; CONJURE — the whole imp, as a LIBRARY.
;
; A wish arrives, this rite asks a diffusion model to paint it, decodes
; the picture with Red's own png codec, forges it into glyphs, hands it
; to the sealed core, and publishes a frame.
;
;     wish ──▶ sd-cli  (GPU, ~4s)  ──▶ a png
;          ──▶ load/as 'png       ──▶ image!, pick n ─▶ r.g.b.a
;          ──▶ src/forge.red      ──▶ braille in truecolour
;          ──▶ src/core.red reap  ──▶ 12 lines of exactly 40 columns
;          ──▶ frame, by rename
;
; No C. No Python. Not one byte of the art path is written in anything
; but Red. The only foreign things are two model servers, which are not
; ours and never were: llama-server and sd.cpp.
;
; ── WHY A LIBRARY ───────────────────────────────────────────────────
; `imp "a wish"` used to run this file as a script that `quit` on every
; error. The TUI cannot do that: `quit` kills the window, and the user
; asked to conjure again from the same one. So the pipeline lives here,
; never quits, and returns `"ok"` or a `fail:` string. Two doors:
;
;   con-run            blocking. what `imp "a wish"` calls.
;   con-begin / con-tick
;                      asynchronous. what the window calls. `call` without
;                      `/wait` (hazard 23) so a rate facet can paint a
;                      flame while sd-cli thinks. Sealed by rite-flame.
;
; THIS FILE NEVER VIEWS AND NEVER QUITS. A file that quits is a file no
; window can call.
;
; ── PATHS ───────────────────────────────────────────────────────────
; This file lives in src/. `do` change-dirs to the script's own
; directory, so `%core.red` is correct here. The one-shot wrapper
; (`src/conjure.red`, staged to the repo root) does `%src/conjure-lib.red`
; and that is how it arrives.
;
; THE TESTIMONY IS THE FIRST THING THAT HAPPENS. A rite that dies in its
; own prologue leaves an empty log and a silence that could be anything.

do %core.red
do %frame.red
do %forge.red

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
CON-F-PROMPT: %/dev/shm/imp/conjure-prompt.txt
CON-F-MOCK:   %/dev/shm/imp/conjure-mock.txt
CON-F-RC:     %/dev/shm/imp/con-rc.txt

con-ledger: copy []
con-say: func [s [string!]][append con-ledger s  write CON-F-LOG rejoin con-ledger]
con-say "OPENED"

; ── what the launcher told us, as key=value lines ───────────────────
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
        if (length? con-line) > 0 [
            con-ep: sever con-line "="
            either (length? con-ep) = 2 [
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
    out: fallback
    con-ei: 1
    while [con-ei <= (length? con-env)][
        con-entry: pick con-env con-ei
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

CON-LLM-SYS-ART: "You write prompts for an image model. Reply with ONE flowing sentence describing a single scene. Name the subject, the setting, the weather, the light and the mood. No quotation marks, no lists, no preamble, no explanation. Just the sentence. /no_think"

CON-LLM-SYS-MOCK: "You are a small and ancient dragon who has just watched a mortal conjure a picture, and you find it inadequate. Reply with ONE short line of at most 45 characters: smug, dry, faintly cruel, all-ages, never a slur. No quotation marks. No preamble. Just the line. /no_think"
CON-SD-LIB: con-get "sd-lib" ""
CON-MODEL: con-get "model" ""
CON-W: to integer! con-get "w" "512"
CON-H: to integer! con-get "h" "512"

CON-STEPS: to integer! con-get "steps" "4"
CON-CFG:   to integer! con-get "cfg" "1"
con-say rejoin ["env sd=" mold CON-SD " model=" mold CON-MODEL " w=" mold CON-W]

CON-INK:  [236 228 214]
CON-VOID: [ 24  28  36]

CON-COLS: 40
CON-ROWS: 12

IMP-WIDTH: 60

con-wish: ""
con-prompt: ""
con-mock: ""
con-cmd: ""
CON-PHASE: "idle"
CON-PIC: none
; the style the hand paints in, and whether the mouth gets a say.
; one-shot defaults: photography, mouth on — exactly what the old
; top-level pipeline did, so `imp "a wish"` cannot tell the move.
CON-STYLE: 1
CON-STYLE-NAME: "Photography"
CON-ENH: "on"

; ── the seven styles. each is name / mouth-directive / sd-suffix.
; The mouth gets the directive folded into its orders; with enhance
; off the mortal's own words go out with the suffix and nothing else.
; With enhance ON the mouth writes the sentence AND the suffix is
; appended after — enhance chooses who writes, never whether the
; style applies. Suffixes steer the LOOK (light, line, shade).
con-style-entry: func [si [integer!] /local out][
    out: pick CON-STYLES si
    either (out = none) [out: pick CON-STYLES 1][]
    out
]
con-get-style-name: func [si [integer!] /local out][
    out: pick (con-style-entry si) 1
    out
]
con-style-directive: func [si [integer!] /local out][
    out: pick (con-style-entry si) 2
    out
]
con-style-suffix: func [si [integer!] /local out][
    out: pick (con-style-entry si) 3
    out
]
CON-STYLES: [
    ["Photography" "a photograph, realistic light and natural colour" ", photorealistic, natural lighting, 35mm photograph, sharp focus"]
    ["Pixel art" "retro pixel art, crisp pixels and a limited palette" ", pixel art, 16-bit, crisp pixels, limited palette"]
    ["Mignola" "a mike mignola comic panel, heavy black shadows like woodcut ink" ", mike mignola style, heavy black shadows, hollow black shapes, white paper negative space, woodcut ink"]
    ["3D animation" "a 3d animated film still, soft volumetric light" ", 3d animated film still, soft volumetric light, stylized, high detail"]
    ["Hentai" "an anime-style illustration, cel shaded with clean line art" ", anime style illustration, cel shaded, clean line art, vibrant colours"]
    ["Anime" "an anime still, cel shaded with a detailed background" ", anime style, cel shaded, detailed background"]
    ["Vintage anime" "a vintage 1980s japanese anime cel, film grain and all" ", vintage 1980s japanese anime cel, film grain, retro"]
]
CON-STYLE-NAMES: copy []
foreach con-st CON-STYLES [append CON-STYLE-NAMES pick con-st 1]

; ── the hands. name / steps / cfg each; the model FILE comes from
; the launcher's env (sdxl=, pony=), because paths are the harness's
; business, not the program's. turbo's file is the standing default.
CON-HANDS: [
    ["turbo" 4 1 "Keep it under 30 words, punchy, concrete nouns only."]
    ["SDXL" 20 7 "One flowing sentence: subject, setting, weather, light, mood."]
    ["Pony" 25 7 "Comma-separated Danbooru-style tags, then one short scene phrase."]
]
CON-HAND: 1
CON-HAND-NAME: "turbo"
CON-HAND-NAMES: copy []
foreach con-hd CON-HANDS [append CON-HAND-NAMES pick con-hd 1]
con-hand-pick: func [hi [integer!] n [integer!] /local e out][
    out: none
    e: pick CON-HANDS hi
    either (e = none) [out: none][out: pick e n]
    out
]
con-get-hand-name: func [hi [integer!] /local out][
    out: con-hand-pick hi 1
    either (out = none) [out: "turbo"][]
    out
]
con-hand-steps: func [hi [integer!] /local out][
    out: con-hand-pick hi 2
    either (out = none) [out: 4][]
    out
]
con-hand-cfg: func [hi [integer!] /local out][
    out: con-hand-pick hi 3
    either (out = none) [out: 1][]
    out
]
con-hand-brief: func [hi [integer!] /local out][
    out: con-hand-pick hi 4
    either (out = none) [out: "One flowing sentence."][
    ]
    out
]
; Pony reads score tags, not sentences. Everyone else reads prose.
con-hand-prefix: func [hi [integer!] /local out][
    out: ""
    if (hi = 3) [out: "score_9, score_8_up, score_7_up, "]
    out
]
con-hand-file: func [hi [integer!] /local out][
    out: ""
    if (hi = 1) [out: CON-MODEL]
    if (hi = 2) [out: con-get "sdxl" ""]
    if (hi = 3) [out: con-get "pony" ""]
    out
]

; ── how long a silence may last. A spawn that never reports back is
; a dead pipeline, not a slow one; the window must say so instead of
; burning forever. 666 seconds, per the numerology law.
CON-TIMEOUT: 666
CON-T0: 0

; tongues of fire. the count is the block's length, which is
; forge-div BEAST 111 — six — and is not written as a literal here.
CON-FLAMES: [
    "      )     "
    "     )(     "
    "    )  (    "
    "    )(      "
    "    (  )    "
    "     ()     "
]

con-quote: func [s [string!]][
    rejoin ["'" replace s "'" "'\\''" "'"]
]

; THE COMPILER WILL NOT PARSE AN ESCAPED QUOTE. Not in an argument, not
; in a bare assignment, not anywhere. `\"` makes the whole file fail to
; LOAD, silently. Build the character as a VALUE. Hazard 35.
con-dq: to string! to char! 34
con-bs: to string! to char! 92
con-lb: to string! to char! 123
con-os: to string! to char! 91
con-rb: to string! to char! 125
con-cm: to string! to char! 44
con-co: to string! to char! 58
con-bk: to string! to char! 93

; IT LOOPS. `replace` escaped only the FIRST quote. Hazard 37.
con-esc: func [s [string!] /local o][
    o: copy s
    while [(find o con-bs)][o: replace o con-bs rejoin [con-bs con-bs]]
    while [(find o con-dq)][o: replace o con-dq rejoin [con-bs con-dq]]
    o
]

con-kv: func [k [string!] v [string!]][
    rejoin [con-dq con-esc k con-dq con-co con-dq con-esc v con-dq]
]

con-kvr: func [k [string!] v [string!]][
    rejoin [con-dq con-esc k con-dq con-co v]
]

con-msg: func [role [string!] txt [string!]][
    rejoin [con-lb con-kv "role" role con-cm con-kv "content" txt con-rb]
]

con-write-body: func [orders [string!] user [string!] max [integer!] /local body][
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
    body
]

con-parse-reply: func [/local doc out got reason][
    out: ""
    doc: try [load/as CON-F-REPLY 'json]
    either error? doc [
        con-say rejoin ["mouth-reply-unreadable " mold doc]
        out: ""
    ][
        reason: try [to string! doc/choices/1/finish_reason]
        either error? reason [
            con-say rejoin ["mouth-reply-shapeless " mold reason]
            out: ""
        ][
            either (reason <> "stop") [
                con-say rejoin ["mouth-truncated finish_reason=" reason]
                out: ""
            ][
                got: try [copy/part to string! doc/choices/1/message/content length? doc/choices/1/message/content]
                either error? got [
                    con-say rejoin ["mouth-reply-empty " mold got]
                    out: ""
                ][
                    out: con-think-strip got
                ]
            ]
        ]
    ]
    out
]

; ── the mouth thinks out loud. Qwen reasons inside <think> tags and
; the whole thinking used to go out as the diffusion prompt (measured:
; a Citroen painted from chain-of-thought). Strip every pair; an
; unclosed tag means the rest is thinking, so it all goes; trim the
; stray spaces so an empty answer reads empty and the fallbacks fire.
con-think-strip: func [s [string!] /local out a b tail][
    out: copy s
    while [(find out "<think>")][
        a: find out "<think>"
        b: find a "</think>"
        either (b = none) [
            out: copy/part out ((index? a) - 1)
        ][
            tail: copy skip b 8
            out: rejoin [copy/part out ((index? a) - 1) tail]
        ]
    ]
    ; newlines become spaces before the trims, or an emptied answer
    ; hides behind them and the fallbacks never fire.
    while [(find out "^/")][out: replace out "^/" " "]
    while [(length? out) > 0][
        either ((pick out 1) = #" ") [out: copy skip out 1][break]
    ]
    while [(length? out) > 0][
        either ((pick out length? out) = #" ") [out: copy/part out subtract length? out 1][break]
    ]
    out
]

; THE ONE EXTERNAL CALL. `/output` and `/error` are documented and inert
; in this build; give the SHELL the redirect. Hazard 22.
con-ask: func [orders [string!] user [string!] max [integer!] /local body rc out c][
    out: ""
    body: con-write-body orders user max
    c: rejoin [
        "curl -sS -X POST -H 'Content-Type: application/json' "
        "-d @" CON-F-BODY " "
        to string! CON-LLM-URL " > " CON-F-REPLY " 2>&1"
    ]
    rc: try [call/wait/shell c]
    either error? rc [
        con-say rejoin ["mouth-call-failed " mold rc]
        out: ""
    ][
        either (rc = 0) [
            con-say rejoin ["mouth-bytes " mold length? read CON-F-REPLY]
            out: con-parse-reply
        ][
            con-say rejoin ["mouth-refused rc " mold rc]
            out: ""
        ]
    ]
    out
]

con-flatten: func [s [string!] /local out][
    out: copy s
    out: replace out "^/" " "
    out: replace out con-dq ""
    out: replace out to string! forge-esc ""
    while [(find out "  ")][out: replace out "  " " "]
    either (length? out) > 300 [copy/part out 300][out]
]

; ── the mortal's own prompt, styled. wish + suffix, flattened. pure:
; no IO, no spawn, so a rite can seal it without a GPU.
con-compose: func [wish [string!] si [integer!] /local out][
    out: con-flatten rejoin [con-hand-prefix CON-HAND wish con-style-suffix si]
    out
]

; ── STEPS AND CFG ARE PASSED EXPLICITLY. sd-cli's defaults are wrong
; for this model. sd-turbo is DISTILLED and GUIDANCE-FREE: 4 steps,
; cfg 1.0. cfg 0 is unconditioned and the picture ignores the prompt.
; Hazard 38.
con-hand-cmd: func [/local out][
    out: rejoin [
        "LD_LIBRARY_PATH=" con-quote CON-SD-LIB " "
        con-quote CON-SD " "
        "-m " con-quote con-hand-file CON-HAND " "
        "-p " con-quote con-prompt " "
        "-W " to string! CON-W " -H " to string! CON-H " "
        "--steps " to string! CON-STEPS " "
        "--cfg-scale " to string! CON-CFG " "
        ; ── THE SEED IS RANDOM. sd-cli defaults to 42, so every wish
        ; painted the same picture twice. Negative means random.
        "--seed -1 "
        "-o " con-quote to string! CON-F-IMG " "
        "> " con-quote to string! CON-F-LOG ".cmd" " 2>&1"
    ]
    out
]

; ── async door. call without /wait returns a PID (hazard 23). the
; shell writes the exit code to CON-F-RC when it finishes, and the
; TUI's rate facet polls that file. never /wait the long commands
; from a window, or the flame freezes and the user thinks it hung.
con-spawn: func [cmd [string!] /local pid out][
    out: 0
    call/wait/shell rejoin ["rm -f " to string! CON-F-RC]
    CON-T0: to integer! now/time
    pid: try [call/shell rejoin ["(" cmd "); echo $? > " to string! CON-F-RC]]
    either error? pid [
        con-say rejoin ["spawn-failed " mold pid]
        write CON-F-RC "1"
        out: 0
    ][
        con-say rejoin ["spawned pid " mold pid]
        out: pid
    ]
    out
]

; pure, so a rite can seal it: fresh spawn repels 100, outlives 667.
con-timed-out?: func [now [integer!] /local out][
    out: (now - CON-T0) > CON-TIMEOUT
    out
]

con-ready?: func [/local raw out][
    out: "no"
    if exists? CON-F-RC [
        raw: try [read CON-F-RC]
        if (not error? raw) [
            if (length? raw) > 0 [out: "yes"]
        ]
    ]
    out
]

con-read-rc: func [/local raw out n][
    out: 1
    raw: try [read CON-F-RC]
    either error? raw [
        out: 1
    ][
        while [(find raw "^/")] [
            raw: copy/part raw subtract length? raw 1
        ]
        n: try [to integer! raw]
        either error? n [out: 1][out: n]
    ]
    out
]

con-next-flame: func [cur [string!] /local fi out][
    out: pick CON-FLAMES 1
    fi: find CON-FLAMES cur
    either (fi = none) [
        out: pick CON-FLAMES 1
    ][
        fi: index? fi
        out: pick CON-FLAMES either (fi = length? CON-FLAMES) [1][fi + 1]
    ]
    out
]

con-kind: func [s [string!] /local out][
    out: "busy"
    if (s = "ok") [out: "ok"]
    if (s = "idle") [out: "idle"]
    if find s "fail:" [out: "fail"]
    out
]

con-busy-msg: func [/local out][
    out: "the imp is thinking..."
    if (CON-PHASE = "mouth-art") [out: "the mouth is writing the prompt..."]
    if (CON-PHASE = "hand") [out: "the hand is painting..."]
    if (CON-PHASE = "mouth-mock") [out: "the dragon is watching..."]
    out
]

con-trim-nl: func [s [string!] /local out][
    out: copy s
    while [(find out "^/")] [
        out: copy/part out subtract length? out 1
    ]
    out
]

; ── the frame. assembled here, not at top level: the old "functions
;    return a one-character corpse" claim was a misdiagnosis of hazard
;    15 (a function ending on a false `if`). rejoin still takes ONE
;    argument — interleave the newlines, then rejoin once. hazard 11.
con-forge-frame: func [/local out][
    out: "fail: the forge spat it out."
    con-art: try [
        forge-braille-otsu con-img CON-W CON-H to integer! pick CON-INK 1 to integer! pick CON-INK 2 to integer! pick CON-INK 3 to integer! pick CON-VOID 1 to integer! pick CON-VOID 2 to integer! pick CON-VOID 3
    ]
    either error? con-art [
        con-say rejoin ["forge-failed " mold con-art]
        out: "fail: the forge spat it out."
    ][
        con-say rejoin ["forged " mold length? con-art]
        write CON-F-ART con-art
        con-grid: try [reap con-art 'unicode CON-COLS CON-ROWS]
        con-frame: copy ""
        either error? con-grid [
            con-say rejoin ["reap-failed " mold con-grid]
            out: "fail: the grid would not lie down."
        ][
            con-say rejoin ["grid " mold length? con-grid]
            con-gutter: subtract IMP-WIDTH 4
            ; ── the frame, as data. The spec below is the story; the
            ; dialect (frame-rows) is the teller. Reorder a divider, add
            ; a row, change a colour — here, and nowhere else.
            con-spec: copy []
            append/only con-spec reduce ['border "Imp" IMP-WIDTH]
            append/only con-spec reduce ['lanes con-grid CON-ROWS con-gutter]
            append/only con-spec reduce ['divider "Conjured" IMP-WIDTH]
            append/only con-spec reduce ['row rejoin ["> " con-wish] IMP-WIDTH SILVER]
            either (length? con-mock) = 0 [
                append/only con-spec reduce ['row "the dragon declined to comment." IMP-WIDTH MUTE]
            ][
                append/only con-spec reduce ['row con-mock IMP-WIDTH ROSE]
            ]
            append/only con-spec reduce ['divider "Provenance" IMP-WIDTH]
            append/only con-spec reduce ['row rejoin ["mouth: " CON-LLM] IMP-WIDTH MUTE]
            append/only con-spec reduce ['row rejoin ["style: " CON-STYLE-NAME] IMP-WIDTH MUTE]
            append/only con-spec reduce ['row rejoin ["enhance: " CON-ENH] IMP-WIDTH MUTE]
            append/only con-spec reduce ['row rejoin [
                "hand:  " CON-HAND-NAME " " to string! CON-W "x" to string! CON-H
                " " to string! CON-STEPS "sp cfg" to string! CON-CFG
            ] IMP-WIDTH MUTE]
            append/only con-spec reduce ['row "forged in red. no C, no python." IMP-WIDTH MUTE]
            append/only con-spec reduce ['footer IMP-WIDTH]
            con-frame: frame-assemble frame-rows con-spec
            write CON-F-TMP con-frame
            con-say rejoin ["frame-bytes " mold length? con-frame]
            rename %/dev/shm/imp/frame.tmp %/dev/shm/imp/frame
            con-say "DONE"
            CON-PIC: con-img
            out: "ok"
        ]
    ]
    out
]

con-ask-start: func [orders [string!] user [string!] max [integer!] /local body c][
    body: con-write-body orders user max
    c: rejoin [
        "curl -sS -X POST -H 'Content-Type: application/json' "
        "-d @" CON-F-BODY " "
        to string! CON-LLM-URL " > " CON-F-REPLY " 2>&1"
    ]
    con-spawn c
]

; ── wish rewrite. Same async door as a conjure (one rc file, one
; flight at a time — the TUI guards both directions), but the answer
; lands in the wish box, not the hand. Returns at once; the poller
; collects. "ok:<text>" carries the sentence, "fail:" the truth.
con-rewrite-start: func [wish [string!] si [integer!] hi [integer!] /local out orders entry trimmed][
    out: "fail: speak a wish first."
    trimmed: try [copy wish]
    either error? trimmed [
        out: "fail: speak a wish first."
    ][
        either (trimmed = none) [
            out: "fail: speak a wish first."
        ][
            trimmed: con-trim-nl trimmed
            either (length? trimmed) = 0 [
                out: "fail: speak a wish first."
            ][
                either (si = none) [si: 1][
                    either ((si < 1) or (si > length? CON-STYLES)) [si: 1][]
                ]
                either (hi = none) [hi: 1][
                    either ((hi < 1) or (hi > length? CON-HANDS)) [hi: 1][]
                ]
                entry: con-style-entry si
                orders: rejoin [
                    "You rewrite image prompts. Given a mortal's wish, return ONE improved prompt in this style: "
                    pick entry 2
                    " " con-hand-brief hi
                    ". Under 200 characters. No quotation marks, no preamble, just the prompt. /no_think"
                ]
                con-ask-start orders trimmed 120
                out: "the mouth is rewriting..."
            ]
        ]
    ]
    out
]

; ── rewrite poll. Mirrors con-tick, including the deadline: a mouth
; that never answers is a silence, not a wait.
con-rewrite-tick: func [/local out rc raw dt][
    out: "busy"
    either ((con-ready?) = "yes") [
        rc: con-read-rc
        call/wait/shell rejoin ["rm -f " to string! CON-F-RC]
        either (rc = 0) [
            raw: con-parse-reply
            either (length? raw) = 0 [
                out: "fail: the mouth said nothing."
            ][
                out: rejoin ["ok:" con-flatten raw]
            ]
        ][
            out: "fail: the mouth refused."
        ]
    ][
        dt: to integer! now/time
        either (con-timed-out? dt) [
            con-say "timeout phase=mouth-rewrite"
            out: "fail: the mouth fell silent."
        ][
            out: "the mouth is rewriting..."
        ]
    ]
    out
]

con-advance-mouth-art: func [rc [integer!] /local out raw][
    out: "the hand is painting..."
    raw: con-parse-reply
    either (length? raw) = 0 [
        con-say "the mouth said nothing. using a plain prompt."
        con-prompt: con-compose con-wish CON-STYLE
    ][
        ; the mouth writes; the style still applies, in the hand's own
        ; tongue. enhance chooses who writes, never whether style holds.
        con-prompt: con-flatten rejoin [con-hand-prefix CON-HAND raw con-style-suffix CON-STYLE]
    ]
    write CON-F-PROMPT con-prompt
    con-say rejoin ["prompt " mold con-prompt]
    con-cmd: con-hand-cmd
    write CON-F-CMD con-cmd
    con-say "the hand is called"
    CON-PHASE: "hand"
    con-spawn con-cmd
    out: "the hand is painting..."
    out
]

con-advance-hand: func [rc [integer!] /local out][
    out: "fail: the hand refused to paint."
    either (rc = 0) [
        either exists? CON-F-IMG [
            con-say rejoin ["png-bytes " mold length? read/binary CON-F-IMG]
            con-img: try [load/as CON-F-IMG 'png]
            either error? con-img [
                con-say rejoin ["decode-failed " mold con-img]
                CON-PHASE: "idle"
                out: "fail: the picture would not open."
            ][
                con-say rejoin ["decoded " mold con-img/size]
                con-say "the mouth is asked for a comment"
                CON-PHASE: "mouth-mock"
                con-ask-start CON-LLM-SYS-MOCK rejoin ["A mortal wished for: " con-prompt] 40
                out: "the dragon is watching..."
            ]
        ][
            con-say "no picture. the hand promised and did not deliver."
            CON-PHASE: "idle"
            out: "fail: the hand promised a picture and delivered none."
        ]
    ][
        con-say rejoin ["the hand refused, rc " mold rc]
        CON-PHASE: "idle"
        out: "fail: the hand refused to paint."
    ]
    out
]

con-advance-mock: func [rc [integer!] /local out raw][
    raw: con-parse-reply
    either (length? raw) = 0 [
        con-say "the mouth offered no mockery. the frame will say so."
        con-mock: ""
    ][
        con-mock: con-flatten raw
    ]
    write CON-F-MOCK con-mock
    con-say rejoin ["mockery " mold con-mock]
    CON-PHASE: "idle"
    out: con-forge-frame
    out
]

; sequential `if CON-PHASE = ...` would fall through: mouth-art sets
; the phase to hand, then the next if would fire in the same tick and
; try to finish a hand that has only just been spawned. either, nested.
con-advance: func [rc [integer!] /local out][
    out: "fail: the imp lost its place."
    either (CON-PHASE = "mouth-art") [
        out: con-advance-mouth-art rc
    ][
        either (CON-PHASE = "hand") [
            out: con-advance-hand rc
        ][
            either (CON-PHASE = "mouth-mock") [
                out: con-advance-mock rc
            ][
                CON-PHASE: "idle"
                out: "fail: the imp lost its place."
            ]
        ]
    ]
    out
]

con-begin: func [wish sz si enh hi /local out trimmed n orders][
    out: "fail: speak a wish first."
    trimmed: try [copy wish]
    either error? trimmed [
        out: "fail: speak a wish first."
    ][
        either (trimmed = none) [
            out: "fail: speak a wish first."
        ][
            trimmed: con-trim-nl trimmed
            either (length? trimmed) = 0 [
                out: "fail: speak a wish first."
            ][
                n: try [to integer! sz]
                either error? n [
                    n: CON-W
                ][
                    CON-W: n
                    CON-H: n
                ]
                either (si = none) [si: 1][
                    either ((si < 1) or (si > length? CON-STYLES)) [si: 1][]
                ]
                CON-STYLE: si
                either (enh = "off") [CON-ENH: "off"][CON-ENH: "on"]
                CON-STYLE-NAME: con-get-style-name si
                either (hi = none) [hi: 1][
                    either ((hi < 1) or (hi > length? CON-HANDS)) [hi: 1][]
                ]
                CON-HAND: hi
                CON-HAND-NAME: con-get-hand-name hi
                con-say rejoin ["hand " mold CON-HAND-NAME]
                either ((length? con-hand-file hi) = 0) [
                    con-say "no such hand installed."
                    out: "fail: that hand is not installed."
                ][
                    either exists? to file! con-hand-file hi [
                    con-wish: trimmed
                    write CON-F-JOB con-wish
                    con-ledger: copy []
                    con-say "OPENED"
                    con-say rejoin ["wish " mold con-wish]
                    con-say rejoin ["style " mold CON-STYLE-NAME " enhance " mold CON-ENH]
                    either (CON-ENH = "off") [
                        ; the mortal's own words, styled, straight to the hand.
                        ; no mouth in this path at all.
                        con-prompt: con-compose con-wish si
                        write CON-F-PROMPT con-prompt
                        con-say rejoin ["prompt " mold con-prompt]
                        con-cmd: con-hand-cmd
                        write CON-F-CMD con-cmd
                        con-say "the hand is called"
                        CON-PHASE: "hand"
                        con-spawn con-cmd
                        out: "the hand is painting..."
                    ][
                        orders: rejoin [CON-LLM-SYS-ART " Paint it in this style: " con-style-directive si " " con-hand-brief CON-HAND]
                        CON-PHASE: "mouth-art"
                        con-say "the mouth is asked what to paint"
                        con-ask-start orders con-wish 160
                        out: "the mouth is writing the prompt..."
                    ]
                    ][
                        con-say "no such hand installed."
                        out: "fail: that hand is not installed."
                    ]
                ]
            ]
        ]
    ]
    out
]

con-tick: func [/local out rc dt][
    out: "idle"
    either (CON-PHASE = "idle") [
        out: "idle"
    ][
        either ((con-ready?) = "yes") [
            rc: con-read-rc
            call/wait/shell rejoin ["rm -f " to string! CON-F-RC]
            out: con-advance rc
        ][
            ; a spawn that never reports is dead, not slow. say which
            ; voice fell silent, go idle, let the window show the fail.
            dt: to integer! now/time
            either (con-timed-out? dt) [
                con-say rejoin ["timeout phase=" CON-PHASE]
                CON-PHASE: "idle"
                out: "fail: the hand fell silent."
                if (con-busy-msg = "the mouth is writing the prompt...") [out: "fail: the mouth fell silent."]
                if (con-busy-msg = "the dragon is watching...") [out: "fail: the dragon fell silent."]
            ][
                out: con-busy-msg
            ]
        ]
    ]
    out
]

; ── the blocking door. `imp "a wish"` walks this. never quit; the
;    wrapper quits on a fail: so red-view does not sit forever, and
;    does not quit on ok, because the launcher waits on the frame.
con-run-mock-and-forge: func [/local out][
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
    out: con-forge-frame
    out
]

con-run-after-hand: func [/local out][
    out: "fail: the hand promised a picture and delivered none."
    either exists? CON-F-IMG [
        con-say rejoin ["png-bytes " mold length? read/binary CON-F-IMG]
        con-img: try [load/as CON-F-IMG 'png]
        either error? con-img [
            con-say rejoin ["decode-failed " mold con-img]
            out: "fail: the picture would not open."
        ][
            con-say rejoin ["decoded " mold con-img/size]
            out: con-run-mock-and-forge
        ]
    ][
        con-say "no picture. the hand promised and did not deliver."
        out: "fail: the hand promised a picture and delivered none."
    ]
    out
]

con-run-paint: func [/local out rc][
    out: "fail: the hand refused to paint."
    con-say "the mouth is asked what to paint"
    con-prompt-raw: con-ask rejoin [CON-LLM-SYS-ART " " con-hand-brief CON-HAND] con-wish 160
    con-prompt: either (length? con-prompt-raw) = 0 [
        con-say "the mouth said nothing. using a plain prompt."
        con-compose con-wish CON-STYLE
    ][
        con-flatten rejoin [con-prompt-raw con-style-suffix CON-STYLE]
    ]
    write CON-F-PROMPT con-prompt
    con-say rejoin ["prompt " mold con-prompt]
    con-cmd: con-hand-cmd
    write CON-F-CMD con-cmd
    con-say "the hand is called"
    rc: try [call/wait/shell con-cmd]
    either error? rc [
        con-say rejoin ["sd-call-failed " mold rc]
        out: "fail: the hand refused to paint."
    ][
        either (rc = 0) [
            con-say "the hand answered"
            out: con-run-after-hand
        ][
            con-say rejoin ["the hand refused, rc " mold rc]
            out: "fail: the hand refused to paint."
        ]
    ]
    out
]

con-run: func [/local out][
    out: "fail: no job. the imp was not asked anything."
    con-wish: try [read CON-F-JOB]
    either error? con-wish [
        con-say "no job. the imp was not asked anything."
        out: "fail: no job. the imp was not asked anything."
    ][
        con-wish: copy con-wish
        con-wish: con-trim-nl con-wish
        con-say rejoin ["wish " mold con-wish]
        out: con-run-paint
    ]
    out
]
