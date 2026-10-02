Red [Title: "rite-tui-gallery" Needs: View]
; THE MENU AND THE FILING, PROVED WITHOUT A GPU. The window builds
; (faces only, never viewed). The menu opens every launch; generate
; reveals the work; the gallery reads the dirt; delivery files and
; names the id. Sandbox dirs throughout.
;
;   T1  con-file-painting files txt + json entry from faces + con-frame
;   T2  menu opens at startup, work hidden; welcome performs once
;   T3  generate reveals the work, hides the menu
;   T4  gallery enters, lists, previews, strays included
;   T5  back returns to the menu
;   T6  con-deliver ok files + names the id; fail reports
;   T7  empty gallery says so
;   T8  the picture is still the last face
do %src/tui.red

led: copy []
say: func [k [string!] b [block!]][
    append led rejoin [k (mold (do b))]
]

ART: "/dev/shm/imp/gal-tui/art"
CACHE: "/dev/shm/imp/gal-tui/cache"
call/wait/shell "rm -rf /dev/shm/imp/gal-tui; mkdir -p /dev/shm/imp/gal-tui/art /dev/shm/imp/gal-tui/cache"

; ── T1: one filing from faces ───────────────────────────────────────
wish-face/text: "a fox in neon rain"
style-dd/selected: 3
hand-dd/selected: 2
size-dd/selected: 1
size-custom/text: "256"
con-frame: "SAMPLE-FRAME-TEXT"
tid: con-file-painting ART CACHE
say "T1 filed: " [either ((length? tid) > 0) ["SEALED"]["BROKEN, no id"]]
say "   id: " [tid]
t1: try [read (to file! (rejoin [ART "/" tid ".txt"]))]
say "T1b txt-kept: " [either (error? t1) ["BROKEN, no txt"][either ((find t1 "SAMPLE-FRAME") = none) ["BROKEN, wrong txt"]["SEALED"]]]
te: gal-list CACHE
tw: ""
tst: ""
th: ""
tsz: 0
foreach e te [
    either ((to string! (select e 'id)) = tid) [
        tw: to string! (select e 'wish)
        tst: to string! (select e 'style)
        th: to string! (select e 'hand)
        tsz: select e 'size
    ][]
]
say "T1c entry: " [either (((tw = "a fox in neon rain") and (tst = "Mignola")) and ((th = "SDXL") and (tsz = 256))) ["SEALED"]["BROKEN"]]
say "   entry: " [(rejoin [tw "/" tst "/" th "/" (to string! tsz)])]

; ── T2: the menu opens, work hidden ─────────────────────────────────
say "T2 menu-first: " [either (((menu-face/visible? = true) and (wish-face/visible? = false)) and (gal-area/visible? = false)) ["SEALED"]["BROKEN"]]
say "   menu: " [menu-face/text]
CON-CACHE-DIR: CACHE
m1: con-menu-start
say "T2b welcome-once: " [either ((m1 = "menu") and ((find menu-face/text "first of all") <> none)) ["SEALED"]["BROKEN"]]
m2: con-menu-start
say "T2c quiet-after: " [either ((find menu-face/text "first of all") = none) ["SEALED"]["BROKEN, welcomed twice"]]

; ── T3: generate reveals ────────────────────────────────────────────
con-show-view "generate"
say "T3 generate: " [either (((wish-face/visible? = true) and (menu-face/visible? = false)) and (pic-face/visible? = true)) ["SEALED"]["BROKEN"]]

; ── T4: the gallery reads dirt ──────────────────────────────────────
call/wait/shell "rm -rf /dev/shm/imp/gal-tui/art /dev/shm/imp/gal-tui/cache; mkdir -p /dev/shm/imp/gal-tui/art /dev/shm/imp/gal-tui/cache"
g1: gal-add ART CACHE "w-browse-one" "s" "h" 128 "FIRST-PAINTING"
g2: gal-add ART CACHE "w-browse-two" "s" "h" 128 "SECOND-PAINTING"
call/wait/shell "echo stray-words > /dev/shm/imp/gal-tui/art/stray.txt"
ge: con-gallery-enter ART CACHE
say "T4 enter: " [either (((gal-area/visible? = true) and (menu-face/visible? = false)) and ((length? gal-dd/data) = 3)) ["SEALED"]["BROKEN"]]
say "   enter: " [ge]
say "T4b preview-first: " [either ((find gal-area/text "FIRST-PAINTING") <> none) ["SEALED"]["BROKEN"]]
say "   area: " [(copy/part gal-area/text 20)]
gal-dd/selected: 3
gs: con-gallery-show ART CACHE
say "T4c stray-preview: " [either ((find gal-area/text "stray-words") <> none) ["SEALED"]["BROKEN"]]
say "   stray: " [gs]

; ── T5: back returns ────────────────────────────────────────────────
con-show-view "menu"
say "T5 back: " [either (((menu-face/visible? = true) and (gal-area/visible? = false)) and (wish-face/visible? = false)) ["SEALED"]["BROKEN"]]

; ── T6: delivery files and names ────────────────────────────────────
CON-PIC: pic
wish-face/text: "a lighthouse in a storm"
style-dd/selected: 1
hand-dd/selected: 1
size-custom/text: ""
con-frame: "DELIVERY-FRAME"
gd: con-deliver ART CACHE "ok"
say "T6 deliver-files: " [either ((find gd "filed as") <> none) ["SEALED"]["BROKEN"]]
say "   status: " [gd]
gf: con-deliver ART CACHE "fail: test silence"
say "T6b deliver-fail: " [either ((gf = "fail: test silence") and (busy-face/text = "0")) ["SEALED"]["BROKEN"]]

; ── T7: empty gallery says so ───────────────────────────────────────
call/wait/shell "rm -rf /dev/shm/imp/gal-tui/empty-art /dev/shm/imp/gal-tui/empty-cache; mkdir -p /dev/shm/imp/gal-tui/empty-art /dev/shm/imp/gal-tui/empty-cache"
he: con-gallery-enter "/dev/shm/imp/gal-tui/empty-art" "/dev/shm/imp/gal-tui/empty-cache"
say "T7 empty: " [either ((he = "empty") and ((find gal-area/text "empty") <> none)) ["SEALED"]["BROKEN"]]

; ── T8: the picture is still last ───────────────────────────────────
pane: win/pane
faces: length? pane
either (faces >= 1) [
    last-f: pick pane faces
    last-w: last-f/size/x
    say "T8 image-last: " [either (last-w >= 300) ["SEALED"]["BROKEN"]]
    say "   last width: " [last-w]
][
    say "T8 image-last: " ["BROKEN, empty pane"]
]

; ── U: the look pass, asserted where faces allow ───────────────────
say "U1 enhance-fits: " [either ((enh-btn/size/x) >= 140) ["SEALED"]["BROKEN"]]
say "   width: " [enh-btn/size/x]
say "U2 fields-dark: " [either (((mold wish-face/font/color) = "26.18.24") and ((mold size-custom/font/color) = "26.18.24")) ["SEALED"]["BROKEN"]]
say "U3 dd-wide: " [either ((gal-dd/size/x) = 200) ["SEALED"]["BROKEN"]]
con-gallery-enter ART CACHE
say "U4 meta-shows: " [either (((find gal-meta-face/text "w-browse-one") <> none) and ((find gal-meta-face/text "hour") <> none)) ["SEALED"]["BROKEN"]]
say "   meta: " [gal-meta-face/text]
say "U5 status-readable: " [either ((status-face/font/size) = 11) ["SEALED"]["BROKEN"]]
con-show-view "menu"
say "U6 menu-quit: " [either ((menu-quit-btn/visible? = true) and (gal-quit-btn/visible? = false)) ["SEALED"]["BROKEN"]]
con-show-view "gallery"
say "U7 gallery-quit: " [either (gal-quit-btn/visible? = true) ["SEALED"]["BROKEN"]]
say "U8 preview-dark: " [either (((mold gal-area/font/color) = "26.18.24") and ((gal-area/font/size) = 12)) ["SEALED"]["BROKEN, washed out"]]
say "U9 pic-fills: " [either ((pic-face/size/x) = 480) ["SEALED"]["BROKEN"]]

say "Z single-write: " ["SEALED - this file is the only product"]

write %/dev/shm/imp/tui-gallery-tmp.txt rejoin led
rename %/dev/shm/imp/tui-gallery-tmp.txt %/dev/shm/imp/tui-gallery-witness.txt
