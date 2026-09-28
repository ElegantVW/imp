;-- probe-manual.red — interrogate the live Red 0.6.6 console.
;-- Every line is a question; the answers become the manual.

R: does [
	out: make string! 0

	;; --- 1. version + build identity -----------------------------------
	ask: make string! 0
	append out rejoin ["system/version     : " mold system/version newline]
	append out rejoin ["system/product    : " mold system/product newline]
	append out rejoin ["type? system      : " mold type? system newline]
	append out rejoin ["system/build      : " mold system/build newline]

	;; --- 2. how many actions / natives do we really have? --------------
	append out newline
	append out rejoin ["actions in system/actions: " mold length? words-of :actions.reds newline]
	append out rejoin ["natives declared           : " mold length? words-of :natives.reds newline]

	;; --- 3. the datatype census -----------------------------------------
	append out newline
	append out rejoin ["type? word!            : " mold type? word! newline]
	append out rejoin ["mold type? integer!   : " mold type? integer! newline]

	;; --- 4. THE PRECEDENCE PROBE ---------------------------------------
	;; 1 + 2 * 3 : if precedence exists -> 7, if left-to-right -> 9
	append out newline
	append out rejoin ["PRECEDENCE 1 + 2 * 3      = " mold 1 + 2 * 3 "   (7 => precedence, 9 => L-to-R)" newline]

	;; 2 * 3 + 1 : precedence -> 7, L-to-R -> 7 (ambiguous) - use 2+3*4
	append out rejoin ["PRECEDENCE 2 + 3 * 4      = " mold 2 + 3 * 4 "   (14 => precedence, 20 => L-to-R)" newline]
	append out rejoin ["PRECEDENCE 1 + 2 ** 3     = " mold 1 + 2 ** 3 "   (9 => precedence, 9 => both)" newline]
	append out rejoin ["PRECEDENCE 2 ** 3 ** 2    = " mold 2 ** 3 ** 2 "   (512 => right-assoc, 64 => left-assoc)" newline]
	append out rejoin ["PRECEDENCE 10 - 2 - 3     = " mold 10 - 2 - 3 "   (5 => L-to-R)" newline]

	;; --- 5. THE if/either HAZARD ---------------------------------------
	;; In Red, does `if cond [a][b]` exist?
	append out newline
	if-trap: does [ask: none]
	append out rejoin ["if-with-2-blocks      : " mold (try [either true [1][2]]) newline]

	;; --- 6. THE PARSE HAZARD -------------------------------------------
	;; parse on a block rule: what does it return?
	append out newline
	append out rejoin ["parse block-rule     : " mold try [parse "abc" ["a" "b" "c"]] newline]
	append out rejoin ["type? parse block     : " mold try [type? parse "abc" ["a" "b" "c"]] newline]
	append out rejoin ["parse string-rule    : " mold try [parse "abc" [some "a" thru "c"]] newline]
	append out rejoin ["parse str tail       : " mold try [parse "abc" [some "a" "c"] tail?] newline]
	append out rejoin ["parse str at pos     : " mold try [parse "abc" [some "a"] "a"] newline]

	;; --- 7. none arithmetic ---------------------------------------------
	append out newline
	append out rejoin ["none - 1             : " mold try [none - 1] newline]
	append out rejoin ["none = none          : " mold try [none = none] newline]
	append out rejoin ["none = false         : " mold try [none = false] newline]
	append out rejoin ["if none []           : " mold try [if none [1]] newline]
	append out rejoin ["if false []          : " mold try [if false [1]] newline]
	append out rejoin ["not none             : " mold try [not none] newline]
	append out rejoin ["1 + none             : " mold try [1 + none] newline]
	append out rejoin ["none + 1             : " mold try [none + 1] newline]

	;; --- 8. try / error? -------------------------------------------------
	append out newline
	append out rejoin ["try 1                : " mold try [1] newline]
	append out rejoin ["try 1+2              : " mold try [1 + 2] newline]
	append out rejoin ["try 1+2+3            : " mold try [1 + 2 + 3] "  (1+2=3 then 3+3=6 => 6, else reduced 6)" newline]
	append out rejoin ["try err then next    : " mold try [1 + "a"] newline]
	append out rejoin ["error? of that      : " mold error? try [1 + "a"] newline]
	append out rejoin ["try/except           : " mold try [1 + "a"] /except e [mold e/id] newline]

	;; --- 9. absent natives ----------------------------------------------
	append out newline
	append out rejoin ["join present?        : " mold does [join ["a" "b"]] newline]
	append out rejoin ["none? present?      : " mold does [none? none] newline]
	append out rejoin ["and present?        : " mold does [and true true] newline]
	append out rejoin ["or  present?        : " mold does [or true false] newline]
	append out rejoin ["length? char!       : " mold does [length? #"a"] newline]
	append out rejoin ["index? none        : " mold does [index? none] newline]
	append out rejoin ["make map!          : " mold does [make map! 10] newline]
	append out rejoin ["make map! [a:1]    : " mold does [make map! [a 1]] newline]
	append out rejoin ["enforce present?    : " mold does [enforce 1 integer!] newline]
	append out rejoin ["unless present?     : " mold does [unless false [1]] newline]

	;; --- 10. file-literal append ---------------------------------------
	append out newline
	write %probe-append.txt "start"
	append %probe-append.txt "MORE"
	append out rejoin ["append %file        : " mold read %probe-append.txt "  <- horror 7" newline]
	append out rejoin ["write/append        : " mold does [write/append %probe-append.txt "W"  read %probe-append.txt] newline]

	;; --- 11. the datatype forms ----------------------------------------
	append out newline
	append out rejoin ["#() vs #[]         : " mold try [#(integer!)] newline]
	append out rejoin ["#[a 1]              : " mold try [#[a 1]] newline]
	append out rejoin ["mold #[a 1]         : " mold try [mold #[a 1]] newline]
	append out rejoin ["construct {a: 1}   : " mold try [construct {a: 1}] newline]
	append out rejoin ["construct 3 blocks  : " mold try [construct [a [1]] [b [2]]] newline]

	;; --- 12. deep compare ----------------------------------------------
	append out newline
	append out rejoin ["= [1 [2]]          : " mold try [= [1 [2]] [1 [2]]] newline]
	append out rejoin ["== [1 [2]]         : " mold try [== [1 [2]] [1 [2]]] newline]
	append out rejoin ["same? [1][1]       : " mold try [same? [1] [1]] newline]

	;; --- 13. function library ------------------------------------------
	append out newline
	append out rejoin ["math [1 + 2 * 3]  : " mold does [math [1 + 2 * 3]] newline]
	append out rejoin ["also/append/head?  : " mold does [length? words-of :append] newline]

	;; --- 14. string/char -----------------------------------------------
	append out newline
	append out rejoin ["length? ""樯"       : " mold length? "樯" "  (chars)" newline]
	append out rejoin ["3rd byte of ""樯""  : " mold 3rd "樯" "  (byte walk)" newline]
	append out rejoin ["find ""ab"" ""b""   : " mold find "ab" "b" newline]
	append out rejoin ["copy/part ""樯樯"" 1 : " mold copy/part "樯樯" 1 newline]

	;; --- 15. money/date/time ------------------------------------------
	append out newline
	append out rejoin ["$12                  : " mold $12 newline]
	append out rejoin ["+USD100               : " mold +USD100 newline]
	append out rejoin ["12:30:15.5            : " mold 12:30:15.5 newline]
	append out rejoin ["2018-01-31            : " mold 2018-01-31 newline]

	write %probe-manual.txt out
	halt
]

R
