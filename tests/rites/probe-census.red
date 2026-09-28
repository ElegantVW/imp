;-- probe-census.red — safe surface census of the live Red 0.6.6 console.
;-- Every question is wrapped in try/all so one bad answer cannot kill
;-- the testimony. Existence is probed INDIRECTLY (lit-words only) so that
;-- a missing word can never be a compile error.
;-- The oracle writes probe-census.txt.

out: make string! 0

q: func [label [string!] blk [block!]][
	s: none
	r: none
	r: try/all blk
	s: either error? r [
		rejoin ["<ERR " mold r/type " / " mold r/id ">"]
	][
		either none = r ["none!"] [mold r]
	]
	append out rejoin [label s newline]
]

;-- Existence test that cannot blow up: is the word a member of the
;-- system context? A lit-word is inert data, never a reference.
h: func [w [word!]][all [find words-of :system w][true]]

;-- 1. Identity ---------------------------------------------------------
q "system/version           :" [mold system/version]
q "system/product          :" [mold system/product]
q "system/build-date       :" [mold system/build-date]
q "type? system            :" [mold type? system]
q "system/platform         :" [mold system/platform]
q "length? words-of :system:" [mold length? words-of :system]

;-- 2. Presence census (the imp "absent words" list, re-verified) -------
q "has? join                :" [mold h 'join]
q "has? and                 :" [mold h 'and]
q "has? or                  :" [mold h 'or]
q "has? none?               :" [mold h 'none?]
q "has? first               :" [mold h 'first]
q "has? last                :" [mold h 'last]
q "has? third               :" [mold h 'third]
q "has? infix?              :" [mold h 'infix?]
q "has? enforce             :" [mold h 'enforce]
q "has? cond                :" [mold h 'cond]
q "has? unless              :" [mold h 'unless]
q "has? while               :" [mold h 'while]
q "has? forever             :" [mold h 'forever]
q "has? loop                :" [mold h 'loop]
q "has? repeat              :" [mold h 'repeat]
q "has? switch              :" [mold h 'switch]
q "has? case                :" [mold h 'case]
q "has? function            :" [mold h 'function]
q "has? remove-each         :" [mold h 'remove-each]
q "has? random              :" [mold h 'random]
q "has? now                 :" [mold h 'now]
q "has? checksum            :" [mold h 'checksum]
q "has? wait                :" [mold h 'wait]
q "has? halt                :" [mold h 'halt]
q "has? transcode           :" [mold h 'transcode]
q "has? math                :" [mold h 'math]
q "has? sleep               :" [mold h 'sleep]
q "has? exit                :" [mold h 'exit]

;-- 3. PRECEDENCE — the central question -------------------------------
;-- Operands parenthesised so we test the OPERATOR, not the call.
q "1 + 2 * 3                :" [mold (1 + 2 * 3)]
q "2 + 3 * 4                :" [mold (2 + 3 * 4)]
q "2 * 3 + 1                :" [mold (2 * 3 + 1)]
q "1 + 2 ** 3               :" [mold (1 + 2 ** 3)]
q "2 ** 3 ** 2              :" [mold (2 ** 3 ** 2)]
q "10 - 2 - 3               :" [mold (10 - 2 - 3)]
q "100 / 10 / 2             :" [mold (100 / 10 / 2)]
q "(1 + 2) * 3              :" [mold ((1 + 2) * 3)]
q "math [1 + 2 * 3]         :" [mold math [1 + 2 * 3]]
q "math [2 ** 3 ** 2]       :" [mold math [2 ** 3 ** 2]]

;-- 4. Comparison ops ---------------------------------------------------
q "1 = 1                    :" [mold (1 = 1)]
q "1 == 1.0                 :" [mold (1 == 1.0)]
q "= 1 (fn form)            :" [mold (= 1)]
q "same? [1] [1]            :" [mold same? [1] [1]]
q "= [1 [2]] [1 [2]]        :" [mold (= [1 [2]] [1 [2]])]
q "== [1 [2]] [1 [2]]       :" [mold (== [1 [2]] [1 [2]])]
q "1 <> 2                   :" [mold (1 <> 2)]
q "1 < 2                    :" [mold (1 < 2)]
q "1 <= 1                   :" [mold (1 <= 1)]
q "1 > 2                    :" [mold (1 > 2)]
q "1 >= 1                   :" [mold (1 >= 1)]
q "1 ~ 1                    :" [mold (1 ~ 1)]
q "mold 1 ~ 1 (issue)       :" [mold (1 ~ 1)]

;-- 5. none semantics ---------------------------------------------------
q "none = none              :" [mold (none = none)]
q "none = false             :" [mold (none = false)]
q "none = 0                 :" [mold (none = 0)]
q "false = 0                :" [mold (false = 0)]
q "if none [1]              :" [mold (if none [1])]
q "if false [1]             :" [mold (if false [1])]
q "if true [1]              :" [mold (if true [1])]
q "if 0 [1]                 :" [mold (if 0 [1])]
q "if empty-str [1]         :" [mold (if "" [1])]
q "not none                 :" [mold (not none)]
q "none - 1                 :" [mold (none - 1)]
q "1 + none                 :" [mold (1 + none)]
q "none + 1                 :" [mold (none + 1)]
q "any [none none]          :" [mold (any [none none])]
q "all [none none]          :" [mold (all [none none])]
q "all [true none]          :" [mold (all [true none])]
q "any []                   :" [mold (any [])]
q "all []                   :" [mold (all [])]
q "any [1 = 2 3]            :" [mold (any [1 = 2 3])]
q "either true [1] [2]      :" [mold (either true [1] [2])]
q "either false [1] [2]     :" [mold (either false [1] [2])]
q "unless false [1]         :" [mold (unless false [1])]
q "switch 2 [1 [10] 2 [20]] :" [mold (switch 2 [1 [10] 2 [20]])]
q "switch 9 [1 [10]]        :" [mold (switch 9 [1 [10]])]
q "switch 9 [1 [10]] /def   :" [mold (switch 9 [1 [10]] /default [99])]
q "case [false [1] true [2]]:" [mold (case [false [1] true [2]])]

;-- 6. try / error ------------------------------------------------------
q "try [1 + 2]              :" [mold try [1 + 2]]
q "try [1 + 2 + 3]          :" [mold try [1 + 2 + 3]]
q "try [1 + 2 * 3]          :" [mold try [1 + 2 * 3]]
q "try [1 / 0]              :" [mold try [1 / 0]]
q "try [1 + ""a""]           :" [mold try [1 + "a"]]
q "error? try [1 + ""a""]    :" [mold error? try [1 + "a"]]
q "type? try/keep [1 / 0]   :" [mold type? try/keep [1 / 0]]
q "error? try [none/x]       :" [mold error? try [none/x]]
q "type? try [1 / 0]         :" [mold type? try [1 / 0]]

;-- 7. parse — the excommunicated PEG ----------------------------------
q "parse blk-rule           :" [mold (parse "abc" ["a" "b" "c"])]
q "type? parse blk-rule     :" [mold type? (parse "abc" ["a" "b" "c"])]
q "parse str-rule           :" [mold (parse "abc" [some "a" thru "c"])]
q "parse str-rule + tail?   :" [mold (parse "abc" [some "a" "c"] tail?)]
q "parse blk-rule + tail?   :" [mold (parse "abc" ["a" "b" "c"] tail?)]
q "block? parse str-rule    :" [mold block? (parse "abc" [some "a" thru "c"])]
q "parse fail (false)       :" [mold (parse "abc" ["z"])]

;-- 8. maps: #[] is map!, #() is construct -----------------------------
q "mold #[a 1 b 2]          :" [mold #[a 1 b 2]]
q "form #[a 1 b 2]         :" [mold form #[a 1 b 2]]
q "make map! 10             :" [mold make map! 10]
q "make map! [a 1]          :" [mold make map! [a 1]]
q "make object! [a: 1]      :" [mold make object! [a: 1]]
q "mold #(integer!)         :" [mold #(integer!)]
q "mold #(true)             :" [mold #(true)]
q "construct {a: 1 b: 2}    :" [mold construct {a: 1 b: 2}]
q "select #[a 1] a          :" [mold select #[a 1] 'a]
q "words-of make object!    :" [mold words-of make object! [a: 1 b: 2]]

;-- 9. series / string / char ------------------------------------------
q "length? CJK 2-glyph      :" [mold length? "樯樯"]
q "third CJK (byte walk)    :" [mold third "樯"]
q "find ""ab"" ""b""         :" [mold find "ab" "b"]
q "copy/part CJK 1          :" [mold copy/part "樯樯" 1]
q "index? find ""ab"" ""b""  :" [mold index? find "ab" "b"]
q "length? char! (error?)   :" [mold length? #"a"]
q "3rd ""abc"" (byte)        :" [mold 3rd "abc"]
q "copy/part ""abc"" 2      :" [mold copy/part "abc" 2]
q "mold copy [1 2 3]        :" [mold copy [1 2 3]]
q "mold to-block ""abc""    :" [mold to-block "abc"]
q "mold append/part         :" [mold append/part [1 2 3] "xy" 2]
q "mold head/tail/next      :" [mold reduce [head [1 2] tail [1 2]]]

;-- 10. file append — horror 7 -----------------------------------------
write %probe-a.txt "start"
append %probe-a.txt "MORE"
q "append %file then read   :" [mold read %probe-a.txt]
q "write/append then read   :" [mold does [write/append %probe-a.txt "W" read %probe-a.txt]]
q "exists? %probe-a.txt     :" [mold exists? %probe-a.txt]
q "write whole then read    :" [mold does [write %probe-a.txt "Z" read %probe-a.txt]]

;-- 11. literals / scalar forms ----------------------------------------
q "mold $12                 :" [mold $12]
q "mold +USD100             :" [mold +USD100]
q "mold 12:30:15.5          :" [mold 12:30:15.5]
q "mold 2018-01-31          :" [mold 2018-01-31]
q "mold 1x2                 :" [mold 1x2]
q "mold (1,2)               :" [mold (1,2)]
q "mold 1.2.3               :" [mold 1.2.3]
q "mold 50%                 :" [mold 50%]
q "mold 16#{FF}             :" [mold 16#{FF}]
q "mold #{48656C6C6F}       :" [mold #{48656C6C6F}]
q "mold 1e3                 :" [mold 1e3]
q "mold 1'000'000           :" [mold 1'000'000]
q "mold 255.0.0.0           :" [mold 255.0.0.0]
q "mold to-integer 3.99     :" [mold to-integer 3.99]
q "mold round 3.5           :" [mold round 3.5]
q "mold round/even 3.5      :" [mold round/even 3.5]
q "mold 1.0                 :" [mold 1.0]
q "mold .5                  :" [mold .5]
q "mold 1,5 (decimal comma) :" [mold 1,5]

;-- 12. the imp substrate answers --------------------------------------
q "read missing file        :" [mold error? try [read %does-not-exist-xyz]]
q "read a directory         :" [mold error? try [read %/tmp/]]
q "wait 100                 :" [mold error? try [wait 100]]
q "type? now                :" [mold type? now]
q "rename then exists?      :" [mold does [write %probe-c.txt "x" rename %probe-c.txt %probe-d.txt mold exists? %probe-d.txt]]
q "delete then exists?      :" [mold does [delete %probe-d.txt mold exists? %probe-d.txt]]
q "query %probe-a.txt       :" [mold query %probe-a.txt]
q "load a file as red       :" [mold type? load %probe-a.txt]
q "do a missing file        :" [mold error? try [do %no-such-file.red]]

;-- 13. library --------------------------------------------------------
q "mold checksum ""abc""     :" [mold checksum "abc"]
q "mold dehex ""48656C6C6F"" :" [mold dehex "48656C6C6F"]
q "mold enbase 255 16       :" [mold enbase 255 16]
q "mold debase 16 {FF}      :" [mold debase 16 {FF}]
q "mold as-bin ""abc""      :" [mold as-bin "abc"]
q "mold form ""abc""        :" [mold form "abc"]
q "mold mold [a ""b""]       :" [mold mold [a "b"]]
q "mold form [a ""b""]      :" [mold form [a "b"]]
q "mold reduce [1 + 2 3 * 4]:" [mold reduce [1 + 2 3 * 4]]

write %probe-census.txt out
halt
