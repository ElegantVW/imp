Red [Title: "conjure"]
; CONJURE — the one-shot door.
;
; The pipeline lives in src/conjure-lib.red so the TUI can call it
; without this file quitting the window. This wrapper is what
; `imp "a wish"` runs: load the library, run to completion, quit only
; if the pipeline failed (so red-view does not sit forever on an error
; with no frame). Success does not quit: the launcher waits on the
; frame and kills the interpreter itself.
;
; Staged to the repo root by the launcher. `do` then change-dirs into
; src/, which is why the library's own `do %core.red` resolves.

do %src/conjure-lib.red
con-out: con-run
either (con-out = "ok") [
][
    quit
]
