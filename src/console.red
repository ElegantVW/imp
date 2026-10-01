Red [Title: "imp-console"]
; IMP-CONSOLE — the one-shot door, compiled.
;
; A BUILD FRAGMENT, not a program: build.sh concats core, frame, forge
; and conjure-lib (headers and `do` lines stripped) above this file
; and compiles the whole. Never `do` this file; it has no library.
;
; argv in, frame out on stdout, real exit codes. No launcher wait-loop,
; no staged files, no frame polling. The env file is ensured here
; (fresh boot leaves tmpfs empty); a launcher-written one wins by
; existing first. Machine paths are hardcoded — this box is the only
; target, and the rites assume it too.
;
; The tty prompt and the covenant checks are NOT argv's business —
; this binary is the whole one-shot flow. argv: a wish paints it; no
; args asks the terminal (fd 0) and paints what arrives.
;
; ── syscalls, via libc. #import is the GPIO pattern; routines give
; Red words for fd 1 (write) and fd 0 (read). Tail-bump idiom is
; Red's own CLI input path. print/read stay for interpreted use;
; the binary talks fds directly, byte-exact, no added newlines.

#system [
    #import [
        LIBC-file cdecl [
            con-sys-write: "write" [
                fd      [integer!]
                buf     [byte-ptr!]
                count   [integer!]
                return: [integer!]
            ]
            con-sys-read: "read" [
                fd      [integer!]
                buf     [byte-ptr!]
                count   [integer!]
                return: [integer!]
            ]
        ]
    ]
]

con-fd-write: routine [fd [integer!] b [binary!] return: [integer!] /local n][
    n: con-sys-write fd binary/rs-head b binary/rs-length? b
    return n
]
; Red-level door: strings in, bytes out. fd 1 is the frame and the
; prompt; fd 2 is every error (the exit code carries failure too).
con-emit: func [fd [integer!] s [string!] /local out][
    out: con-fd-write fd to binary! s
    out
]
con-readline: routine [b [binary!] max [integer!] return: [integer!] /local n s][
    n: con-sys-read 0 binary/rs-head b max
    if n > 0 [
        s: GET_BUFFER(b)
        s/tail: as cell! (as byte-ptr! s/tail) + n
    ]
    return n
]

IMP-SHM: %/dev/shm/imp/
IMP-F-ENV: %/dev/shm/imp/imp-env.txt
IMP-SD: "/home/evenweaker/.local/lib/sd/sd-cli"
IMP-SD-LIB: "/home/evenweaker/.local/lib/sd"
IMP-MODEL: "/home/evenweaker/.local/share/pixie/models/sd_turbo-f16.gguf"
IMP-LLM-URL: "http://127.0.0.1:8082/v1/chat/completions"

; ── cross-function globals, pre-declared for the compiler. The
; interpreter creates these on first assignment inside a func body;
; the compiler wants them bound up front. Values mirror first use.
; This block runs nowhere meaningful (the pipeline rebinds all of
; it); it exists so `redc` stops asking where the words live.
con-img: none
con-art: ""
con-grid: ""
con-frame: ""
con-panel: copy []
con-lanes: copy []
con-filler: ""
con-gutter: 0
con-i: 0
con-parts: copy []
con-pk: 0
con-pn: 0
con-cmd: ""
con-mock: ""
con-mock-raw: ""
con-prompt: ""
con-prompt-raw: ""
con-ei: 0
con-entry: copy []
con-spec: copy []

; the runtime wraps every argv element in single quotes AND escapes
; embedded quotes Bourne-style, so the args arrive as one string with
; backslashes in it. Reproduce the shell star-expansion exactly: fold
; escaped quotes, strip edge quotes per word, skip empties, join with
; single spaces. Mid-word apostrophes survive — only wrapping and
; escaping go. Both special chars are built from codes, never typed.
con-sq: to char! 39
con-bs: to char! 92
con-unquote: func [s [string!] /local out][
    out: copy s
    if ((length? out) > 0) [
        if ((pick out 1) = con-sq) [out: copy skip out 1]
    ]
    if ((length? out) > 0) [
        if ((pick out length? out) = con-sq) [out: copy/part out subtract length? out 1]
    ]
    out
]
; embedded quotes arrive Bourne-escaped (close, backslash, reopen),
; so a wish with an apostrophe would paint backslashes. Fold them.
con-unescape: func [s [string!] /local out needle sub][
    out: copy s
    needle: rejoin [con-sq con-bs con-sq con-sq]
    sub: to string! con-sq
    while [(find out needle)][out: replace out needle sub]
    out
]
con-argv-wish: func [raw [string!] /local parts out p seen][
    out: copy ""
    seen: false
    parts: sever raw " "
    foreach p parts [
        p: con-unescape con-unquote p
        if ((length? p) > 0) [
            either seen [append out " "][seen: true]
            append out p
        ]
    ]
    out
]

con-die: func [s [string!] /local out][
    con-emit 2 rejoin ["imp: " s "^/"]
    quit/return 1
    out: 0
    out
]

either exists? IMP-SHM [][
    either error? try [make-dir IMP-SHM] [con-die "the vessel has nowhere to think."][]
]
either exists? IMP-F-ENV [][
    write IMP-F-ENV rejoin [
        "sd=" IMP-SD "^/"
        "sd-lib=" IMP-SD-LIB "^/"
        "model=" IMP-MODEL "^/"
        "w=512" "^/"
        "h=512" "^/"
        "steps=4" "^/"
        "cfg=1" "^/"
        "llm=imp" "^/"
        "llm-url=" IMP-LLM-URL "^/"
    ]
]
; the covenant, checked before anything runs
either (pick IMP-MODEL 1) = #"/" [][con-die "the model path is not absolute"]
either exists? to file! IMP-SD [][con-die "no hand at sd-cli"]
either exists? to file! IMP-MODEL [][con-die "no weights at the model"]

con-wish-raw: system/script/args
either (con-wish-raw = none) [
    con-wish-raw: ""
][
    con-wish-raw: con-argv-wish to string! con-wish-raw
]

; ── selftest. R/S is COMPILE-TIME only: rites run the interpreted
; console where `routine` does not exist, so the syscall path can only
; be sealed by a compiled binary testing itself. This is that seal —
; build.sh selftest redirects stdout to a file and checks the bytes.
either (con-wish-raw = "--selftest") [
    con-emit 1 "SELFTEST-EMIT-OK^/"
    con-emit 2 "SELFTEST-ERR-OK^/"
    quit/return 0
][
]

either (length? con-wish-raw) = 0 [
    ; no args: ask the terminal directly. EOF (no tty, closed pipe)
    ; reads zero bytes — the mortal never spoke, and we say so.
    con-emit 1 rejoin ["^(1B)[38;5;175m" "^(1B)[0m" "imp: what do you wish for? ^C to leave.^/^> "]
    con-wish-buf: make binary! 1024
    con-wish-n: con-readline con-wish-buf 1024
    either (con-wish-n <= 0) [
        con-die "the wish was never spoken."
    ][
        con-wish-raw: con-trim-nl to string! con-wish-buf
    ]
][
    con-wish-raw: con-trim-nl con-wish-raw
]
either (length? con-wish-raw) = 0 [
    con-die "an empty wish conjures nothing."
][
    write %/dev/shm/imp/job con-wish-raw
]

con-out: con-run
either (con-out = "ok") [
    ; byte-exact stdout: the frame, then one newline — what `cat`
    ; plus a printf newline used to emit.
    con-emit 1 read %/dev/shm/imp/frame
    con-emit 1 "^/"
][
    con-die "the vessel accepted the wish and painted nothing."
]
