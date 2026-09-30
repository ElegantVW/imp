[[
        make [action! 2 [type [datatype! word!] spec [any-type!]] #[none]] 
        random [action! 1 [{Returns a random value of the same datatype; or shuffles series} value "Maximum value of result (modified when series)" /seed "Restart or randomize" /secure "Returns a cryptographically secure random number" /only "Pick a random value from a series" return: [any-type!]] [/seed 1 0 /secure 2 0 /only 3 0]] 
        reflect [action! 2 [{Returns internal details about a value via reflection} value [any-type!] field [word!] {spec, body, words, etc. Each datatype defines its own reflectors}] #[none]] 
        to [action! 2 ["Converts to a specified datatype" type [any-type!] "The datatype or example value" spec [any-type!] "The attributes of the new value"] #[none]] 
        form [action! 1 [{Returns a user-friendly string representation of a value} value [any-type!] /part "Limit the length of the result" limit [integer!] return: [string!]] [/part 1 1]] 
        mold [action! 1 [{Returns a source format string representation of a value} value [any-type!] /only "Exclude outer brackets if value is a block" /all "TBD: Return value in loadable format" /flat "Exclude all indentation" /part "Limit the length of the result" limit [integer!] return: [string!]] [/only 1 0 /all 2 0 /flat 3 0 /part 4 1]] 
        modify [action! 3 ["Change mode for target aggregate value" target [object! series! bitset!] field [word!] value [any-type!] /case "Perform a case-sensitive lookup"] [/case 1 0]] 
        absolute [action! 1 ["Returns the non-negative value" value [number! money! char! pair! time! any-point!] return: [number! money! char! pair! time! any-point!]] #[none]] 
        add [action! 2 ["Returns the sum of the two values" value1 [scalar! vector!] "The augend" value2 [scalar! vector!] "The addend" return: [scalar! vector!] "The sum"] #[none]] 
        divide [action! 2 ["Returns the quotient of two values" value1 [number! money! char! pair! tuple! vector! time! any-point!] "The dividend (numerator)" value2 [number! money! char! pair! tuple! vector! time! any-point!] "The divisor (denominator)" return: [number! money! char! pair! tuple! vector! time! any-point!] "The quotient"] #[none]] 
        multiply [action! 2 ["Returns the product of two values" value1 [number! money! char! pair! tuple! vector! time! any-point!] "The multiplicand" value2 [number! money! char! pair! tuple! vector! time! any-point!] "The multiplier" return: [number! money! char! pair! tuple! vector! time! any-point!] "The product"] #[none]] 
        negate [action! 1 ["Returns the opposite (additive inverse) value" number [number! money! bitset! pair! time! any-point!] return: [number! money! bitset! pair! time! any-point!]] #[none]] 
        power [action! 2 [{Returns a number raised to a given power (exponent)} number [number!] "Base value" exponent [integer! float!] "The power (index) to raise the base value by" return: [number!]] #[none]] 
        remainder [action! 2 [{Returns what is left over when one value is divided by another} value1 [number! money! char! pair! any-point! tuple! vector! time!] "The dividend (numerator)" value2 [number! money! char! pair! any-point! tuple! vector! time!] "The divisor (denominator)" return: [number! money! char! pair! any-point! tuple! vector! time!] "The remainder"] #[none]] 
        round [action! 1 [{Returns the nearest integer. Halves round up (away from zero) by default} n [number! money! time! pair! any-point!] /to "Return the nearest multiple of the scale parameter" scale [number! money! time! pair! any-point!] "If zero, returns N unchanged" /even "Halves round toward even results" /down {Round toward zero, ignoring discarded digits. (truncate)} /half-down "Halves round toward zero" /floor "Round in negative direction" /ceiling "Round in positive direction" /half-ceiling "Halves round in positive direction"] [/to 1 1 /even 2 0 /down 3 0 /half-down 4 0 /floor 5 0 /ceiling 6 0 /half-ceiling 7 0]] 
        subtract [action! 2 ["Returns the difference between two values" value1 [scalar! vector!] "The minuend" value2 [scalar! vector!] "The subtrahend" return: [scalar! vector!] "The difference"] #[none]] 
        even? [action! 1 [{Returns true if the number is evenly divisible by 2} number [number! money! char! time!] return: [logic!]] #[none]] 
        odd? [action! 1 [{Returns true if the number has a remainder of 1 when divided by 2} number [number! money! char! time!] return: [logic!]] #[none]] 
        and~ [action! 2 ["Returns the first value ANDed with the second" value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!] value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!] return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]] #[none]] 
        complement [action! 1 [{Returns the opposite (complementing) value of the input value} value [logic! integer! tuple! bitset! typeset! binary!] return: [logic! integer! tuple! bitset! typeset! binary!]] #[none]] 
        or~ [action! 2 ["Returns the first value ORed with the second" value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!] value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!] return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]] #[none]] 
        xor~ [action! 2 [{Returns the first value exclusive ORed with the second} value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!] value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!] return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]] #[none]] 
        append [action! 2 [{Inserts value(s) at series tail; returns series head} series [series! bitset! port!] value [any-type!] /part "Limit the number of values inserted" length [number! series!] /only {Insert block types as single values (overrides /part)} /dup "Duplicate the inserted values" count [integer!] return: [series! port! bitset!]] [/part 1 1 /only 2 0 /dup 3 1]] 
        at [action! 2 ["Returns a series at a given index" series [series! port!] index [integer! pair!] return: [series! port!]] #[none]] 
        back [action! 1 ["Returns a series at the previous index" series [series! port!] return: [series! port!]] #[none]] 
        change [action! 2 [{Changes a value in a series and returns the series after the change} series [series! port!] "Series at point to change" value [any-type!] "The new value" /part {Limits the amount to change to a given length or position} range [number! series!] /only "Changes a series as a series." /dup "Duplicates the change a specified number of times" count [number!]] [/part 1 1 /only 2 0 /dup 3 1]] 
        clear [action! 1 [{Removes series values from current index to tail; returns new tail} series [series! port! bitset! map! none!] return: [series! port! bitset! map! none!]] #[none]] 
        copy [action! 1 ["Returns a copy of a non-scalar value" value [series! any-object! bitset! map!] /part "Limit the length of the result" length [number! series! pair!] /deep "Copy nested values" /types "Copy only specific types of non-scalar values" kind [datatype!] return: [series! any-object! bitset! map!]] [/part 1 1 /deep 2 0 /types 3 1]] 
        find [action! 2 ["Returns the series where a value is found, or NONE" series [series! bitset! typeset! port! map! none!] value [any-type!] {Typesets and datatypes can be used to search by datatype} /part "Limit the length of the search" length [number! series!] /only {Treat series and typeset value arguments as single values} /case "Perform a case-sensitive search" /same {Use "same?" as comparator} /any "TBD: Use * and ? wildcards in string searches" /with "TBD: Use custom wildcards in place of * and ?" wild [string!] /skip "Treat the series as fixed size records" size [integer!] /last "Find the last occurrence of value, from the tail" /reverse {Find the last occurrence of value, from the current index} /tail {Return the tail of the match found, rather than the head} /match "Match at current index only"] [/part 1 1 /only 2 0 /case 3 0 /same 4 0 /any 5 0 /with 6 1 /skip 7 1 /last 8 0 /reverse 9 0 /tail 10 0 /match 11 0]] 
        head [action! 1 ["Returns a series at its first index" series [series! port!] return: [series! port!]] #[none]] 
        head? [action! 1 ["Returns true if a series is at its first index" series [series! port!] return: [logic!]] #[none]] 
        index? [action! 1 [{Returns the current index of series relative to the head, or of word in a context} series [series! port! any-word!] return: [integer!]] #[none]] 
        insert [action! 2 [{Inserts value(s) at series index; returns series past the insertion} series [series! port! bitset!] value [any-type!] /part "Limit the number of values inserted" length [number! series!] /only {Insert block types as single values (overrides /part)} /dup "Duplicate the inserted values" count [integer!] return: [series! port! bitset!]] [/part 1 1 /only 2 0 /dup 3 1]] 
        length? [action! 1 [{Returns the number of values in the series, from the current index to the tail} series [series! port! bitset! map! tuple! none!] return: [integer! none!]] #[none]] 
        move [action! 2 [{Moves one or more elements from one series to another position or series} origin [series! port!] target [series! port!] /part "Limit the number of values inserted" length [integer!] return: [series! port!]] [/part 1 1]] 
        next [action! 1 ["Returns a series at the next index" series [series! port!] return: [series! port!]] #[none]] 
        pick [action! 2 ["Returns the series value at a given index" series [series! port! bitset! pair! any-point! tuple! money! date! time! event!] index [scalar! any-string! any-word! block! logic! time!] return: [any-type!]] #[none]] 
        poke [action! 3 [{Replaces the series value at a given index, and returns the new value} series [series! port! bitset!] index [scalar! any-string! any-word! block! logic!] value [any-type!] return: [series! port! bitset!]] #[none]] 
        put [action! 3 [{Replaces the value following a key, and returns the new value} series [series! port! map! object!] key [scalar! any-string! all-word! binary!] value [any-type!] /case "Perform a case-sensitive search" return: [series! port! map! object!]] [/case 1 0]] 
        remove [action! 1 [{Returns the series at the same index after removing a value} series [series! port! bitset! map! none!] /part {Removes a number of values, or values up to the given series index} length [number! char! series!] /key "Removes a key in map" key-arg [scalar! any-string! any-word! binary! block!] return: [series! port! bitset! map! none!]] [/part 1 1 /key 2 1]] 
        reverse [action! 1 [{Reverses the order of elements; returns at same position} series [series! port! pair! any-point! tuple!] /part "Limits to a given length or position" length [number! series!] /skip "Treat the series as fixed size records" size [integer!] return: [series! port! pair! any-point! tuple!]] [/part 1 1 /skip 2 1]] 
        select [action! 2 [{Find a value in a series and return the next value, or NONE} series [series! any-object! map! none!] value [any-type!] /part "Limit the length of the search" length [number! series!] /only "Treat a series search value as a single value" /case "Perform a case-sensitive search" /same {Use "same?" as comparator} /any "TBD: Use * and ? wildcards in string searches" /with "TBD: Use custom wildcards in place of * and ?" wild [string!] /skip "Treat the series as fixed size records" size [integer!] /last "Find the last occurrence of value, from the tail" /reverse {Find the last occurrence of value, from the current index} return: [any-type!]] [/part 1 1 /only 2 0 /case 3 0 /same 4 0 /any 5 0 /with 6 1 /skip 7 1 /last 8 0 /reverse 9 0]] 
        sort [action! 1 [{Sorts a series (modified); default sort order is ascending} series [series! port!] /case "Perform a case-sensitive sort" /skip "Treat the series as fixed size records" size [integer!] /compare "Comparator offset, block (TBD) or function" comparator [integer! block! any-function!] /part "Sort only part of a series" length [number! series!] /all "Compare all fields (used with /skip)" /reverse "Reverse sort order" /stable "Stable sorting" return: [series!]] [/case 1 0 /skip 2 1 /compare 3 1 /part 4 1 /all 5 0 /reverse 6 0 /stable 7 0]] 
        skip [action! 2 ["Returns the series relative to the current index" series [series! port!] offset [integer! pair!] return: [series! port!]] #[none]] 
        swap [action! 2 [{Swaps elements between two series or the same series} series1 [series! port!] series2 [series! port!] return: [series! port!]] #[none]] 
        tail [action! 1 ["Returns a series at the index after its last value" series [series! port!] return: [series! port!]] #[none]] 
        tail? [action! 1 ["Returns true if a series is past its last value" series [series! port!] return: [logic!]] #[none]] 
        take [action! 1 ["Removes and returns one or more elements" series [series! port! none!] /part "Specifies a length or end position" length [number! series!] /deep "Copy nested values" /last "Take it from the tail end"] [/part 1 1 /deep 2 0 /last 3 0]] 
        trim [action! 1 ["Removes space from a string or NONE from a block" series [series! port!] /head "Removes only from the head" /tail "Removes only from the tail" /auto "Auto indents lines relative to first line" /lines "Removes all line breaks and extra spaces" /all "Removes all whitespace" /with "Same as /all, but removes characters in 'str'" str [char! string! binary! integer!]] [/head 1 0 /tail 2 0 /auto 3 0 /lines 4 0 /all 5 0 /with 6 1]] 
        create [action! 1 ["Send port a create request" port [port! file! url! block!]] #[none]] 
        close [action! 1 ["Closes a port" port [port!]] #[none]] 
        delete [action! 1 ["Deletes the specified file or empty folder" file [file! port!]] #[none]] 
        open [action! 1 [{Opens a port; makes a new port from a specification if necessary} port [port! file! url! block!] /new "Create new file - if it exists, deletes it" /read "Open for read access" /write "Open for write access" /seek "Optimize for random access" /allow "Specificies right access attributes" access [block!]] [/new 1 0 /read 2 0 /write 3 0 /seek 4 0 /allow 5 1]] 
        open? [action! 1 ["Returns TRUE if port is open" port [port!]] #[none]] 
        query [action! 1 ["Returns information about a file" target [file! port!]] #[none]] 
        read [action! 1 ["Reads from a file, URL, or other port" source [file! url! port!] /part {Partial read a given number of units (source relative)} length [number!] /seek "Read from a specific position (source relative)" index [number!] /binary "Preserves contents exactly" /lines "Convert to block of strings" /info /as {Read with the specified encoding, default is 'UTF-8} encoding [word!]] [/part 1 1 /seek 2 1 /binary 3 0 /lines 4 0 /info 5 0 /as 6 1]] 
        rename [action! 2 ["Rename a file" from [port! file! url!] to [port! file! url!]] #[none]] 
        update [action! 1 [{Updates external and internal states (normally after read/write)} port [port!]] #[none]] 
        write [action! 2 ["Writes to a file, URL, or other port" destination [file! url! port!] data [any-type!] /binary "Preserves contents exactly" /lines "Write each value in a block as a separate line" /info /append "Write data at end of file" /part "Partial write a given number of units" length [number!] /seek "Write at a specific position" index [number!] /allow "Specifies protection attributes" access [block!] /as {Write with the specified encoding, default is 'UTF-8} encoding [word!]] [/binary 1 0 /lines 2 0 /info 3 0 /append 4 0 /part 5 1 /seek 6 1 /allow 7 1 /as 8 1]] 
        if [intrinsic! 2 [{If conditional expression is truthy, evaluate block; else return NONE} cond [any-type!] then-blk [block!]] #[none]] 
        unless [intrinsic! 2 [{If conditional expression is falsy, evaluate block; else return NONE} cond [any-type!] then-blk [block!]] #[none]] 
        either [intrinsic! 3 [{If conditional expression is truthy, evaluate the first branch; else evaluate the alternative} cond [any-type!] true-blk [block!] false-blk [block!]] #[none]] 
        any [intrinsic! 1 [{Evaluates and returns the first truthy value, if any; else NONE} conds [block!]] #[none]] 
        all [intrinsic! 1 [{Evaluates and returns the last value if all are truthy; else NONE} conds [block!]] #[none]] 
        while [intrinsic! 2 [{Evaluates body as long as condition block evaluates to truthy value} cond [block!] "Condition block to evaluate on each iteration" body [block!] "Block to evaluate on each iteration"] #[none]] 
        until [intrinsic! 1 ["Evaluates body until it is truthy" body [block!]] #[none]] 
        loop [intrinsic! 2 ["Evaluates body a number of times" count [float! integer!] body [block!]] #[none]] 
        repeat [intrinsic! 3 [{Evaluates body a number of times, tracking iteration count} 'word [word!] "Iteration counter; not local to loop" value [float! integer!] "Number of times to evaluate body" body [block!]] #[none]] 
        forever [intrinsic! 1 ["Evaluates body repeatedly forever" body [block!]] #[none]] 
        foreach [intrinsic! 3 ["Evaluates body for each value in a series" 'word [block! word!] "Word, or words, to set on each iteration" series [map! series!] body [block!]] #[none]] 
        forall [intrinsic! 2 ["Evaluates body for all values in a series" 'word [word!] "Word referring to series to iterate over" body [block!]] #[none]] 
        remove-each [intrinsic! 3 [{Removes values for each block that returns truthy value} 'word [block! word!] "Word or block of words to set each time" data [series!] "The series to traverse (modified)" body [block!] "Block to evaluate (return truthy value to remove)"] #[none]] 
        func [intrinsic! 2 ["Defines a function with a given spec and body" spec [block!] body [block!]] #[none]] 
        function [intrinsic! 2 [{Defines a function, making all set-words found in body, local} spec [block!] body [block!] /extern "Exclude words that follow this refinement"] [/extern 1 0]] 
        does [intrinsic! 1 [{Defines a function with no arguments or local variables} body [block!]] #[none]] 
        has [intrinsic! 2 [{Defines a function with local variables, but no arguments} vars [block!] body [block!]] #[none]] 
        switch [intrinsic! 2 [{Evaluates the first block following the value found in cases} value [any-type!] "The value to match" cases [block!] /default {Specify a default block, if value is not found in cases} case [block!] "Default block to evaluate"] [/default 1 1]] 
        case [intrinsic! 1 [{Evaluates the block following the first truthy condition} cases [block!] "Block of condition-block pairs" /all {Test all conditions, evaluating the block following each truthy condition}] [/all 1 0]] 
        do [native! 1 [{Evaluates a value, returning the last evaluation result} value [any-type!] /expand "Expand directives before evaluation" /args {If value is a script, this will set its system/script/args} arg "Args passed to a script (normally a string)" /next {Do next expression only, return it, update block word} position [word!] "Word updated with new block position" /trace callback [function! [
                        event [word!] 
                        code [any-block! none!] 
                        offset [integer!] 
                        value [any-type!] 
                        ref [any-type!] 
                        frame [pair!]
                    ]]] [/expand 1 0 /args 2 1 /next 3 1 /trace 4 1]] 
        reduce [intrinsic! 1 [{Returns a copy of a block, evaluating all expressions} value [any-type!] /into {Put results in out block, instead of creating a new block} out [any-block!] "Target block for results, when /into is used"] [/into 1 1]] 
        compose [native! 1 ["Returns a copy of a block, evaluating only parens" value [block!] /deep "Compose nested blocks" /only {Compose nested blocks as blocks containing their values} /into {Put results in out block, instead of creating a new block} out [any-block!] "Target block for results, when /into is used"] [/deep 1 0 /only 2 0 /into 3 1]] 
        get [intrinsic! 1 ["Returns the value a word refers to" word [any-path! any-word! object!] /any {If word has no value, return UNSET rather than causing an error} /case "Use case-sensitive comparison (path only)" return: [any-type!]] [/any 1 0 /case 2 0]] 
        set [intrinsic! 2 ["Sets the value(s) one or more words refer to" word [any-path! any-word! block! object!] "Word, object, map path or block of words to set" value [any-type!] "Value or block of values to assign to words" /any {Allow UNSET as a value rather than causing an error} /case "Use case-sensitive comparison (path only)" /only {Block or object value argument is set as a single value} /some {None values in a block or object value argument, are not set} return: [any-type!]] [/any 1 0 /case 2 0 /only 3 0 /some 4 0]] 
        print [native! 1 ["Outputs a value followed by a newline" value [any-type!]] #[none]] 
        prin [native! 1 ["Outputs a value" value [any-type!]] #[none]] 
        equal? [native! 2 ["Returns TRUE if two values are equal" value1 [any-type!] value2 [any-type!]] #[none]] 
        not-equal? [native! 2 ["Returns TRUE if two values are not equal" value1 [any-type!] value2 [any-type!]] #[none]] 
        strict-equal? [native! 2 [{Returns TRUE if two values are equal, and also the same datatype} value1 [any-type!] value2 [any-type!]] #[none]] 
        lesser? [native! 2 [{Returns TRUE if the first value is less than the second} value1 [any-type!] value2 [any-type!]] #[none]] 
        greater? [native! 2 [{Returns TRUE if the first value is greater than the second} value1 [any-type!] value2 [any-type!]] #[none]] 
        lesser-or-equal? [native! 2 [{Returns TRUE if the first value is less than or equal to the second} value1 [any-type!] value2 [any-type!]] #[none]] 
        greater-or-equal? [native! 2 [{Returns TRUE if the first value is greater than or equal to the second} value1 [any-type!] value2 [any-type!]] #[none]] 
        same? [native! 2 ["Returns TRUE if two values have the same identity" value1 [any-type!] value2 [any-type!]] #[none]] 
        not [native! 1 [{Returns the logical complement of a value (truthy or falsy)} value [any-type!]] #[none]] 
        type? [native! 1 ["Returns the datatype of a value" value [any-type!] /word "Return a word value, rather than a datatype value"] [/word 1 0]] 
        stats [native! 0 ["Returns interpreter statistics" /show "TBD:" /info {Return detailed info: nodes/series/big x free/used/total, total, low-level heap} return: [integer! block!]] [/show 1 0 /info 2 0]] 
        bind [native! 2 ["Bind words to a context; returns rebound words" word [any-word! block!] context [any-object! any-word! function!] /copy "Deep copy blocks before binding" return: [block! any-word!]] [/copy 1 0]] 
        in [native! 2 [{Returns the given word bound to the object's context} object [any-function! any-object!] word [any-word! refinement!]] #[none]] 
        parse [native! 2 ["Process a series using dialected grammar rules" input [any-block! any-string! binary!] rules [block!] /case "Uses case-sensitive comparison" /part "Limit to a length or position" length [number! series!] /trace callback [function! [
                        event [word!] 
                        match? [logic!] 
                        rule [block!] 
                        input [series!] 
                        stack [block!] 
                        return: [logic!]
                    ]] return: [logic! block!]] [/case 1 0 /part 2 1 /trace 3 1]] 
        union [native! 2 ["Returns the union of two data sets" set1 [bitset! block! hash! string! typeset!] set2 [bitset! block! hash! string! typeset!] /case "Use case-sensitive comparison" /skip "Treat the series as fixed size records" size [integer!] return: [block! hash! string! bitset! typeset!]] [/case 1 0 /skip 2 1]] 
        unique [native! 1 ["Returns the data set with duplicates removed" set [block! hash! string!] /case "Use case-sensitive comparison" /skip "Treat the series as fixed size records" size [integer!] return: [block! hash! string!]] [/case 1 0 /skip 2 1]] 
        intersect [native! 2 ["Returns the intersection of two data sets" set1 [bitset! block! hash! string! typeset!] set2 [bitset! block! hash! string! typeset!] /case "Use case-sensitive comparison" /skip "Treat the series as fixed size records" size [integer!] return: [block! hash! string! bitset! typeset!]] [/case 1 0 /skip 2 1]] 
        difference [native! 2 ["Returns the special difference of two data sets" set1 [bitset! block! date! hash! string! typeset!] set2 [bitset! block! date! hash! string! typeset!] /case "Use case-sensitive comparison" /skip "Treat the series as fixed size records" size [integer!] return: [block! hash! string! bitset! typeset! time!]] [/case 1 0 /skip 2 1]] 
        exclude [native! 2 [{Returns the first data set less the second data set} set1 [bitset! block! hash! string! typeset!] set2 [bitset! block! hash! string! typeset!] /case "Use case-sensitive comparison" /skip "Treat the series as fixed size records" size [integer!] return: [block! hash! string! bitset! typeset!]] [/case 1 0 /skip 2 1]] 
        complement? [native! 1 ["Returns TRUE if the bitset is complemented" bits [bitset!]] #[none]] 
        dehex [native! 1 ["Converts URL-style hex encoded (%xx) strings" value [any-string!] return: [string!] "Always return a string"] #[none]] 
        enhex [native! 1 ["Encode URL-style hex encoded (%xx) strings" value [any-string!] return: [string!] "Always return a string"] #[none]] 
        negative? [native! 1 ["Returns TRUE if the number is negative" number [money! number! time!] return: [logic!]] #[none]] 
        positive? [native! 1 ["Returns TRUE if the number is positive" number [money! number! time!] return: [logic!]] #[none]] 
        max [native! 2 ["Returns the greater of the two values" value1 [scalar! series!] value2 [scalar! series!]] #[none]] 
        min [native! 2 ["Returns the lesser of the two values" value1 [scalar! series!] value2 [scalar! series!]] #[none]] 
        shift [native! 2 [{Perform a bit shift operation. Right shift (decreasing) by default} data [integer!] bits [integer!] /left "Shift bits to the left (increasing)" /logical "Use logical shift (unsigned, fill with zero)" return: [integer!]] [/left 1 0 /logical 2 0]] 
        to-hex [native! 1 [{Converts numeric value to a hex issue! datatype (with leading # and 0's)} value [integer!] /size "Specify number of hex digits in result" length [integer!] return: [issue!]] [/size 1 1]] 
        sine [native! 1 ["Returns the trigonometric sine" angle [float! integer!] /radians "DEPRECATED: use `sin` native instead" return: [float!]] [/radians 1 0]] 
        cosine [native! 1 ["Returns the trigonometric cosine" angle [float! integer!] /radians "DEPRECATED: use `cos` native instead" return: [float!]] [/radians 1 0]] 
        tangent [native! 1 ["Returns the trigonometric tangent" angle [float! integer!] /radians "DEPRECATED: use `tan` native instead" return: [float!]] [/radians 1 0]] 
        arcsine [native! 1 [{Returns the trigonometric arcsine in degrees in range [-90,90]} sine [float! integer!] "in range [-1,1]" /radians "DEPRECATED: use `asin` native instead" return: [float!]] [/radians 1 0]] 
        arccosine [native! 1 [{Returns the trigonometric arccosine in degrees in range [0,180]} cosine [float! integer!] "in range [-1,1]" /radians "DEPRECATED: use `acos` native instead" return: [float!]] [/radians 1 0]] 
        arctangent [native! 1 [{Returns the trigonometric arctangent in degrees in range [-90,90]} tangent [float! integer!] "in range [-inf,+inf]" /radians "DEPRECATED: use `atan` native instead" return: [float!]] [/radians 1 0]] 
        arctangent2 [native! 2 [{Returns the smallest angle between the vectors (1,0) and (x,y) in degrees (-180,180]} y [float! integer!] x [float! integer!] /radians "DEPRECATED: use `atan2` native instead" return: [float!]] [/radians 1 0]] 
        NaN? [native! 1 ["Returns TRUE if the number is Not-a-Number" value [number!] return: [logic!]] #[none]] 
        zero? [native! 1 ["Returns TRUE if the value is zero" value [any-point! char! money! number! pair! time! tuple!] return: [logic!]] #[none]] 
        log-2 [native! 1 ["Return the base-2 logarithm" value [float! integer! percent!] return: [float!]] #[none]] 
        log-10 [native! 1 ["Returns the base-10 logarithm" value [float! integer! percent!] return: [float!]] #[none]] 
        log-e [native! 1 [{Returns the natural (base-E) logarithm of the given value} value [float! integer! percent!] return: [float!]] #[none]] 
        exp [native! 1 [{Raises E (the base of natural logarithm) to the power specified} value [float! integer! percent!] return: [float!]] #[none]] 
        square-root [native! 1 ["Returns the square root of a number" value [float! integer! percent!] return: [float!]] #[none]] 
        construct [intrinsic! 1 [{Makes a new object from an unevaluated spec; standard logic words are evaluated} block [block!] /with "Use a prototype object" object [object!] "Prototype object" /only "Don't evaluate standard logic words"] [/with 1 1 /only 2 0]] 
        value? [native! 1 ["Returns TRUE if the word has a value" value [word!] return: [logic!]] #[none]] 
        try [intrinsic! 1 [{Tries to DO a block and returns its value or an error} block [block!] /all {Catch also BREAK, CONTINUE, RETURN, EXIT and THROW exceptions} /keep {Capture and save the call stack in the error object}] [/all 1 0 /keep 2 0]] 
        uppercase [native! 1 ["Converts string of characters to uppercase" string [any-string! char!] "Value to convert (modified when series)" /part "Limits to a given length or position" limit [any-string! number!] return: [any-string! char!]] [/part 1 1]] 
        lowercase [native! 1 ["Converts string of characters to lowercase" string [any-string! char!] "Value to convert (modified when series)" /part "Limits to a given length or position" limit [any-string! number!] return: [any-string! char!]] [/part 1 1]] 
        as-pair [native! 2 ["Combine X and Y values into a pair" x [float! integer!] y [float! integer!]] #[none]] 
        as-point2D [native! 2 ["Combine X and Y values into a 2D point" x [float! integer!] y [float! integer!]] #[none]] 
        as-point3D [native! 3 ["Combine X, Y and Z values into a 3D point" x [float! integer!] y [float! integer!] z [float! integer!]] #[none]] 
        as-money [native! 2 [{Combine currency code and amount into a monetary value} currency [word!] amount [float! integer!] return: [money!]] #[none]] 
        break [intrinsic! 0 [{Breaks out of a loop, while, until, repeat, foreach, etc} /return "Forces the loop function to return a value" value [any-type!]] [/return 1 1]] 
        continue [intrinsic! 0 ["Throws control back to top of loop"] #[none]] 
        exit [intrinsic! 0 ["Exits a function, returning no value"] #[none]] 
        return [intrinsic! 1 ["Returns a value from a function" value [any-type!]] #[none]] 
        throw [native! 1 ["Throws control back to a previous catch" value [any-type!] "Value returned from catch" /name "Throws to a named catch" word [word!]] [/name 1 1]] 
        catch [native! 1 ["Catches a throw from a block and returns its value" block [block!] "Block to evaluate" /name "Catches a named throw" word [block! word!] "One or more names"] [/name 1 1]] 
        extend [native! 2 [{Extend an object or map value with list of key and value pairs} obj [map! object!] spec [block! hash! map!] /case "Use case-sensitive comparison"] [/case 1 0]] 
        debase [native! 1 [{Decodes binary-coded string (BASE-64 default) to binary value} value [string!] "The string to decode" /base "Binary base to use" base-value [integer!] "The base to convert from: 64, 58, 16, or 2"] [/base 1 1]] 
        enbase [native! 1 [{Encodes a string into a binary-coded string (BASE-64 default)} value [binary! string!] "If string, will be UTF8 encoded" /base "Binary base to use" base-value [integer!] "The base to convert from: 64, 58, 16, or 2"] [/base 1 1]] 
        to-local-file [native! 1 [{Converts a Red file path to the local system file path} path [file! string!] /full {Prepends current dir for full path (for relative paths only)} return: [string!]] [/full 1 0]] 
        wait [native! 1 ["Waits for a duration in seconds or specified time" value [block! none! number! time!] /all "Returns all events in a block"] [/all 1 0]] 
        checksum [native! 2 ["Computes a checksum, CRC, hash, or HMAC" data [binary! file! string!] method [word!] {MD5 SHA1 SHA256 SHA384 SHA512 CRC32 TCP ADLER32 hash} /with {Extra value for HMAC key or hash table size; not compatible with TCP/CRC32/ADLER32 methods} spec [any-string! binary! integer!] {String or binary for MD5/SHA* HMAC key, integer for hash table size} return: [integer! binary!]] [/with 1 1]] 
        unset [native! 1 ["Unsets the value of a word in its current context" word [block! word!] "Word or block of words"] #[none]] 
        new-line [native! 2 [{Sets or clears the new-line marker within a list series} position [any-list!] "Position to change marker (modified)" value [logic!] "Set TRUE for newline" /all "Set/clear marker to end of series" /skip {Set/clear marker periodically to the end of the series} size [integer!] return: [any-list!]] [/all 1 0 /skip 2 1]] 
        new-line? [native! 1 [{Returns the state of the new-line marker within a list series} position [any-list!] "Position to check marker" return: [logic!]] #[none]] 
        context? [native! 1 ["Returns the context to which a word is bound" word [any-word!] "Word to check" return: [object! function! none!]] #[none]] 
        set-env [native! 2 [{Sets the value of an operating system environment variable (for current process)} var [any-string! any-word!] "Variable to set" value [none! string!] "Value to set, or NONE to unset it"] #[none]] 
        get-env [native! 1 [{Returns the value of an OS environment variable (for current process)} var [any-string! any-word!] "Variable to get" return: [string! none!]] #[none]] 
        list-env [native! 0 [{Returns a map of OS environment variables (for current process)} return: [map!]] #[none]] 
        now [native! 0 ["Returns date and time" /year "Returns year only" /month "Returns month only" /day "Returns day of the month only" /time "Returns time only" /zone "Returns time zone offset from UTC (GMT) only" /date "Returns date only" /weekday {Returns day of the week as integer (Monday is day 1)} /yearday "Returns day of the year (Julian)" /precise "High precision time" /utc "Universal time (no zone)" return: [date! time! integer!]] [/year 1 0 /month 2 0 /day 3 0 /time 4 0 /zone 5 0 /date 6 0 /weekday 7 0 /yearday 8 0 /precise 9 0 /utc 10 0]] 
        sign? [native! 1 [{Returns sign of N as 1, 0, or -1 (to use as a multiplier)} number [money! number! time!] return: [integer!]] #[none]] 
        as [native! 2 [{Coerce a series into a compatible datatype without copying it} type [any-path! any-string! block! datatype! paren!] "The datatype or example value" spec [any-path! any-string! block! paren!] "The series to coerce"] #[none]] 
        call [native! 1 ["Executes a shell command to run another process" cmd [file! string!] "A shell command or an executable file" /wait "Runs command and waits for exit" /show {Force the display of system's shell window (Windows only)} /console {Runs command with I/O redirected to console (CLI console only at present)} /shell "Forces command to be run from shell" /input in [binary! file! string!] "Redirects in to stdin" /output out [binary! file! string!] "Redirects stdout to out" /error err [binary! file! string!] "Redirects stderr to err" return: [integer!] "0 if success, -1 if error, or a process ID"] [/wait 1 0 /show 2 0 /console 3 0 /shell 4 0 /input 5 1 /output 6 1 /error 7 1]] 
        size? [native! 1 ["Returns the size of a file content" file [file!] return: [integer! none!]] #[none]] 
        browse [native! 1 [{Opens the URL in a web browser or the file in the associated application} url [file! url!]] #[none]] 
        compress [native! 2 ["Compresses data" data [any-string! binary!] method [word!] "zlib deflate gzip" return: [binary!]] #[none]] 
        decompress [native! 2 ["Decompresses data" data [binary!] method [word!] "zlib deflate gzip" /size {Specify an uncompressed data size (ignored for GZIP)} sz [integer!] "Uncompressed data size; must not be negative" return: [binary!]] [/size 1 1]] 
        recycle [native! 0 [{Recycles unused memory and returns memory amount still in use} /on "Turns on garbage collector; returns nothing" /off "Turns off garbage collector; returns nothing" return: [integer! unset!]] [/on 1 0 /off 2 0]] 
        transcode [native! 1 [{Translates UTF-8 binary source to values. Returns one or several values in a block} src [binary! string!] {UTF-8 input buffer; string argument will be UTF-8 encoded} /next {Translate next complete value (blocks as single value)} /one {Translate next complete value, returns the value only} /prescan {Prescans only, do not load values. Returns guessed type.} /scan {Scans only, do not load values. Returns recognized type.} /part "Translates only part of the input buffer" length [binary! integer!] "Length in bytes or tail position" /into "Optionally provides an output block" dst [block!] /trace callback [
                    function! 
                    routine! [
                        event [word!] 
                        input [binary! string!] 
                        type [word! datatype!] 
                        line [integer!] 
                        token 
                        return: [logic!]
                    ] [
                        event [word!] 
                        input [binary! string!] 
                        type [word! datatype!] 
                        line [integer!] 
                        token 
                        return: [logic!]
                    ]
                ] return: [block!]] [/next 1 0 /one 2 0 /prescan 3 0 /scan 4 0 /part 5 1 /into 6 1 /trace 7 1]] 
        apply [native! 2 ["Apply a function to a reduced block of arguments" func [any-function! path! word!] "Function to apply, with eventual refinements" args [block!] "Block of args, reduced first" /all {Provide every argument in the function spec, in order, tail-completed with false/none.} /safer {Forces single refinement arguments, skip them when inactive instead of evaluating}] [/all 1 0 /safer 2 0]] 
        quit-return [routine! 1 [
                status #[block![2 1x1 integer!]3]
            ] #[none]] 
        set-quiet [routine! 2 [
                word #[block![2 1x1 red/cell!]3] 
                value #[block![2 1x1 red/cell!]3] 
                return: #[block![2 1x1 red/cell!]3] 
                /local 
                w #[block![2 1x1 red-word!]3] 
                type #[block![2 1x1 integer!]3] 
                node #[block![2 1x1 pointer! #[block![2 1x1 integer!]3]]3]
            ] #[none]] 
        set-slot-quiet [routine! 2 [
                series #[block![2 619x1 red/cell!]3] 
                value #[block![2 619x1 red/cell!]3] 
                /local 
                blk #[block![2 619x1 red-block!]3] 
                type #[block![2 619x1 integer!]3]
            ] #[none]] 
        shift-right [routine! 2 ["Shift bits to the right" data #[block![2 619x1 integer!]3] bits #[block![2 619x1 integer!]3]] #[none]] 
        shift-left [routine! 2 [data #[block![2 619x1 integer!]3] bits #[block![2 619x1 integer!]3]] #[none]] 
        shift-logical [routine! 2 ["Shift bits to the right (unsigned)" data #[block![2 619x1 integer!]3] bits #[block![2 619x1 integer!]3]] #[none]] 
        last-lf? [routine! 0 ["Internal Use Only" /local bool #[block![2 619x1 red-logic!]3]] #[none]] 
        get-current-dir [routine! 0 [] #[none]] 
        set-current-dir [routine! 1 [path #[block![2 619x1 red-file!]3] /local dir #[block![2 619x1 red-file!]3]] #[none]] 
        create-dir [routine! 1 [path #[block![2 619x1 red-file!]3]] #[none]] 
        exists? [routine! 1 [path #[block![2 619x1 red-file!]3] return: #[block![2 619x1 logic!]3]] #[none]] 
        os-info [routine! 0 [{Returns detailed operating system version information}] #[none]] 
        as-color [routine! 3 [
                r #[block![2 619x1 integer!]3] 
                g #[block![2 619x1 integer!]3] 
                b #[block![2 619x1 integer!]3] 
                /local 
                arr1 #[block![2 619x1 integer!]3] 
                err #[block![2 619x1 integer!]3]
            ] #[none]] 
        as-ipv4 [routine! 4 [
                "Combine a, b, c and d values into a tuple" 
                a #[block![2 619x1 integer!]3] 
                b #[block![2 619x1 integer!]3] 
                c #[block![2 619x1 integer!]3] 
                d #[block![2 619x1 integer!]3] 
                /local 
                arr1 #[block![2 619x1 integer!]3] 
                err #[block![2 619x1 integer!]3]
            ] #[none]] 
        as-rgba [routine! 4 [
                r #[block![2 619x1 integer!]3] 
                g #[block![2 619x1 integer!]3] 
                b #[block![2 619x1 integer!]3] 
                a #[block![2 619x1 integer!]3]
            ] #[none]] 
        count-chars [routine! 2 [
                {Count UTF-8 encoded characters between two positions in a binary series} 
                start #[block![2 619x1 red-binary!]3] 
                pos #[block![2 619x1 red-binary!]3] 
                return: #[block![2 619x1 integer!]3] 
                /local 
                p tail #[block![2 619x1 pointer! #[block![2 619x1 byte!]3]]3] 
                c len #[block![2 619x1 integer!]3] 
                s #[block![2 619x1 red/series-buffer!]3]
            ] #[none]] 
        stack-size? [routine! 0 [return: #[block![2 619x1 integer!]3]] #[none]] 
        pick-stack [routine! 1 [
                idx #[block![2 619x1 integer!]3]
            ] #[none]] 
        frame-index? [routine! 0 [return: #[block![2 619x1 integer!]3]] #[none]] 
        collect-calls [routine! 1 [blk #[block![2 619x1 red-block!]3]] #[none]] 
        tracing? [routine! 0 [] #[none]] 
        read-clipboard [routine! 0 [
                "Return the contents of the system clipboard" 
                return: #[block![2 619x1 red/cell!]3] {false on failure, none if empty, otherwise: string!, block! of files!, or an image!}
            ] #[none]] 
        write-clipboard [routine! 1 [
                "Write content to the system clipboard" 
                data #[block![2 619x1 red/cell!]3] "string!, block! of files!, an image! or none!" 
                return: #[block![2 619x1 logic!]3] "indicates success"
            ] #[none]] 
        write-stdout [routine! 1 ["Write data to STDOUT" data #[block![2 619x1 red/cell!]3]] #[none]] 
        routine [function! 2 [{Defines a function with a given Red spec and Red/System body} spec [block!] body [block!]] #[none]] 
        also [function! 2 [
                {Returns the first value, but also evaluates the second} 
                value1 [any-type!] 
                value2 [any-type!]
            ] #[none]] 
        attempt [function! 1 [
                {Tries to evaluate a block and returns result or NONE on error} 
                code [block!] 
                /safer "Capture all possible errors and exceptions" 
                /local all result
            ] [
                /safer 1 0
            ]] 
        comment [function! 1 ["Consume but don't evaluate the next value" 'value] #[none]] 
        quit [function! 0 [
                "Stops evaluation and exits the program" 
                /return status [integer!] "Return an exit status"
            ] [
                /return 1 1
            ]] 
        empty? [function! 1 [
                {Returns true if data is a series at its tail or an empty map} 
                data [map! none! series!] 
                return: [logic!]
            ] #[none]] 
        ?? [function! 1 [
                "Prints a word and the value it refers to (molded)" 
                'value [path! word!]
            ] #[none]] 
        probe [function! 1 [
                "Returns a value after printing its molded form" 
                value [any-type!]
            ] #[none]] 
        quote [function! 1 [
                "Return but don't evaluate the next value" 
                :value [any-type!]
            ] #[none]] 
        first [function! 1 ["Returns the first value in a series" s [any-point! date! pair! series! time! tuple!]] #[none]] 
        second [function! 1 ["Returns the second value in a series" s [any-point! date! pair! series! time! tuple!]] #[none]] 
        third [function! 1 ["Returns the third value in a series" s [date! point3D! series! time! tuple!]] #[none]] 
        fourth [function! 1 ["Returns the fourth value in a series" s [date! series! tuple!]] #[none]] 
        fifth [function! 1 ["Returns the fifth value in a series" s [date! series! tuple!]] #[none]] 
        last [function! 1 ["Returns the last value in a series" s [series! tuple!]] #[none]] 
        spec-of [function! 1 [{Returns the spec of a value that supports reflection} value] #[none]] 
        body-of [function! 1 [{Returns the body of a value that supports reflection} value] #[none]] 
        words-of [function! 1 [{Returns the list of words of a value that supports reflection} value] #[none]] 
        class-of [function! 1 ["Returns the class ID of an object" value] #[none]] 
        values-of [function! 1 [{Returns the list of values of a value that supports reflection} value] #[none]] 
        bitset? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        binary? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        block? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        char? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        email? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        file? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        float? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        get-path? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        get-word? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        hash? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        integer? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        issue? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        lit-path? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        lit-word? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        logic? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        map? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        none? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        pair? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        paren? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        path? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        percent? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        refinement? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        set-path? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        set-word? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        string? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        tag? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        time? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        typeset? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        tuple? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        unset? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        url? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        word? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        image? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        date? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        money? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        ref? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        point2D? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        point3D? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        handle? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        error? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        action? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        native? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        datatype? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        function? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        object? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        op? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        routine? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        vector? [function! 1 
            ["Returns true if the value is this type" value [any-type!]] #[none]
        ] 
        any-list? [function! 1 ["Returns true if the value is any type of any-list" value [any-type!]] #[none]] 
        any-block? [function! 1 ["Returns true if the value is any type of any-block" value [any-type!]] #[none]] 
        any-function? [function! 1 [{Returns true if the value is any type of any-function} value [any-type!]] #[none]] 
        any-object? [function! 1 [{Returns true if the value is any type of any-object} value [any-type!]] #[none]] 
        any-path? [function! 1 ["Returns true if the value is any type of any-path" value [any-type!]] #[none]] 
        any-string? [function! 1 [{Returns true if the value is any type of any-string} value [any-type!]] #[none]] 
        any-word? [function! 1 ["Returns true if the value is any type of any-word" value [any-type!]] #[none]] 
        series? [function! 1 ["Returns true if the value is any type of series" value [any-type!]] #[none]] 
        number? [function! 1 ["Returns true if the value is any type of number" value [any-type!]] #[none]] 
        immediate? [function! 1 ["Returns true if the value is any type of immediate" value [any-type!]] #[none]] 
        scalar? [function! 1 ["Returns true if the value is any type of scalar" value [any-type!]] #[none]] 
        all-word? [function! 1 ["Returns true if the value is any type of all-word" value [any-type!]] #[none]] 
        any-point? [function! 1 ["Returns true if the value is any type of any-point" value [any-type!]] #[none]] 
        planar? [function! 1 ["Returns true if the value is any type of planar" value [any-type!]] #[none]] 
        to-bitset [function! 1 ["Convert to bitset! value" value] #[none]] 
        to-binary [function! 1 ["Convert to binary! value" value] #[none]] 
        to-block [function! 1 ["Convert to block! value" value] #[none]] 
        to-char [function! 1 ["Convert to char! value" value] #[none]] 
        to-email [function! 1 ["Convert to email! value" value] #[none]] 
        to-file [function! 1 ["Convert to file! value" value] #[none]] 
        to-float [function! 1 ["Convert to float! value" value] #[none]] 
        to-get-path [function! 1 ["Convert to get-path! value" value] #[none]] 
        to-get-word [function! 1 ["Convert to get-word! value" value] #[none]] 
        to-hash [function! 1 ["Convert to hash! value" value] #[none]] 
        to-integer [function! 1 ["Convert to integer! value" value] #[none]] 
        to-issue [function! 1 ["Convert to issue! value" value] #[none]] 
        to-lit-path [function! 1 ["Convert to lit-path! value" value] #[none]] 
        to-lit-word [function! 1 ["Convert to lit-word! value" value] #[none]] 
        to-logic [function! 1 ["Convert to logic! value" value] #[none]] 
        to-map [function! 1 ["Convert to map! value" value] #[none]] 
        to-none [function! 1 ["Convert to none! value" value] #[none]] 
        to-pair [function! 1 ["Convert to pair! value" value] #[none]] 
        to-paren [function! 1 ["Convert to paren! value" value] #[none]] 
        to-path [function! 1 ["Convert to path! value" value] #[none]] 
        to-percent [function! 1 ["Convert to percent! value" value] #[none]] 
        to-refinement [function! 1 ["Convert to refinement! value" value] #[none]] 
        to-set-path [function! 1 ["Convert to set-path! value" value] #[none]] 
        to-set-word [function! 1 ["Convert to set-word! value" value] #[none]] 
        to-string [function! 1 ["Convert to string! value" value] #[none]] 
        to-tag [function! 1 ["Convert to tag! value" value] #[none]] 
        to-time [function! 1 ["Convert to time! value" value] #[none]] 
        to-typeset [function! 1 ["Convert to typeset! value" value] #[none]] 
        to-tuple [function! 1 ["Convert to tuple! value" value] #[none]] 
        to-unset [function! 1 ["Convert to unset! value" value] #[none]] 
        to-url [function! 1 ["Convert to url! value" value] #[none]] 
        to-word [function! 1 ["Convert to word! value" value] #[none]] 
        to-image [function! 1 ["Convert to image! value" value] #[none]] 
        to-date [function! 1 ["Convert to date! value" value] #[none]] 
        to-money [function! 1 ["Convert to money! value" value] #[none]] 
        to-ref [function! 1 ["Convert to ref! value" value] #[none]] 
        to-point2D [function! 1 ["Convert to point2D! value" value] #[none]] 
        to-point3D [function! 1 ["Convert to point3D! value" value] #[none]] 
        context [function! 1 [
                "Makes a new object from an evaluated spec" 
                spec [block!]
            ] #[none]] 
        alter [function! 2 [
                {If a value is not found in a series, append it; otherwise, remove it. Returns true if added} 
                series [series!] 
                value
            ] #[none]] 
        offset? [function! 2 [
                "Returns the offset between two series positions" 
                series1 [series!] 
                series2 [series!]
            ] #[none]] 
        repend [function! 2 [
                {Appends a reduced value to a series and returns the series head} 
                series [series!] 
                value 
                /only "Appends a block value as a block"
            ] [
                /only 1 0
            ]] 
        replace [function! 3 [
                "Replaces values in a series, in place" 
                series [any-block! any-string! binary! vector!] "The series to be modified" 
                pattern "Specific value or parse rule pattern to match" 
                value "New value, replaces pattern in the series" 
                /all "Replace all occurrences, not just the first" 
                /deep "Replace pattern in all sub-lists as well" 
                /case "Case-sensitive replacement" 
                /local parse? form? quote? deep? rule many? size seek active?
            ] [
                /all 1 0 
                /deep 2 0 
                /case 3 0
            ]] 
        math [function! 1 [
                "Evaluates expression using math precedence rules" 
                datum [block! paren!] "Expression to evaluate" 
                /safe "Returns NONE on error" 
                /local match 
                order infix tally enter recur count operator
            ] [
                /safe 1 0
            ]] 
        charset [function! 1 [
                "Shortcut for `make bitset!`" 
                spec [binary! bitset! block! char! integer! string!]
            ] #[none]] 
        ctx||183~on-parse-event [function! 5 [
                "Standard parse/trace callback used by PARSE-TRACE" 
                event [word!] {Trace events: push, pop, fetch, match, iterate, paren, end} 
                match? [logic!] "Result of last matching operation" 
                rule [block!] "Current rule at current position" 
                input [series!] "Input series at next position to match" 
                stack [block!] "Internal parse rules stack" 
                return: [logic!] {TRUE: continue parsing, FALSE: stop and exit parsing}
            ] #[none]] 
        parse-trace [function! 2 [
                {Wrapper for parse/trace using the default event processor} 
                input [series!] 
                rules [block!] 
                /case "Uses case-sensitive comparison" 
                /part "Limit to a length or position" 
                limit [integer!] 
                return: [logic! block!]
            ] [
                /case 1 0 
                /part 2 1
            ] ctx||183] 
        suffix? [function! 1 [
                {Returns the suffix (extension) of a filename or url, or NONE if there is no suffix} 
                path [email! file! string! url!]
            ] #[none]] 
        scan [function! 1 [
                {Returns the guessed type of the first serialized value from the input} 
                buffer [binary! string!] "Input UTF-8 buffer or string" 
                /next {Returns both the type and the input after the value} 
                /fast "Fast scanning, returns best guessed type" 
                return: [datatype! none!] "Recognized or guessed type, or NONE on empty input"
            ] [
                /next 1 0 
                /fast 2 0
            ]] 
        load [function! 1 [
                {Returns a value or block of values by reading and evaluating a source} 
                source [binary! file! string! url!] 
                /header "TBD" 
                /all {Load all values, returns a block. TBD: Don't evaluate Red header} 
                /trap "Load all values, returns [[values] position error]" 
                /next {Load the next value only, updates source series word} 
                position [word!] "Word updated with new series position" 
                /part "Limit to a length or position" 
                length [integer! string!] 
                /into {Put results in out block, instead of creating a new block} 
                out [block!] "Target block for results" 
                /as "Specify the type of data; use NONE to load as code" 
                type [none! word!] "E.g. bmp, gif, jpeg, png, redbin, json, csv" 
                /local codec suffix name mime pre-load err
            ] [
                /header 1 0 
                /all 2 0 
                /trap 3 0 
                /next 4 1 
                /part 5 1 
                /into 6 1 
                /as 7 1
            ]] 
        save [function! 2 [
                {Saves a value, block, or other data to a file, URL, binary, or string} 
                where [binary! file! none! string! url!] "Where to save" 
                value [any-type!] "Value(s) to save" 
                /header {Provide a Red header block (or output non-code datatypes)} 
                header-data [block! object!] 
                /all "TBD: Save in serialized format" 
                /length {Save the length of the script content in the header} 
                /as {Specify the format of data; use NONE to save as plain text} 
                format [none! word!] "E.g. bmp, gif, jpeg, png, redbin, json, csv" 
                /local dst codec data suffix find-encoder? name only pos header-str k v
            ] [
                /header 1 1 
                /all 2 0 
                /length 3 0 
                /as 4 1
            ]] 
        cause-error [function! 3 [
                {Causes an immediate error throw, with the provided information} 
                err-type [word!] 
                err-id [word!] 
                args [block! string!]
            ] #[none]] 
        pad [function! 2 [
                "Pad a FORMed value on right side with spaces" 
                str "Value to pad, FORM it if not a string" 
                n [integer!] "Total size (in characters) of the new string" 
                /left "Pad the string on left side" 
                /with "Pad with char" 
                c [char!] 
                return: [string!] "Modified input string at head"
            ] [
                /left 1 0 
                /with 2 1
            ]] 
        mod [function! 2 [
                "Compute a nonnegative remainder of A divided by B" 
                a [char! money! number! pair! time! tuple! vector!] 
                b [char! money! number! pair! time! tuple! vector!] "Must be nonzero" 
                return: [number! money! char! pair! tuple! vector! time!] 
                /local r
            ] #[none]] 
        modulo [function! 2 [
                {Wrapper for MOD that handles errors like REMAINDER. Negligible values (compared to A and B) are rounded to zero} 
                a [char! money! number! pair! time! tuple! vector!] 
                b [char! money! number! pair! time! tuple! vector!] 
                return: [number! money! char! pair! tuple! vector! time!] 
                /local r
            ] #[none]] 
        eval-set-path [function! 1 ["Internal Use Only" value1] #[none]] 
        to-red-file [function! 1 [
                {Converts a local system file path to a Red file path} 
                path [file! string!] 
                return: [file!] 
                /local colon? slash? len i c dst
            ] #[none]] 
        dir? [function! 1 [{Returns TRUE if the value looks like a directory spec} file [file! url!]] #[none]] 
        normalize-dir [function! 1 [
                "Returns an absolute directory spec" 
                dir [file! path! word!]
            ] #[none]] 
        what-dir [function! 0 [
                "Returns the active directory path" 
                /local path
            ] #[none]] 
        change-dir [function! 1 [
                "Changes the active directory path" 
                dir [file! path! word!] {New active directory of relative path to the new one}
            ] #[none]] 
        make-dir [function! 1 [
                {Creates the specified directory. No error if already exists} 
                path [file!] 
                /deep "Create subdirectories too" 
                /local dirs end created dir
            ] [
                /deep 1 0
            ]] 
        extract [function! 2 [
                {Extracts a value from a series at regular intervals} 
                series [series!] 
                width [integer!] "Size of each entry (the skip)" 
                /index "Extract from an offset position" 
                pos [integer!] "The position" 
                /into {Provide an output series instead of creating a new one} 
                output [series!] "Output series"
            ] [
                /index 1 1 
                /into 2 1
            ]] 
        extract-boot-args [function! 0 [
                {Process command-line arguments and store values in system/options (internal usage)} 
                /local args at-arg2 ws buf s
            ] #[none]] 
        collect [function! 1 [
                {Collect in a new block all the values passed to KEEP function from the body block} 
                body [block!] "Block to evaluate" 
                /into {Insert into a buffer instead (returns position after insert)} 
                collected [series!] "The buffer series (modified)" 
                /local keep rule pos
            ] [
                /into 1 1
            ]] 
        flip-exe-flag [function! 1 [
                {Flip the sub-system for the red.exe between console and GUI modes (Windows only)} 
                path [file!] "Path to the red.exe" 
                /local file buffer flag
            ] #[none]] 
        split [function! 2 [
                {Break a string series into pieces using the provided delimiters} 
                series [any-string!] dlm [bitset! char! string!] /local s 
                num
            ] #[none]] 
        dirize [function! 1 [
                "Returns a copy of the path turned into a directory" 
                path [file! string! url!]
            ] #[none]] 
        clean-path [function! 1 [
                [no-trace] 
                {Cleans-up '.' and '..' in path; returns the cleaned path} 
                file [file! string! url!] 
                /only "Do not prepend current directory" 
                /dir "Add a trailing / if missing" 
                /local out cnt f not-file? prot
            ] [
                /only 1 0 
                /dir 2 0
            ]] 
        split-path [function! 1 [
                [no-trace] 
                {Splits a file or URL path. Returns a block containing path and target} 
                target [file! url!] 
                /local dir pos
            ] #[none]] 
        do-file [function! 3 [
                "Internal Use Only" file [file! url!] callback [function! none!] do-args 
                /local ws saved src code header? header list c done? found? obj 
                parent path args
            ] #[none]] 
        path-thru [function! 1 [
                "Returns the local disk cache path of a remote file" 
                url [url!] "Remote file address" 
                return: [file!] 
                /local so hash file path
            ] #[none]] 
        exists-thru? [function! 1 [
                {Returns true if the remote file is present in the local disk cache} 
                url [file! url!] "Remote file address"
            ] #[none]] 
        read-thru [function! 1 [
                "Reads a remote file through local disk cache" 
                url [url!] "Remote file address" 
                /update "Force a cache update" 
                /binary "Use binary mode" 
                /local path data
            ] [
                /update 1 0 
                /binary 2 0
            ]] 
        load-thru [function! 1 [
                "Loads a remote file through local disk cache" 
                url [url!] "Remote file address" 
                /update "Force a cache update" 
                /as "Specify the type of data; use NONE to load as code" 
                type [none! word!] "E.g. bmp, gif, jpeg, png" 
                /local path file
            ] [
                /update 1 0 
                /as 2 1
            ]] 
        do-thru [function! 1 [
                {Evaluates a remote Red script through local disk cache} 
                url [url!] "Remote file address" 
                /update "Force a cache update"
            ] [
                /update 1 0
            ]] 
        cos [function! 1 [
                "Returns the trigonometric cosine" 
                angle [float!] "Angle in radians"
            ] #[none]] 
        sin [function! 1 [
                "Returns the trigonometric sine" 
                angle [float!] "Angle in radians"
            ] #[none]] 
        tan [function! 1 [
                "Returns the trigonometric tangent" 
                angle [float!] "Angle in radians"
            ] #[none]] 
        acos [function! 1 [
                {Returns the trigonometric arccosine in radians in range [0,pi]} 
                cosine [float!] "in range [-1,1]"
            ] #[none]] 
        asin [function! 1 [
                {Returns the trigonometric arcsine in radians in range [-pi/2,pi/2])} 
                sine [float!] "in range [-1,1]"
            ] #[none]] 
        atan [function! 1 [
                {Returns the trigonometric arctangent in radians in range [-pi/2,+pi/2]} 
                tangent [float!] "in range [-inf,+inf]"
            ] #[none]] 
        atan2 [function! 2 [
                {Returns the smallest angle between the vectors (1,0) and (x,y) in range (-pi,pi]} 
                y [float! integer!] 
                x [float! integer!] 
                return: [float!]
            ] #[none]] 
        sqrt [function! 1 [
                "Returns the square root of a number" 
                number [float! integer! percent!] 
                return: [float!]
            ] #[none]] 
        to-UTC-date [function! 1 [
                "Returns the date with UTC zone" 
                date [date!] 
                return: [date!]
            ] #[none]] 
        to-local-date [function! 1 [
                "Returns the date with local zone" 
                date [date!] 
                return: [date!]
            ] #[none]] 
        show-memory-stats [function! 1 [data [block!] 
                /local class used total i c frm unit
            ] #[none]] 
        transcode-trace [function! 1 [
                {Shortcut function for transcoding while tracing all lexer events} 
                src [binary! string!]
            ] #[none]] 
        rejoin [function! 1 [
                "Reduces and joins a block of values." 
                block [block!] "Values to reduce and join"
            ] #[none]] 
        sum [function! 1 [
                "Returns the sum of all values in a block" 
                values [block! hash! paren! vector!] 
                /local result value
            ] #[none]] 
        average [function! 1 [
                "Returns the average of all values in a block" 
                block [block! hash! paren! vector!]
            ] #[none]] 
        last? [function! 1 [
                "Returns TRUE if the series length is 1" 
                series [series!]
            ] #[none]] 
        dt [function! 1 [
                "Returns the time required to evaluate a block" 
                body [block!] 
                return: [time!] 
                /local t0
            ] #[none]] 
        time-it [function! 1 [
                "Returns the time required to evaluate a block" 
                body [block!] 
                return: [time!] 
                /local t0
            ] #[none]] 
        clock [function! 1 [
                {Display execution time of code, returning result of it's evaluation} 
                code [block!] 
                /times n [float! integer!] 
                {Repeat N times (default: once); displayed time is per iteration} 
                /local result 
                text dt unit
            ] [
                /times 1 1
            ]] 
        single? [function! 1 [
                "Returns TRUE if the series length is 1" 
                series [series!]
            ] #[none]] 
        keys-of [function! 1 [{Returns the list of words of a value that supports reflection} value] #[none]] 
        object [function! 1 [
                "Makes a new object from an evaluated spec" 
                spec [block!]
            ] #[none]] 
        halt [function! 0 [
                "Stops evaluation and exits the program" 
                /return status [integer!] "Return an exit status"
            ] [
                /return 1 1
            ]] 
        ctx||264~interpreted? [function! 0 ["Return TRUE if called from the interpreter"] #[none]] 
        ctx||267~on-change* [function! 3 [word old new 
                /local idx
            ] #[none]] 
        ctx||270~active? [routine! 0 [return: #[block![2 619x1 logic!]3]] #[none]] 
        ctx||270~series-cycles [routine! 0 [return: #[block![2 619x1 integer!]3]] #[none]] 
        ctx||270~nodes-cycles [routine! 0 [return: #[block![2 619x1 integer!]3]] #[none]] 
        ctx||276~on-change* [function! 3 [word old new] #[none]] 
        ctx||276~on-deep-change* [function! 7 [owner word target action new index part] #[none]] 
        ctx||282~on-change* [function! 3 [word old new] #[none]] 
        ctx||280~on-change* [function! 3 [word old new] #[none]] 
        ctx||280~on-deep-change* [function! 7 [owner word target action new index part] #[none]] 
        ctx||312~trapper [function! 5 [
                event [word!] 
                input [binary! string!] 
                type [datatype! none! word!] 
                line [integer!] 
                token 
                return: [logic!]
            ] #[none]] 
        ctx||312~tracer [function! 5 [
                event [word!] 
                input [binary! string!] 
                type [datatype! none! word!] 
                line [integer!] 
                token 
                return: [logic!]
            ] #[none]] 
        + [op! 2 ["Returns the sum of the two values" value1 [scalar! vector!] "The augend" value2 [scalar! vector!] "The addend" return: [scalar! vector!] "The sum"] #[none]] 
        - [op! 2 ["Returns the difference between two values" value1 [scalar! vector!] "The minuend" value2 [scalar! vector!] "The subtrahend" return: [scalar! vector!] "The difference"] #[none]] 
        * [op! 2 ["Returns the product of two values" value1 [number! money! char! pair! tuple! vector! time! any-point!] "The multiplicand" value2 [number! money! char! pair! tuple! vector! time! any-point!] "The multiplier" return: [number! money! char! pair! tuple! vector! time! any-point!] "The product"] #[none]] 
        / [op! 2 ["Returns the quotient of two values" value1 [number! money! char! pair! tuple! vector! time! any-point!] "The dividend (numerator)" value2 [number! money! char! pair! tuple! vector! time! any-point!] "The divisor (denominator)" return: [number! money! char! pair! tuple! vector! time! any-point!] "The quotient"] #[none]] 
        // [op! 2 [
                {Wrapper for MOD that handles errors like REMAINDER. Negligible values (compared to A and B) are rounded to zero} 
                a [char! money! number! pair! time! tuple! vector!] 
                b [char! money! number! pair! time! tuple! vector!] 
                return: [number! money! char! pair! tuple! vector! time!] 
                /local r
            ] #[none]] 
        %"" [op! 2 [{Returns what is left over when one value is divided by another} value1 [number! money! char! pair! any-point! tuple! vector! time!] "The dividend (numerator)" value2 [number! money! char! pair! any-point! tuple! vector! time!] "The divisor (denominator)" return: [number! money! char! pair! any-point! tuple! vector! time!] "The remainder"] #[none]] 
        = [op! 2 ["Returns TRUE if two values are equal" value1 [any-type!] value2 [any-type!]] #[none]] 
        <> [op! 2 ["Returns TRUE if two values are not equal" value1 [any-type!] value2 [any-type!]] #[none]] 
        == [op! 2 [{Returns TRUE if two values are equal, and also the same datatype} value1 [any-type!] value2 [any-type!]] #[none]] 
        =? [op! 2 ["Returns TRUE if two values have the same identity" value1 [any-type!] value2 [any-type!]] #[none]] 
        < [op! 2 [{Returns TRUE if the first value is less than the second} value1 [any-type!] value2 [any-type!]] #[none]] 
        > [op! 2 [{Returns TRUE if the first value is greater than the second} value1 [any-type!] value2 [any-type!]] #[none]] 
        <= [op! 2 [{Returns TRUE if the first value is less than or equal to the second} value1 [any-type!] value2 [any-type!]] #[none]] 
        >= [op! 2 [{Returns TRUE if the first value is greater than or equal to the second} value1 [any-type!] value2 [any-type!]] #[none]] 
        << [op! 2 [data #[block![2 619x1 integer!]3] bits #[block![2 619x1 integer!]3]] #[none]] 
        >> [op! 2 ["Shift bits to the right" data #[block![2 619x1 integer!]3] bits #[block![2 619x1 integer!]3]] #[none]] 
        ">>>" [op! 2 ["Shift bits to the right (unsigned)" data #[block![2 619x1 integer!]3] bits #[block![2 619x1 integer!]3]] #[none]] 
        ** [op! 2 [{Returns a number raised to a given power (exponent)} number [number!] "Base value" exponent [integer! float!] "The power (index) to raise the base value by" return: [number!]] #[none]] 
        and [op! 2 ["Returns the first value ANDed with the second" value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!] value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!] return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]] #[none]] 
        or [op! 2 ["Returns the first value ORed with the second" value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!] value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!] return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]] #[none]] 
        xor [op! 2 [{Returns the first value exclusive ORed with the second} value1 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!] value2 [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!] return: [logic! integer! char! bitset! binary! typeset! pair! tuple! vector! any-point!]] #[none]] 
        ctx||316~encode [routine! 2 [img #[block![2 619x1 red-image!]3] where #[block![2 619x1 red/cell!]3]] #[none]] 
        ctx||316~decode [routine! 1 [data #[block![2 619x1 red/cell!]3]] #[none]] 
        ctx||319~encode [routine! 2 [img #[block![2 619x1 red-image!]3] where #[block![2 619x1 red/cell!]3]] #[none]] 
        ctx||319~decode [routine! 1 [data #[block![2 619x1 red/cell!]3]] #[none]] 
        ctx||322~encode [routine! 2 [img #[block![2 619x1 red-image!]3] where #[block![2 619x1 red/cell!]3]] #[none]] 
        ctx||322~decode [routine! 1 [data #[block![2 619x1 red/cell!]3]] #[none]] 
        ctx||325~encode [routine! 2 [img #[block![2 619x1 red-image!]3] where #[block![2 619x1 red/cell!]3]] #[none]] 
        ctx||325~decode [routine! 1 [data #[block![2 619x1 red/cell!]3]] #[none]] 
        ctx||328~encode [function! 2 [data [any-type!] where [any-type!]] #[none]] 
        ctx||328~encode* [routine! 2 [data #[block![2 619x1 red/cell!]3] compact? #[block![2 619x1 logic!]3]] #[none]] 
        ctx||328~decode [routine! 1 [
                payload #[block![2 619x1 red/cell!]3] 
                /local 
                blk #[block![2 619x1 red-block!]3] 
                bin #[block![2 619x1 red-binary!]3]
            ] #[none]] 
        ctx||332~on-change* [function! 3 [word old new] #[none]] 
        ctx||335~on-change* [function! 3 [word old new] #[none]] 
        ctx||335~on-deep-change* [function! 7 [owner word target action new index part] #[none]] 
        reactor [function! 1 [spec [block!]] #[none]] 
        deep-reactor [function! 1 [spec [block!]] #[none]] 
        ctx||341~add-relation [function! 4 [
                obj [object!] 
                word 
                reaction [block! function!] 
                targets [block! none! object! set-word!] 
                /local new-rel
            ] #[none]] 
        ctx||341~identify-sources [function! 3 [path [any-path!] reaction ctx return: [logic!] /local obj 
                p found? slice
            ] #[none]] 
        ctx||341~eval [function! 1 [code [block!] /safe 
                /local result
            ] [/safe 1 0]] 
        ctx||341~eval-reaction [function! 3 [reactor [object!] reaction [block! function!] target /mark] [/mark 1 0]] 
        ctx||341~pending? [function! 2 [reactor [object!] reaction [block! function!] 
                /local q
            ] #[none]] 
        ctx||341~check [function! 1 [reactor [object!] /only field [set-word! word!] 
                /local pos reaction q q'
            ] [/only 1 1]] 
        no-react [function! 1 [
                {Evaluates a block with all previously defined reactions disabled} 
                body [block!] "Code block to evaluate" 
                /local result
            ] #[none] ctx||341] 
        stop-reactor [function! 1 [
                face [object!] 
                /deep 
                /local list pos f
            ] [
                /deep 1 0
            ] ctx||341] 
        clear-reactions [function! 0 ["Removes all reactive relations"] #[none] ctx||341] 
        dump-reactions [function! 0 [
                {Outputs all the current reactive relations for debugging purpose} 
                /local limit count obj field reaction target list
            ] #[none] ctx||341] 
        relate [function! 2 [
                {Defines a reactive relation whose result is assigned to a word} 
                'field [set-word!] {Set-word which will get set to the result of the reaction} 
                reaction [block!] "Reactive relation" 
                /local obj rule item
            ] #[none] ctx||341] 
        is [function! 0 [] #[none] ctx||341] 
        react? [function! 2 [
                {Returns a reactive relation if an object's field is a reactive source} 
                reactor [object!] "Object to check" 
                field [word!] "Field to check" 
                /target {Check if it's a target of an `is` reaction instead of a source} 
                return: [block! function! word! none!] "Returns reaction, type or NONE" 
                /local pos
            ] [
                /target 1 0
            ] ctx||341] 
        react [function! 1 [
                {Defines a new reactive relation between two or more objects} 
                reaction [block! function!] "Reactive relation" 
                /link "Link objects together using a reactive relation" 
                objects [block!] "Objects to link together" 
                /unlink "Removes an existing reactive relation" 
                src [block! object! word!] "'all word, or a reactor or a list of reactors" 
                /later "Run the reaction on next change instead of now" 
                /with "Specifies an optional face object (internal use)" 
                ctx [none! object! set-word!] "Optional context for VID faces or target set-word" 
                return: [block! function! none!] {The reactive relation or NONE if no relation was processed} 
                /local objs found? rule item pos obj
            ] [
                /link 1 1 
                /unlink 2 1 
                /later 3 0 
                /with 4 1
            ] ctx||341] 
        register-scheme [function! 1 [
                "Registers a new scheme" 
                spec [object!] "Scheme definition" 
                /native 
                dispatch [handle!]
            ] [
                /native 1 1
            ]] 
        ctx||358~alpha-num+ [function! 1 [more [string!]] #[none]] 
        ctx||358~parse-url [function! 1 [
                {Return object with URL components, or cause an error if not a valid URL} 
                url [string! url!] 
                /throw-error "Throw an error, instead of returning NONE." 
                /local scheme user-info host port path target query fragment ref
            ] [
                /throw-error 1 0
            ]] 
        decode-url [function! 1 [
                {Decode a URL into an object containing its constituent parts} 
                url [string! url!]
            ] #[none] ctx||358] 
        encode-url [function! 1 [url-obj [object!] "What you'd get from decode-url" 
                /local result
            ] #[none] ctx||358] 
        ctx||364~do-quit [function! 0 [] #[none]] 
        ctx||364~throw-error [function! 3 [error [error!] cmd [issue!] code [block!] /local w] #[none]] 
        ctx||364~syntax-error [function! 2 [s [block! paren!] e [block! paren!]] #[none]] 
        ctx||364~do-safe [function! 1 [code [block! paren!] /manual /with cmd [issue!] /local res t? src] [/manual 1 0 /with 2 1]] 
        ctx||364~do-code [function! 2 [code [block! paren!] cmd [issue!] /local p] #[none]] 
        ctx||364~rebind-all [function! 0 [/local rule p] #[none]] 
        ctx||364~count-args [function! 1 [spec [block!] /block /local total pos] [/block 1 0]] 
        ctx||364~arg-mode? [function! 2 [spec [block!] idx [integer!]] #[none]] 
        ctx||364~func-arity? [function! 1 [spec [block!] /with path [path!] /block /local arity pos] [/with 1 1 /block 2 0]] 
        ctx||364~value-path? [function! 1 [path [path!] /local value i item selectable] #[none]] 
        ctx||364~fetch-next [function! 1 [code [block! paren!] /local i left item item2 value fn-spec path f-arity at-op? op-mode] #[none]] 
        ctx||364~eval [function! 2 [code [block! paren!] cmd [issue!] /local after expr] #[none]] 
        ctx||364~do-macro [function! 3 [name pos [block! paren!] arity [integer!] /local cmd saved p v res] #[none]] 
        ctx||364~register-macro [function! 1 [spec [block!] /local cnt rule p name macro pos valid? named?] #[none]] 
        ctx||364~reset [function! 1 [job [none! object!]] #[none]] 
        ctx||364~expand [function! 2 [
                code [block! paren!] job [none! object!] 
                /clean 
                /local rule e pos cond value then else cases body keep? expr src saved file new
            ] [
                /clean 1 0
            ]] 
        expand-directives [function! 1 [
                {Invokes the preprocessor on argument list, modifying and returning it} 
                code [block! paren!] "List of Red values to preprocess" 
                /clean "Clear all previously created macros and words" 
                /local job saved
            ] [
                /clean 1 0
            ] ctx||364] 
        ctx||383~calc-max [function! 1 [used [integer!] return: [integer!]] #[none]] 
        ctx||383~show-context [function! 1 [ctx [function! object!] 
                /local w out
            ] #[none]] 
        ctx||383~show-parents [function! 1 [event [word!] 
                /local list w pos
            ] #[none]] 
        ctx||383~show-stack [function! 0 [
                /local indent frame
            ] #[none]] 
        ctx||383~show-watching [function! 0 [
                /local w out
            ] #[none]] 
        ctx||383~do-command [function! 1 [event [word!] 
                /local watch list w cmd add?
            ] #[none]] 
        ctx||383~debugger [function! 6 [
                event [word!] 
                code [any-block! none!] 
                offset [integer!] 
                value [any-type!] 
                ref [any-type!] 
                frame [pair!] 
                /local store idx pos indent sch out set-ref limit
            ] #[none]] 
        ctx||400~emit [native! 1 ["Outputs a value followed by a newline" value [any-type!]] #[none]] 
        ctx||400~mold-part [function! 2 [value [any-type!] part [integer!] /only 
                /local r open close
            ] [/only 1 0]] 
        ctx||400~dumper [function! 6 [
                event [word!] 
                code [any-block! none!] 
                offset [integer!] 
                value [any-type!] 
                ref [any-type!] 
                frame [pair!]
            ] #[none]] 
        ctx||400~push [function! 2 [s [series!] i [any-type!] /dup n [integer!]] [/dup 1 1]] 
        ctx||400~drop [function! 2 [s [series!] n [integer!]] #[none]] 
        ctx||400~pop [function! 1 [s [series!]] #[none]] 
        ctx||400~top-of [function! 1 [s [series!]] #[none]] 
        ctx||400~step [function! 1 [s [series!] /down] [/down 1 0]] 
        ctx||409~put [function! 1 [block [block!]] #[none]] 
        ctx||409~get [function! 0 [] #[none]] 
        ctx||413~save-level [function! 1 ["Save current nesting level on the stack" frame [pair!] 
                /local word value
            ] #[none]] 
        ctx||413~unroll-level [function! 0 ["Unroll last nesting level from the stack" 
                /local i n value word
            ] #[none]] 
        ctx||413~reset [function! 0 ["Reset collector's data" 
                /local block-name
            ] #[none]] 
        ctx||413~collector [function! 6 [
                {Generic tracer that collects high-level tracing info} 
                event [word!] 
                code [default!] 
                offset [integer!] 
                value [any-type!] 
                ref [any-type!] 
                frame [pair!] 
                /local call saved-frame isop? bgn word
            ] #[none]] 
        ctx||400~guided-trace [function! 5 [
                {Trace a block of code, providing 'inspect' tracer with collected data} 
                inspect [function!] {func [data [object!] event code offset value ref frame]} 
                code [any-type!] 
                all? [logic!] "Trace all sub-expressions of each expression" 
                deep? [logic!] "Enter functions and natives" 
                debug? [logic!] "Dump all events encountered" 
                /local b rule
            ] #[none]] 
        ctx||420~inspect [function! 6 [
                data [object!] 
                event [word!] 
                code [default!] 
                offset [integer!] 
                value [any-type!] 
                ref [any-type!] 
                /local word 
                report? full width left right indent indent2 level expr path p pexpr orig-expr name
            ] #[none]] 
        ctx||383~profiler [function! 6 [
                event [word!] 
                code [any-block! none!] 
                offset [integer!] 
                value [any-type!] 
                ref [any-type!] 
                frame [pair!] 
                /local anon time opt pos entry
            ] #[none]] 
        ctx||383~do-handler [function! 2 [code [any-type!] handler [function!]] #[none]] 
        profile [function! 1 [
                {Profile the argument code, counting calls and their cumulative duration, then print a report} 
                code [any-type!] "Code to profile" 
                /by 
                cat [word!] "Sort by: 'name, 'count, 'time" 
                /local saved rank name cnt duration
            ] [
                /by 1 1
            ] ctx||383] 
        trace [function! 1 [
                {Runs argument code and prints an evaluation trace; also turns on/off tracing} 
                code [any-type!] "Code to trace or tracing mode (logic!)" 
                /raw {Switch to raw interpreter events tracing (incompatible with other modes)} 
                /deep "Trace into functions and natives" 
                /all "Trace all sub-expressions of each expression" 
                /debug {Used internally to debug the tracer itself (outputs all events)}
            ] [
                /raw 1 0 
                /deep 2 0 
                /all 3 0 
                /debug 4 0
            ] ctx||383] 
        debug [function! 1 [
                "Runs argument code through an interactive debugger" 
                code [any-type!] "Code to debug" 
                /later {Enters the interactive debugger later, on reading @stop value}
            ] [
                /later 1 0
            ] ctx||383] 
        hex-to-rgb [function! 1 [
                {Converts a color in hex format to a tuple value; returns NONE if it fails} 
                hex [issue!] "Accepts #rgb, #rrggbb, #rrggbbaa" 
                return: [tuple! none!] 
                /local str bin
            ] #[none]] 
        within? [function! 3 [
                {Return TRUE if the point is within the rectangle bounds} 
                point [planar!] "XY position" 
                offset [planar!] "Offset of area" 
                size [planar!] "Size of area" 
                return: [logic!]
            ] #[none]] 
        overlap? [function! 2 [
                {Return TRUE if the two faces bounding boxes are overlapping} 
                A [object!] "First face" 
                B [object!] "Second face" 
                return: [logic!] "TRUE if overlapping" 
                /local A1 B1 A2 B2
            ] #[none]] 
        distance? [function! 2 [
                {Returns the distance between 2 points or face centers} 
                A [object! planar!] "First face or point" 
                B [object! planar!] "Second face or point" 
                return: [float!] "Distance between them" 
                /local d
            ] #[none]] 
        event? [routine! 1 [value #[block![2 436x1 red/cell!]3] return: #[block![2 436x1 logic!]3]] #[none]] 
        send-event-os [routine! 2 [event #[block![2 436x1 red-event!]3] queued? #[block![2 436x1 logic!]3] return: #[block![2 436x1 logic!]3]] #[none]] 
        send-event [function! 1 [
                event [event!] 
                /no-wait 
                return: [logic!]
            ] [
                /no-wait 1 0
            ]] 
        face? [function! 1 [
                value 
                return: [logic!]
            ] #[none]] 
        get-current-screen [function! 0 [
                return: [object!] 
                /local handle screen
            ] #[none]] 
        size-text [function! 1 [
                face [object!] 
                /with 
                text [string!] 
                return: [point2D! none!] 
                /local h
            ] [
                /with 1 1
            ]] 
        caret-to-offset [function! 2 [
                face [object!] 
                pos [integer!] 
                /lower 
                return: [point2D!] 
                /local opt
            ] [
                /lower 1 0
            ]] 
        offset-to-caret [function! 2 [
                face [object!] 
                pt [planar!] 
                return: [integer!]
            ] #[none]] 
        offset-to-char [function! 2 [
                face [object!] 
                pt [planar!] 
                return: [integer!]
            ] #[none]] 
        ctx||441~tail-idx? [function! 0 [] #[none]] 
        ctx||441~push-color [function! 1 [c [tuple!]] #[none]] 
        ctx||441~pop-color [function! 0 [/local entry pos] #[none]] 
        ctx||441~close-colors [function! 0 [/local pos] #[none]] 
        ctx||441~push [function! 1 [style [block! word!]] #[none]] 
        ctx||441~pop [function! 1 [style [word!] 
                /local entry type
            ] #[none]] 
        ctx||441~pop-all [function! 1 [mark [block!] 
                /local first? i
            ] #[none]] 
        ctx||441~optimize [function! 0 [
                /local cur pos range pos1 e s l mov
            ] #[none]] 
        rtd-layout [function! 1 [
                "Returns a rich-text face from a RTD source code" 
                spec [block!] "RTD source code" 
                /only "Returns only [text data] facets" 
                /with "Populate an existing face object" 
                face [object!] "Face object to populate" 
                return: [object! block!]
            ] [
                /only 1 0 
                /with 2 1
            ] ctx||441] 
        ctx||439~line-height? [function! 2 [
                face [object!] 
                pos [integer!] 
                return: [float!]
            ] #[none]] 
        ctx||439~line-count? [function! 1 [
                face [object!] 
                return: [integer!]
            ] #[none]] 
        metrics? [function! 2 [
                face [object!] 
                type [word!] 
                /total 
                axis [word!] 
                /local res
            ] [
                /total 1 1
            ]] 
        set-flag [function! 2 [
                face [object!] 
                flag [any-type!] 
                /clear 
                /toggle 
                /local flags pos
            ] [
                /clear 1 0 
                /toggle 2 0
            ]] 
        find-flag? [routine! 2 [
                facet #[block![2 436x1 red/cell!]3] 
                flag #[block![2 436x1 red-word!]3] 
                /local 
                word #[block![2 436x1 red-word!]3] 
                value #[block![2 436x1 red/cell!]3] 
                tail #[block![2 436x1 red/cell!]3] 
                bool #[block![2 436x1 red-logic!]3] 
                type #[block![2 436x1 integer!]3] 
                found? #[block![2 436x1 logic!]3]
            ] #[none]] 
        debug-info? [function! 1 [face [object!] return: [logic!]] #[none]] 
        on-face-deep-change* [function! 9 [owner word target action new index part state forced? 
                /local w diff? faces face modal? screen pane
            ] #[none]] 
        link-tabs-to-parent [function! 1 [
                face [object!] 
                /init 
                /local faces visible?
            ] [
                /init 1 0
            ]] 
        link-sub-to-parent [function! 4 [face [object!] type [word!] old new 
                /local parent found
            ] #[none]] 
        update-font-faces [function! 1 [parent [block! none!] 
                /local f
            ] #[none]] 
        ctx||461~on-change* [function! 3 [word old new 
                /local same-pane? f new-type saved value
            ] #[none]] 
        ctx||461~on-deep-change* [function! 7 [owner word target action new index part] #[none]] 
        ctx||465~on-change* [function! 3 [word old new] #[none]] 
        ctx||465~on-deep-change* [function! 7 [owner word target action new index part] #[none]] 
        ctx||469~on-change* [function! 3 [word old new 
                /local f
            ] #[none]] 
        ctx||472~on-change* [function! 3 [word old new] #[none]] 
        ctx||475~capture-events [function! 2 [face [object!] event [event!] /local result] #[none]] 
        ctx||475~awake [function! 1 [event [event!] /with face /local result result2 
                name handler screen pos
            ] [/with 1 1]] 
        ctx||475~on-change* [function! 3 [word old new 
                /local screen wins win
            ] #[none]] 
        ctx||484~make-null-handle [routine! 0 [] #[none]] 
        ctx||484~fetch-all-screens [routine! 0 [] #[none]] 
        ctx||484~get-current-screen [routine! 0 [] #[none]] 
        ctx||484~all-windows-closed? [function! 0 [return: [logic!] /local closed? [logic!]] #[none]] 
        ctx||484~refresh-screens [function! 0 [/local svs spec screen] #[none]] 
        ctx||484~get-screen-size [routine! 1 [
                id #[block![2 3356x1 integer!]3] 
                /local 
                pair #[block![2 3356x1 red-pair!]3]
            ] #[none]] 
        ctx||484~size-text [routine! 2 [
                face #[block![2 3356x1 red-object!]3] 
                value #[block![2 3356x1 red/cell!]3] 
                /local 
                values #[block![2 3356x1 red/cell!]3] 
                text #[block![2 3356x1 red-string!]3] 
                pt #[block![2 3356x1 red-point2D!]3]
            ] #[none]] 
        ctx||484~on-change-facet [routine! 7 [
                owner #[block![2 3356x1 red-object!]3] 
                word #[block![2 3356x1 red-word!]3] 
                value #[block![2 3356x1 red/cell!]3] 
                action #[block![2 3356x1 red-word!]3] 
                new #[block![2 3356x1 red/cell!]3] 
                index #[block![2 3356x1 integer!]3] 
                part #[block![2 3356x1 integer!]3]
            ] #[none]] 
        ctx||484~update-text [routine! 1 [face #[block![2 3356x1 red-object!]3]] #[none]] 
        ctx||484~update-font [routine! 2 [font #[block![2 3356x1 red-object!]3] flags #[block![2 3356x1 integer!]3]] #[none]] 
        ctx||484~update-para [routine! 2 [face #[block![2 3356x1 red-object!]3] flags #[block![2 3356x1 integer!]3]] #[none]] 
        ctx||484~destroy-view [routine! 2 [face #[block![2 3356x1 red-object!]3] empty? #[block![2 3356x1 logic!]3]] #[none]] 
        ctx||484~detach-image [routine! 1 [img #[block![2 3356x1 red-image!]3]] #[none]] 
        ctx||484~update-view [routine! 1 [
                face #[block![2 3356x1 red-object!]3] 
                /local 
                word #[block![2 3356x1 red-word!]3]
            ] #[none]] 
        ctx||484~refresh-window [routine! 1 [h #[block![2 3356x1 red-handle!]3]] #[none]] 
        ctx||484~redraw [routine! 1 [face #[block![2 3356x1 red-object!]3] /local h #[block![2 3356x1 integer!]3]] #[none]] 
        ctx||484~show-window [routine! 1 [id #[block![2 3356x1 red-handle!]3]] #[none]] 
        ctx||484~make-view [routine! 2 [face #[block![2 3356x1 red-object!]3] parent #[block![2 3356x1 red-handle!]3]] #[none]] 
        ctx||484~draw-image [routine! 2 [image #[block![2 3356x1 red-image!]3] cmds #[block![2 3356x1 red-block!]3]] #[none]] 
        ctx||484~draw-face [routine! 2 [face #[block![2 3356x1 red-object!]3] cmds #[block![2 3356x1 red-block!]3] /local h #[block![2 3356x1 pointer! #[block![2 3356x1 integer!]3]]3] flags #[block![2 3356x1 integer!]3]] #[none]] 
        ctx||484~do-event-loop [routine! 1 [no-wait? #[block![2 3356x1 logic!]3] /local bool #[block![2 3356x1 red-logic!]3]] #[none]] 
        ctx||484~exit-event-loop [routine! 0 [] #[none]] 
        ctx||484~request-font [routine! 3 [font #[block![2 3356x1 red-object!]3] selected #[block![2 3356x1 red/cell!]3] mono? #[block![2 3356x1 logic!]3]] #[none]] 
        ctx||484~request-file [routine! 5 [
                title #[block![2 3356x1 red/cell!]3] 
                name #[block![2 3356x1 red/cell!]3] 
                filter #[block![2 3356x1 red/cell!]3] 
                save? #[block![2 3356x1 logic!]3] 
                multi? #[block![2 3356x1 logic!]3]
            ] #[none]] 
        ctx||484~request-dir [routine! 5 [
                title #[block![2 3356x1 red/cell!]3] 
                dir #[block![2 3356x1 red/cell!]3] 
                filter #[block![2 3356x1 red/cell!]3] 
                keep? #[block![2 3356x1 logic!]3] 
                multi? #[block![2 3356x1 logic!]3]
            ] #[none]] 
        ctx||484~text-box-metrics [routine! 3 [
                box #[block![2 3356x1 red-object!]3] 
                arg0 #[block![2 3356x1 red/cell!]3] 
                type #[block![2 3356x1 integer!]3] 
                /local 
                state #[block![2 3356x1 red-block!]3] 
                bool #[block![2 3356x1 red-logic!]3] 
                values #[block![2 3356x1 red/cell!]3] 
                txt #[block![2 3356x1 red-string!]3] 
                word #[block![2 3356x1 red-word!]3] 
                sym #[block![2 3356x1 integer!]3] 
                layout? #[block![2 3356x1 logic!]3]
            ] #[none]] 
        ctx||484~update-scroller [routine! 2 [scroller #[block![2 3356x1 red-object!]3] flags #[block![2 3356x1 integer!]3]] #[none]] 
        ctx||484~set-dark-mode [routine! 2 [face #[block![2 3356x1 red-object!]3] dark? #[block![2 3356x1 logic!]3] /local word #[block![2 3356x1 red-word!]3]] #[none]] 
        ctx||484~support-dark-mode? [routine! 0 [return: #[block![2 3356x1 logic!]3]] #[none]] 
        ctx||484~toggle-GPU [routine! 0 [] #[none]] 
        ctx||484~init [function! 0 [/local svs colors fonts] #[none]] 
        draw [function! 2 [
                "Draws scalable vector graphics to an image" 
                image [image! pair!] "Image or size for an image" 
                cmd [block!] "Draw commands" 
                /transparent "Make a transparent image, if pair! spec is used" 
                return: [image!]
            ] [
                /transparent 1 0
            ]] 
        ctx||494~count-faces [function! 2 [parent [object!] type [block! word!] 
                /local cnt f
            ] #[none]] 
        ctx||494~Cancel-OK [function! 1 [
                "Put OK buttons last" 
                root [object!] 
                /local pos-x last-but pos-y f
            ] #[none]] 
        ctx||492~process [function! 1 [root [object!] 
                /local list name
            ] #[none]] 
        ctx||490~throw-error [function! 1 [spec [block!]] #[none]] 
        ctx||490~process-reactors [function! 1 [reactors [block!] /local res 
                f blk later? ctx face
            ] #[none]] 
        ctx||490~opt-as-integer [function! 1 [value [float! integer!] 
                /local i
            ] #[none]] 
        ctx||490~calc-size [function! 1 [face [object!] 
                /local min-sz data txt s len mark e new
            ] #[none]] 
        ctx||490~align-faces [function! 4 [pane [block!] dir [word!] align [word!] max-sz [float! integer!] 
                /local edge? top-left? axis svmm face offset mar type
            ] #[none]] 
        ctx||490~resize-child-panels [function! 1 [tab [object!] 
                /local tp-size pad pane
            ] #[none]] 
        ctx||490~clean-style [function! 2 [tmpl [block!] type [word!] /local para font] #[none]] 
        ctx||490~process-draw [function! 1 [code [block!] 
                /local rule pos color
            ] #[none]] 
        ctx||490~pre-load [function! 1 [value 
                /local color
            ] #[none]] 
        ctx||490~preset-focus [function! 1 [face [object!] 
                /local p
            ] #[none]] 
        ctx||490~add-option [function! 2 [opts [object!] spec [block!] 
                /local field value
            ] #[none]] 
        ctx||490~add-flag [function! 4 [obj [object!] facet [word!] field [word!] flag return: [logic!] 
                /local blk
            ] #[none]] 
        ctx||490~add-bounds [function! 2 [proto [object!] spec [block!]] #[none]] 
        ctx||490~fetch-value [function! 1 [blk 
                /local value
            ] #[none]] 
        ctx||490~fetch-argument [function! 2 [expected [datatype! typeset!] 'pos [word!] 
                /local spec type value
            ] #[none]] 
        ctx||490~fetch-expr [function! 1 [code [word!]] #[none]] 
        ctx||490~fetch-options [function! 7 [
                face [object!] opts [object!] style [block!] spec [block!] css [block!] reactors [block!] styling? [logic!] 
                /no-skip 
                /tight 
                return: [block!] 
                /local opt? divides calc-y? do-with scaling obj-spec! sel-spec! rate! color! cursor! value match? drag-on default hint cursor tight? later? max-sz p words user-size? oi x font face-font field actors name f s b pad sz min-sz new mar
            ] [
                /no-skip 1 0 
                /tight 2 0
            ]] 
        ctx||490~make-actor [function! 4 [obj [object!] name [word!] body spec [block!]] #[none]] 
        layout [function! 1 [
                [no-trace] 
                {Return a face with a pane built from a VID description} 
                spec [block!] "Dialect block of styles, attributes, and layouts" 
                /tight "Zero offset and origin" 
                /options 
                user-opts [block!] "Optional features in [name: value] format" 
                /flags 
                flgs [block! word!] "One or more window flags" 
                /only "Returns only the pane block" 
                /parent 
                panel [object!] 
                divides [integer! none!] 
                /styles "Use an existing styles list" 
                css [block!] "Styles list" 
                /local axis anti 
                background! list reactors local-styles pane-size direction align begin size max-sz current global? below? origin spacing top-left bound cursor opts opt-words re-align sz words reset focal-face svmp pad value anti2 at-offset later? name styling? style styled? st actors face h pos styled w blk vid-align prev mar divide? index dir pad2 image
            ] [
                /tight 1 0 
                /options 2 1 
                /flags 3 1 
                /only 4 0 
                /parent 5 2 
                /styles 6 1
            ] ctx||490] 
        do-events [function! 0 [
                /no-wait 
                return: [logic! word!] 
                /local result screen win
            ] [
                /no-wait 1 0
            ]] 
        stop-events [function! 0 [] #[none]] 
        do-safe [function! 1 [code [block!] /local result error] #[none]] 
        do-actor [function! 3 [face [object!] event [event! none!] type [word!] /local result 
                act name
            ] #[none]] 
        show [function! 1 [
                face [block! object!] 
                /with 
                parent [object!] 
                /force 
                return: [logic!] 
                /local show? f pending owner word target action new index part state handle new? p field pane
            ] [
                /with 1 1 
                /force 2 0
            ]] 
        unview [function! 0 [
                /all 
                /only 
                face [object!] 
                /local all? svs pane
            ] [
                /all 1 0 
                /only 2 1
            ]] 
        view [function! 1 [
                spec [block! object!] 
                /tight 
                /options 
                opts [block!] 
                /flags 
                flgs [block! word!] 
                /no-wait 
                /no-sync 
                /local sync? result
            ] [
                /tight 1 0 
                /options 2 1 
                /flags 3 1 
                /no-wait 4 0 
                /no-sync 5 0
            ]] 
        center-face [function! 1 [
                face [object!] 
                /x 
                /y 
                /with 
                parent [object!] 
                return: [object!] 
                /local pos
            ] [
                /x 1 0 
                /y 2 0 
                /with 3 1
            ]] 
        make-face [function! 1 [
                style [word!] 
                /spec 
                blk [block!] 
                /offset 
                xy [pair!] 
                /size 
                wh [pair!] 
                /local 
                svv face styles model opts css
            ] [
                /spec 1 1 
                /offset 2 1 
                /size 3 1
            ]] 
        dump-face [function! 1 [
                face [object!] 
                /local depth f
            ] #[none]] 
        do-no-sync [function! 1 [
                code [block!] 
                /local r e old
            ] #[none]] 
        get-scroller [function! 2 [
                face [object!] 
                orientation [word!] 
                return: [object!]
            ] #[none]] 
        get-face-pane [function! 1 [
                face [object!] 
                return: [block! none!]
            ] #[none]] 
        get-focusable [function! 1 [
                faces [block!] 
                /back 
                /local origin checks flags f pane p
            ] [
                /back 1 0
            ]] 
        insert-event-func [function! 2 [
                name [word!] 
                fun [block! function!] 
                /local svh
            ] #[none]] 
        remove-event-func [function! 1 [
                id [function! word!] 
                /local svh pos
            ] #[none]] 
        request-font [function! 0 [
                /font 
                ft [object!] 
                /mono
            ] [
                /font 1 1 
                /mono 2 0
            ]] 
        request-file [function! 0 [
                /title 
                text [string!] 
                /file 
                name [file! string!] 
                /filter 
                list [block!] 
                /save 
                /multi
            ] [
                /title 1 1 
                /file 2 1 
                /filter 3 1 
                /save 4 0 
                /multi 5 0
            ]] 
        request-dir [function! 0 [
                /title 
                text [string!] 
                /dir 
                name [file! string!] 
                /filter 
                list [block!] 
                /keep 
                /multi
            ] [
                /title 1 1 
                /dir 2 1 
                /filter 3 1 
                /keep 4 0 
                /multi 5 0
            ]] 
        set-focus [function! 1 [
                face [object!] 
                /after 
                /before 
                /local from p
            ] [
                /after 1 0 
                /before 2 0
            ]] 
        foreach-face [function! 2 [
                face [object!] 
                body [block! function!] 
                /with 
                spec [block! none!] 
                /post 
                /sub post? 
                /local exec
            ] [
                /with 1 1 
                /post 2 0 
                /sub 3 1
            ]] 
        alert [function! 1 [
                msg [block! string!]
            ] #[none]] 
        ~anon542~ [function! 2 [face event 
                /local drag-evt type flags result drag-info done? new box
            ] #[none]] 
        ~anon544~ [function! 2 [face event 
                /local flags faces back? pane new opt
            ] #[none]] 
        ctx||546~encode [function! 2 [data [any-type!] where [file! none! url!]] #[none]] 
        ctx||546~decode [function! 1 [text [binary! file! string!]] #[none]] 
        ctx||553~to-csv-line [function! 2 [
                data [block!] 
                delimiter [char! string!]
            ] #[none]] 
        ctx||553~escape-value [function! 2 [
                value [any-type!] 
                delimiter [char! string!] 
                /local quot? len
            ] #[none]] 
        ctx||553~next-column-name [function! 1 [
                name [char! string!] 
                /local length index position previous
            ] #[none]] 
        ctx||553~make-header [function! 1 [
                length [integer!] 
                /local key
            ] #[none]] 
        ctx||553~get-columns [function! 1 [
                data [block!] 
                /local columns
            ] #[none]] 
        ctx||553~encode-map [function! 2 [
                data [map!] 
                delimiter [char! string!] 
                /local output keys length key index line
            ] #[none]] 
        ctx||553~encode-maps [function! 2 [
                data [block!] 
                delimiter [char! string!] 
                /local columns value line column
            ] #[none]] 
        ctx||553~encode-flat [function! 3 [
                data [block!] 
                delimiter [char! string!] 
                size [integer!]
            ] #[none]] 
        ctx||553~encode-blocks [function! 2 [
                data [block!] 
                delimiter [char! string!] 
                /local length line csv-line
            ] #[none]] 
        load-csv [function! 1 [
                data [string!] 
                /with 
                delimiter [char! string!] 
                /header 
                /as-columns 
                /as-records 
                /flat 
                /trim 
                /quote 
                qt-char [char!] 
                /local disallowed refs output out-map longest line value record newline quotchars valchars quoted-value char normal-value s e single-value values add-value add-line length index line-rule init parsed? mark key-index key
            ] [
                /with 1 1 
                /header 2 0 
                /as-columns 3 0 
                /as-records 4 0 
                /flat 5 0 
                /trim 6 0 
                /quote 7 1
            ] ctx||553] 
        to-csv [function! 1 [
                data [block! map! object!] 
                /with 
                delimiter [char! string!] 
                /skip 
                size [integer!] 
                /quote 
                qt-char [char!] 
                /local longest keyval? types value
            ] [
                /with 1 1 
                /skip 2 1 
                /quote 3 1
            ] ctx||553] 
        ctx||566~unescape [routine! 1 [
                str #[block![2 3356x1 red-string!]3] 
                return: #[block![2 3356x1 red-string!]3] 
                /local 
                s s2 #[block![2 3356x1 red/series-buffer!]3] 
                src tail #[block![2 3356x1 pointer! #[block![2 3356x1 byte!]3]]3] 
                unit index c c1 c2 hi lo dst surr #[block![2 3356x1 integer!]3] 
                special? #[block![2 3356x1 logic!]3] 
                decode-4 fail #[block![2 3356x1 subroutine!]3]
            ] #[none]] 
        ctx||566~push [function! 1 [val] #[none]] 
        ctx||566~pop [function! 0 [] #[none]] 
        ctx||566~emit [function! 1 [value] #[none]] 
        load-json [function! 1 [
                input [string!]
            ] #[none] ctx||566] 
        ctx||572~init-state [function! 2 [ind ascii?] #[none]] 
        ctx||572~emit-indent [function! 2 [output level] #[none]] 
        ctx||572~emit-key-value [function! 4 [output sep map key 
                /local value
            ] #[none]] 
        ctx||572~red-to-json-value [function! 2 [output value 
                /local special-char mark1 mark2 escape int hi lo v keys k
            ] #[none]] 
        to-json [function! 1 [
                data 
                /pretty indent [string!] 
                /ascii 
                /local result
            ] [
                /pretty 1 1 
                /ascii 2 0
            ] ctx||572] 
        ctx||579~encode [function! 2 [data [any-type!] where [file! none! url!]] #[none]] 
        ctx||579~decode [function! 1 [text [binary! file! string!]] #[none]] 
        keep [function! 1 [v /only] [/only 1 0]] 
        all? [intrinsic! 1 [{Evaluates and returns the last value if all are truthy; else NONE} conds [block!]] #[none]]
    ] 3641 #[hash![datatype! unset! 
        make unset! none! unset! logic! unset! block! unset! string! unset! integer! unset! word! unset! error! unset! typeset! unset! file! unset! url! unset! set-word! unset! get-word! unset! lit-word! unset! refinement! unset! binary! unset! paren! unset! char! unset! issue! unset! path! unset! set-path! unset! get-path! unset! lit-path! unset! native! unset! action! unset! op! unset! function! unset! routine! unset! object! unset! bitset! unset! float! unset! triple! unset! vector! unset! map! unset! hash! unset! pair! unset! percent! unset! tuple! unset! image! unset! time! unset! tag! unset! email! unset! handle! unset! date! unset! port! unset! money! unset! ref! unset! point2D! unset! point3D! unset! event! unset! none unset! true unset! false unset! random unset! reflect unset! to unset! form unset! mold unset! modify unset! absolute unset! add unset! divide unset! multiply unset! negate unset! power unset! remainder unset! round unset! subtract unset! even? unset! odd? unset! and~ unset! complement unset! or~ unset! xor~ unset! append unset! at unset! back unset! change unset! clear unset! copy unset! find unset! head unset! head? unset! index? unset! insert unset! length? unset! move unset! next unset! pick unset! poke unset! put unset! remove unset! reverse unset! select unset! sort unset! skip unset! swap unset! tail unset! tail? unset! take unset! trim unset! create unset! close unset! delete unset! open unset! open? unset! query unset! read unset! rename unset! update unset! write unset! if unset! unless unset! either unset! any unset! all unset! while unset! until unset! loop unset! repeat unset! forever unset! foreach unset! forall unset! remove-each unset! func unset! function unset! does unset! has unset! switch unset! case unset! do unset! reduce unset! compose unset! get unset! set unset! print unset! prin unset! equal? unset! not-equal? unset! strict-equal? unset! lesser? unset! greater? unset! lesser-or-equal? unset! greater-or-equal? unset! same? unset! not unset! type? unset! stats unset! bind unset! in unset! parse unset! union unset! unique unset! intersect unset! difference unset! exclude unset! complement? unset! dehex unset! enhex unset! negative? unset! positive? unset! max unset! min unset! shift unset! to-hex unset! sine unset! cosine unset! tangent unset! arcsine unset! arccosine unset! arctangent unset! arctangent2 unset! NaN? unset! zero? unset! log-2 unset! log-10 unset! log-e unset! exp unset! square-root unset! construct unset! value? unset! try unset! uppercase unset! lowercase unset! as-pair unset! as-point2D unset! as-point3D unset! as-money unset! break unset! continue unset! exit unset! return unset! throw unset! catch unset! extend unset! debase unset! enbase unset! to-local-file unset! wait unset! checksum unset! unset unset! new-line unset! new-line? unset! context? unset! set-env unset! get-env unset! list-env unset! now unset! sign? unset! as unset! call unset! size? unset! browse unset! compress unset! decompress unset! recycle unset! transcode unset! apply unset! quit-return unset! set-quiet unset! set-slot-quiet unset! shift-right unset! shift-left unset! shift-logical unset! last-lf? unset! get-current-dir unset! set-current-dir unset! create-dir unset! exists? unset! os-info unset! as-color unset! as-ipv4 unset! as-rgba unset! count-chars unset! stack-size? unset! pick-stack unset! frame-index? unset! collect-calls unset! tracing? unset! read-clipboard unset! write-clipboard unset! write-stdout unset! yes unset! on unset! no unset! off unset! tab unset! cr unset! newline unset! lf unset! escape unset! slash unset! sp unset! space unset! null unset! crlf unset! enter unset! dot unset! comma unset! dbl-quote unset! pi unset! Rebol unset! null-handle unset! internal! unset! external! unset! number! unset! planar! unset! any-point! unset! scalar! unset! any-word! unset! all-word! unset! any-list! unset! any-path! unset! any-block! unset! any-function! unset! any-object! unset! any-string! unset! series! unset! immediate! unset! default! unset! any-type! unset! aqua unset! beige unset! black unset! blue unset! brick unset! brown unset! coal unset! coffee unset! crimson unset! cyan unset! forest unset! gold unset! gray unset! green unset! ivory unset! khaki unset! leaf unset! linen unset! magenta unset! maroon unset! mint unset! navy unset! oldrab unset! olive unset! orange unset! papaya unset! pewter unset! pink unset! purple unset! reblue unset! rebolor unset! red unset! sienna unset! silver unset! sky unset! snow unset! tanned unset! teal unset! violet unset! water unset! wheat unset! white unset! yello unset! yellow unset! glass unset! transparent unset! routine unset! also unset! attempt unset! comment unset! quit unset! empty? unset! ?? unset! probe unset! quote unset! first unset! second unset! third unset! fourth unset! fifth unset! last unset! spec-of unset! body-of unset! words-of unset! class-of unset! values-of unset! bitset? unset! binary? unset! block? unset! char? unset! email? unset! file? unset! float? unset! get-path? unset! get-word? unset! hash? unset! integer? unset! issue? unset! lit-path? unset! lit-word? unset! logic? unset! map? unset! none? unset! pair? unset! paren? unset! path? unset! percent? unset! refinement? unset! set-path? unset! set-word? unset! string? unset! tag? unset! time? unset! typeset? unset! tuple? unset! unset? unset! url? unset! word? unset! image? unset! date? unset! money? unset! ref? unset! point2D? unset! point3D? unset! handle? unset! error? unset! action? unset! native? unset! datatype? unset! function? unset! object? unset! op? unset! routine? unset! vector? unset! any-list? unset! any-block? unset! any-function? unset! any-object? unset! any-path? unset! any-string? unset! any-word? unset! series? unset! number? unset! immediate? unset! scalar? unset! all-word? unset! any-point? unset! planar? unset! to-bitset unset! to-binary unset! to-block unset! to-char unset! to-email unset! to-file unset! to-float unset! to-get-path unset! to-get-word unset! to-hash unset! to-integer unset! to-issue unset! to-lit-path unset! to-lit-word unset! to-logic unset! to-map unset! to-none unset! to-pair unset! to-paren unset! to-path unset! to-percent unset! to-refinement unset! to-set-path unset! to-set-word unset! to-string unset! to-tag unset! to-time unset! to-typeset unset! to-tuple unset! to-unset unset! to-url unset! to-word unset! to-image unset! to-date unset! to-money unset! to-ref unset! to-point2D unset! to-point3D unset! context unset! alter unset! offset? unset! repend unset! replace unset! math unset! charset unset! p-indent unset! on-parse-event unset! parse-trace unset! suffix? unset! scan unset! load unset! save unset! cause-error unset! pad unset! mod unset! modulo unset! eval-set-path unset! to-red-file unset! dir? unset! normalize-dir unset! what-dir unset! change-dir unset! make-dir unset! extract unset! extract-boot-args unset! collect unset! flip-exe-flag unset! split unset! dirize unset! clean-path unset! split-path unset! do-file unset! path-thru unset! exists-thru? unset! read-thru unset! load-thru unset! do-thru unset! cos unset! sin unset! tan unset! acos unset! asin unset! atan unset! atan2 unset! sqrt unset! to-UTC-date unset! to-local-date unset! show-memory-stats unset! transcode-trace unset! rejoin unset! sum unset! average unset! last? unset! dt unset! time-it unset! clock unset! single? unset! keys-of unset! object unset! halt unset! system unset! version unset! build unset! date unset! git unset! config unset! config-name unset! OS unset! OS-version unset! ABI unset! link? unset! debug? unset! encap? unset! build-prefix unset! build-basename unset! build-suffix unset! format unset! type unset! target unset! cpu-version unset! verbosity unset! sub-system unset! runtime? unset! use-natives? unset! debug-safe? unset! dev-mode? unset! static-link? unset! need-main? unset! PIC? unset! base-address unset! dynamic-linker unset! syscall unset! export-ABI unset! stack-align-16? unset! literal-pool? unset! unicode? unset! red-pass? unset! red-only? unset! red-store-bodies? unset! red-strict-check? unset! red-tracing? unset! red-help? unset! redbin-compress? unset! legacy unset! gui-console? unset! libRed? unset! libRedRT? unset! libRedRT-update? unset! GUI-engine unset! draw-engine unset! modules unset! show unset! command-line unset! show-func-map? unset! words unset! platform unset! catalog unset! datatypes unset! actions unset! natives unset! accessors unset! errors unset! code unset! while-cond unset! note unset! no-load unset! syntax unset! invalid unset! missing unset! no-header unset! no-rs-header unset! bad-header unset! malconstruct unset! bad-char unset! script unset! no-value unset! need-value unset! not-defined unset! not-in-context unset! no-arg unset! expect-arg unset! expect-val unset! expect-type unset! cannot-use unset! invalid-arg unset! invalid-type unset! invalid-type-spec unset! invalid-key-type unset! invalid-op unset! no-op-arg unset! bad-op-spec unset! invalid-data unset! invalid-part unset! not-same-type unset! not-same-class unset! not-related unset! bad-func-def unset! bad-func-arg unset! bad-func-extern unset! no-refine unset! bad-refines unset! bad-refine unset! dup-refine unset! word-first unset! empty-path unset! unset-path unset! invalid-path unset! invalid-path-set unset! invalid-path-get unset! bad-path-type unset! bad-path-type2 unset! bad-path-set unset! bad-field-set unset! dup-vars unset! past-end unset! missing-arg unset! out-of-range unset! invalid-chars unset! invalid-compare unset! wrong-type unset! invalid-refine-arg unset! type-limit unset! size-limit unset! no-return unset! throw-usage unset! locked-word unset! protected unset! bad-bad unset! bad-make-arg unset! bad-to-arg unset! invalid-months unset! invalid-spec-field unset! missing-spec-field unset! move-bad unset! too-long unset! invalid-char unset! bad-loop-series unset! wrong-denom unset! bad-denom unset! invalid-obj-evt unset! parse-rule unset! parse-end unset! parse-invalid-ref unset! parse-block unset! parse-unsupported unset! parse-infinite unset! parse-stack unset! parse-keep unset! parse-into-bad unset! parse-into-type unset! draw-invalid unset! draw-infinite unset! invalid-data-facet unset! face-type unset! not-window unset! bad-window unset! not-linked unset! not-event-type unset! invalid-facet-type unset! vid-invalid-syntax unset! rtd-invalid-syntax unset! rtd-no-match unset! react-bad-func unset! react-not-enough unset! react-no-match unset! react-bad-obj unset! react-gctx unset! lib-invalid-arg unset! rb-invalid-record unset! zero-divide unset! overflow unset! positive unset! access unset! cannot-open unset! cannot-close unset! invalid-utf8 unset! not-open unset! no-connect unset! no-scheme unset! unknown-scheme unset! invalid-spec unset! invalid-port unset! invalid-actor unset! no-port-action unset! no-create unset! no-codec unset! bad-media unset! invalid-cmd unset! reserved1 unset! reserved2 unset! user unset! message unset! internal unset! bad-path unset! not-here unset! no-memory unset! wrong-mem unset! stack-overflow unset! limit-hit unset! too-deep unset! no-cycle unset! feature-na unset! not-done unset! invalid-error unset! routines unset! red-system unset! deprecated unset! state unset! interpreted? unset! last-error unset! stack-trace unset! source-files unset! callbacks unset! lexer? unset! parse? unset! sort? unset! change? unset! deep? unset! port? unset! bits unset! on-change* unset! GC unset! active? unset! ctx||270~active? unset! series-cycles unset! ctx||270~series-cycles unset! nodes-cycles unset! ctx||270~nodes-cycles unset! codecs unset! schemes unset! ports unset! locale unset! language unset! language* unset! locale* unset! months unset! days unset! currencies unset! list unset! on-deep-change* unset! options unset! boot unset! home unset! path unset! cache unset! thru-cache unset! args unset! do-arg unset! debug unset! secure unset! quiet unset! binary-base unset! decimal-digits unset! money-digits unset! module-paths unset! file-types unset! float unset! pretty? unset! full? unset! title unset! header unset! parent unset! standard unset! Name unset! File unset! Author unset! Tabs unset! Needs unset! License unset! History unset! Rights unset! Usage unset! Purpose unset! Content unset! Owner unset! port unset! spec unset! scheme unset! actor unset! awake unset! data unset! extra unset! error unset! id unset! arg1 unset! arg2 unset! arg3 unset! near unset! where unset! stack unset! files unset! file-info unset! size unset! url-parts unset! user-info unset! host unset! fragment unset! ref unset! info unset! lexer unset! pre-load unset! err-pos unset! exit-states unset! trapper unset! tracer unset! console unset! view unset! reactivity unset! tools unset! + unset! - unset! * unset! / unset! // unset! %"" unset! = unset! <> unset! == unset! =? unset! < unset! > unset! <= unset! >= unset! << unset! >> unset! ">>>" unset! ** unset! and unset! or unset! xor unset! mime-type unset! suffixes unset! encode unset! ctx||316~encode unset! decode unset! ctx||316~decode unset! ctx||319~encode unset! ctx||319~decode unset! ctx||322~encode unset! ctx||322~decode unset! ctx||325~encode unset! ctx||325~decode unset! compact? unset! encode* unset! ctx||328~encode* unset! ctx||328~decode unset! reactor! unset! deep-reactor! unset! reactor unset! deep-reactor unset! relations unset! queue unset! eat-events? unset! types! unset! not-safe! unset! add-relation unset! identify-sources unset! eval unset! eval-reaction unset! pending? unset! check unset! no-react unset! stop-reactor unset! clear-reactions unset! dump-reactions unset! relate unset! is unset! react? unset! react unset! register-scheme unset! url-parser unset! =scheme unset! =user-info unset! =host unset! =port unset! =path unset! =query unset! =fragment unset! vars unset! alpha unset! digit unset! alpha-num unset! hex-digit unset! gen-delims unset! sub-delims unset! reserved unset! unreserved unset! pct-encoded unset! alpha-num+ unset! scheme-char unset! url-rules unset! scheme-part unset! hier-part unset! authority unset! IP-literal unset! path-abempty unset! path-absolute unset! path-rootless unset! path-empty unset! any-segments unset! segment unset! segment-nz unset! segment-nz-nc unset! pchar unset! parse-url unset! decode-url unset! encode-url unset! preprocessor unset! exec unset! protos unset! macros unset! syms unset! depth unset! trace? unset! s unset! do-quit unset! throw-error unset! syntax-error unset! do-safe unset! do-code unset! rebind-all unset! count-args unset! arg-mode? unset! func-arity? unset! value-path? unset! fetch-next unset! do-macro unset! register-macro unset! reset unset! expand unset! expand-directives unset! fun-stk unset! expr-stk unset! watching unset! profiling unset! indent unset! hist-length unset! dbg-usage unset! show-stack? unset! show-parents? unset! show-locals? unset! stack-indent? unset! trace unset! indent? unset! profile unset! sort-by unset! types unset! calc-max unset! show-context unset! show-parents unset! show-stack unset! show-watching unset! do-command unset! debugger unset! tracers unset! emit unset! opening-marker unset! closing-markers unset! mold-part unset! dumper unset! push unset! drop unset! pop unset! top-of unset! step unset! mold-size unset! free unset! inspect unset! event-filter unset! scope-filter unset! inspect-sub-exprs? unset! func-depth unset! expr-depth unset! fetched unset! fetched' unset! pushed unset! pushed' unset! subexprs unset! saved unset! stack-period unset! save-level unset! unroll-level unset! collector unset! guided-trace unset! inspector unset! fixed-width unset! last-path unset! constants unset! type-names unset! ignored-words unset! fetched-index unset! fetched'-index unset! profiler unset! do-handler unset! hex-to-rgb unset! within? unset! overlap? unset! distance? unset! event? unset! send-event-os unset! send-event unset! face? unset! get-current-screen unset! size-text unset! caret-to-offset unset! offset-to-caret unset! offset-to-char unset! rich-text unset! rtd unset! color-stk unset! out unset! text unset! s-idx unset! pos unset! v unset! l unset! cur unset! pos1 unset! mark unset! col unset! cols unset! nested unset! color unset! f-args unset! style! unset! style unset! tail-idx? unset! push-color unset! pop-color unset! close-colors unset! pop-all unset! optimize unset! rtd-layout unset! line-height? unset! line-count? unset! metrics? unset! set-flag unset! find-flag? unset! debug-info? unset! on-face-deep-change* unset! link-tabs-to-parent unset! link-sub-to-parent unset! update-font-faces unset! face! unset! offset unset! image unset! menu unset! enabled? unset! visible? unset! selected unset! flags unset! pane unset! rate unset! edge unset! para unset! font unset! actors unset! draw unset! font! unset! angle unset! anti-alias? unset! shadow unset! para! unset! origin unset! padding unset! scroll unset! align unset! v-align unset! wrap? unset! scroller! unset! position unset! page-size unset! min-size unset! max-size unset! vertical? unset! screens unset! event-port unset! metrics unset! screen-size unset! dpi unset! paddings unset! margins unset! def-heights unset! fixed-heights unset! misc unset! colors unset! fonts unset! fixed unset! sans-serif unset! serif unset! VID unset! handlers unset! evt-names unset! capture-events unset! capturing? unset! auto-sync? unset! silent? unset! GPU? unset! mouse-event? unset! make-null-handle unset! ctx||484~make-null-handle unset! fetch-all-screens unset! ctx||484~fetch-all-screens unset! ctx||484~get-current-screen unset! all-windows-closed? unset! refresh-screens unset! get-screen-size unset! ctx||484~get-screen-size unset! ctx||484~size-text unset! on-change-facet unset! ctx||484~on-change-facet unset! update-text unset! ctx||484~update-text unset! update-font unset! ctx||484~update-font unset! update-para unset! ctx||484~update-para unset! destroy-view unset! ctx||484~destroy-view unset! detach-image unset! ctx||484~detach-image unset! update-view unset! ctx||484~update-view unset! refresh-window unset! ctx||484~refresh-window unset! redraw unset! ctx||484~redraw unset! show-window unset! ctx||484~show-window unset! make-view unset! ctx||484~make-view unset! draw-image unset! ctx||484~draw-image unset! draw-face unset! ctx||484~draw-face unset! do-event-loop unset! ctx||484~do-event-loop unset! exit-event-loop unset! ctx||484~exit-event-loop unset! request-font unset! ctx||484~request-font unset! request-file unset! ctx||484~request-file unset! request-dir unset! ctx||484~request-dir unset! text-box-metrics unset! ctx||484~text-box-metrics unset! update-scroller unset! ctx||484~update-scroller unset! set-dark-mode unset! ctx||484~set-dark-mode unset! support-dark-mode? unset! ctx||484~support-dark-mode? unset! toggle-GPU unset! ctx||484~toggle-GPU unset! init unset! product unset! styles unset! extras unset! GUI-rules unset! processors unset! count-faces unset! cancel-captions unset! ok-captions unset! Cancel-OK unset! general unset! process unset! spacing unset! pos-size! unset! containers unset! default-font unset! opts-proto unset! size-x unset! now? unset! process-reactors unset! opt-as-integer unset! calc-size unset! align-faces unset! resize-child-panels unset! clean-style unset! process-draw unset! preset-focus unset! add-option unset! add-flag unset! add-bounds unset! fetch-value unset! fetch-argument unset! fetch-expr unset! fetch-options unset! make-actor unset! layout unset! do-events unset! stop-events unset! do-actor unset! unview unset! center-face unset! make-face unset! dump-face unset! do-no-sync unset! get-scroller unset! get-face-pane unset! get-focusable unset! insert-event-func unset! remove-event-func unset! set-focus unset! foreach-face unset! alert unset! ignore-empty? unset! strict? unset! quote-char unset! double-quote unset! quotable-chars unset! parsed? unset! non-aligned unset! to-csv-line unset! escape-value unset! next-column-name unset! make-header unset! get-columns unset! encode-map unset! encode-maps unset! encode-flat unset! encode-blocks unset! load-csv unset! to-csv unset! non-line-ws unset! ws unset! ws* unset! ws+ unset! sep unset! non-zero-digit unset! hex-char unset! chars unset! not-word-char unset! word-1st unset! word-char unset! sign unset! int unset! frac unset! number unset! numeric-literal unset! string-literal unset! json-esc-ch unset! unescape unset! ctx||566~unescape unset! json-object unset! property-list unset! property unset! json-name unset! array-list unset! json-array unset! json-value unset! _out unset! _res unset! _tmp unset! _str unset! _s unset! _e unset! line-ct unset! last-lf unset! load-json unset! indent-level unset! normal-chars unset! escapes unset! init-state unset! emit-indent unset! emit-key-value unset! red-to-json-value unset! to-json unset! word unset! res unset! screen unset! font-fixed unset! font-sans-serif unset! font-serif unset! reactors unset! value unset!
    ]] [#[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] 
        system #[object! [
            version: #[none]
            build: #[object! [
                date: #[none]
                git: #[none]
                config: #[object! [
                    config-name: #[none]
                    OS: #[none]
                    OS-version: #[none]
                    ABI: #[none]
                    link?: #[none]
                    debug?: #[none]
                    encap?: #[none]
                    build-prefix: #[none]
                    build-basename: #[none]
                    build-suffix: #[none]
                    format: #[none]
                    type: #[none]
                    target: #[none]
                    cpu-version: #[none]
                    verbosity: #[none]
                    sub-system: #[none]
                    runtime?: #[none]
                    use-natives?: #[none]
                    debug-safe?: #[none]
                    dev-mode?: #[none]
                    static-link?: #[none]
                    need-main?: #[none]
                    PIC?: #[none]
                    base-address: #[none]
                    dynamic-linker: #[none]
                    syscall: #[none]
                    export-ABI: #[none]
                    stack-align-16?: #[none]
                    literal-pool?: #[none]
                    unicode?: #[none]
                    red-pass?: #[none]
                    red-only?: #[none]
                    red-store-bodies?: #[none]
                    red-strict-check?: #[none]
                    red-tracing?: #[none]
                    red-help?: #[none]
                    redbin-compress?: #[none]
                    legacy: #[none]
                    gui-console?: #[none]
                    libRed?: #[none]
                    libRedRT?: #[none]
                    libRedRT-update?: #[none]
                    GUI-engine: #[none]
                    draw-engine: #[none]
                    modules: #[none]
                    show: #[none]
                    command-line: #[none]
                    show-func-map?: #[none]
                ]]
            ]]
            words: #[none]
            platform: #[none]
            catalog: #[object! [
                datatypes: #[none]
                actions: #[none]
                natives: #[none]
                accessors: #[none]
                errors: #[object! [
                    throw: #[object! [
                        code: #[none]
                        type: #[none]
                        break: #[none]
                        return: #[none]
                        throw: #[none]
                        continue: #[none]
                        while-cond: #[none]
                    ]]
                    note: #[object! [
                        code: #[none]
                        type: #[none]
                        no-load: #[none]
                    ]]
                    syntax: #[object! [
                        code: #[none]
                        type: #[none]
                        invalid: #[none]
                        missing: #[none]
                        no-header: #[none]
                        no-rs-header: #[none]
                        bad-header: #[none]
                        malconstruct: #[none]
                        bad-char: #[none]
                    ]]
                    script: #[object! [
                        code: #[none]
                        type: #[none]
                        no-value: #[none]
                        need-value: #[none]
                        not-defined: #[none]
                        not-in-context: #[none]
                        no-arg: #[none]
                        expect-arg: #[none]
                        expect-val: #[none]
                        expect-type: #[none]
                        cannot-use: #[none]
                        invalid-arg: #[none]
                        invalid-type: #[none]
                        invalid-type-spec: #[none]
                        invalid-key-type: #[none]
                        invalid-op: #[none]
                        no-op-arg: #[none]
                        bad-op-spec: #[none]
                        invalid-data: #[none]
                        invalid-part: #[none]
                        not-same-type: #[none]
                        not-same-class: #[none]
                        not-related: #[none]
                        bad-func-def: #[none]
                        bad-func-arg: #[none]
                        bad-func-extern: #[none]
                        no-refine: #[none]
                        bad-refines: #[none]
                        bad-refine: #[none]
                        dup-refine: #[none]
                        word-first: #[none]
                        empty-path: #[none]
                        unset-path: #[none]
                        invalid-path: #[none]
                        invalid-path-set: #[none]
                        invalid-path-get: #[none]
                        bad-path-type: #[none]
                        bad-path-type2: #[none]
                        bad-path-set: #[none]
                        bad-field-set: #[none]
                        dup-vars: #[none]
                        past-end: #[none]
                        missing-arg: #[none]
                        out-of-range: #[none]
                        invalid-chars: #[none]
                        invalid-compare: #[none]
                        wrong-type: #[none]
                        invalid-refine-arg: #[none]
                        type-limit: #[none]
                        size-limit: #[none]
                        no-return: #[none]
                        throw-usage: #[none]
                        locked-word: #[none]
                        protected: #[none]
                        bad-bad: #[none]
                        bad-make-arg: #[none]
                        bad-to-arg: #[none]
                        invalid-months: #[none]
                        invalid-spec-field: #[none]
                        missing-spec-field: #[none]
                        move-bad: #[none]
                        too-long: #[none]
                        invalid-char: #[none]
                        bad-loop-series: #[none]
                        wrong-denom: #[none]
                        bad-denom: #[none]
                        invalid-obj-evt: #[none]
                        parse-rule: #[none]
                        parse-end: #[none]
                        parse-invalid-ref: #[none]
                        parse-block: #[none]
                        parse-unsupported: #[none]
                        parse-infinite: #[none]
                        parse-stack: #[none]
                        parse-keep: #[none]
                        parse-into-bad: #[none]
                        parse-into-type: #[none]
                        draw-invalid: #[none]
                        draw-infinite: #[none]
                        invalid-data-facet: #[none]
                        face-type: #[none]
                        not-window: #[none]
                        bad-window: #[none]
                        not-linked: #[none]
                        not-event-type: #[none]
                        invalid-facet-type: #[none]
                        vid-invalid-syntax: #[none]
                        rtd-invalid-syntax: #[none]
                        rtd-no-match: #[none]
                        react-bad-func: #[none]
                        react-not-enough: #[none]
                        react-no-match: #[none]
                        react-bad-obj: #[none]
                        react-gctx: #[none]
                        lib-invalid-arg: #[none]
                        rb-invalid-record: #[none]
                    ]]
                    math: #[object! [
                        code: #[none]
                        type: #[none]
                        zero-divide: #[none]
                        overflow: #[none]
                        positive: #[none]
                    ]]
                    access: #[object! [
                        code: #[none]
                        type: #[none]
                        cannot-open: #[none]
                        cannot-close: #[none]
                        invalid-utf8: #[none]
                        not-open: #[none]
                        no-connect: #[none]
                        no-scheme: #[none]
                        unknown-scheme: #[none]
                        invalid-spec: #[none]
                        invalid-port: #[none]
                        invalid-actor: #[none]
                        no-port-action: #[none]
                        no-create: #[none]
                        no-codec: #[none]
                        bad-media: #[none]
                        invalid-cmd: #[none]
                    ]]
                    reserved1: #[object! [
                        code: #[none]
                        type: #[none]
                    ]]
                    reserved2: #[object! [
                        code: #[none]
                        type: #[none]
                    ]]
                    user: #[object! [
                        code: #[none]
                        type: #[none]
                        message: #[none]
                    ]]
                    internal: #[object! [
                        code: #[none]
                        type: #[none]
                        bad-path: #[none]
                        not-here: #[none]
                        no-memory: #[none]
                        wrong-mem: #[none]
                        stack-overflow: #[none]
                        limit-hit: #[none]
                        too-deep: #[none]
                        no-cycle: #[none]
                        feature-na: #[none]
                        not-done: #[none]
                        invalid-error: #[none]
                        routines: #[none]
                        red-system: #[none]
                        deprecated: #[none]
                    ]]
                ]]
            ]]
            state: #[object! [
                interpreted?: #[datatype! function!]
                last-error: #[none]
                stack-trace: #[none]
                source-files: #[none]
                callbacks: #[object! [
                    lexer?: #[none]
                    parse?: #[none]
                    sort?: #[none]
                    change?: #[none]
                    deep?: #[none]
                    port?: #[none]
                    bits: #[none]
                    on-change*: #[datatype! function!]
                ]]
                GC: #[object! [
                    active?: #[datatype! function!]
                    series-cycles: #[datatype! function!]
                    nodes-cycles: #[datatype! function!]
                ]]
            ]]
            modules: #[none]
            codecs: #[none]
            schemes: #[none]
            ports: #[object! [
            ]]
            locale: #[object! [
                language: #[none]
                language*: #[none]
                locale: #[none]
                locale*: #[none]
                months: #[none]
                days: #[none]
                currencies: #[object! [
                    list: #[none]
                    on-change*: #[datatype! function!]
                    on-deep-change*: #[datatype! function!]
                ]]
            ]]
            options: #[object! [
                boot: #[none]
                home: #[none]
                path: #[none]
                script: #[none]
                cache: #[none]
                thru-cache: #[none]
                args: #[none]
                do-arg: #[none]
                debug: #[none]
                secure: #[none]
                quiet: #[none]
                binary-base: #[none]
                decimal-digits: #[none]
                money-digits: #[none]
                module-paths: #[none]
                file-types: #[none]
                float: #[object! [
                    pretty?: #[none]
                    full?: #[none]
                    on-change*: #[datatype! function!]
                ]]
                on-change*: #[datatype! function!]
                on-deep-change*: #[datatype! function!]
            ]]
            script: #[object! [
                title: #[none]
                header: #[object! [
                    Title: #[none]
                    Name: #[none]
                    Type: #[none]
                    Version: #[none]
                    Date: #[none]
                    File: #[none]
                    Home: #[none]
                    Author: #[none]
                    Tabs: #[none]
                    Needs: #[none]
                    License: #[none]
                    Note: #[none]
                    History: #[none]
                    Rights: #[none]
                    Usage: #[none]
                    Purpose: #[none]
                    Comment: #[none]
                    Language: #[none]
                    Content: #[none]
                    Owner: #[none]
                ]]
                parent: #[none]
                path: #[none]
                args: #[none]
            ]]
            standard: #[object! [
                header: #[object! [
                    Title: #[none]
                    Name: #[none]
                    Type: #[none]
                    Version: #[none]
                    Date: #[none]
                    File: #[none]
                    Home: #[none]
                    Author: #[none]
                    Tabs: #[none]
                    Needs: #[none]
                    License: #[none]
                    Note: #[none]
                    History: #[none]
                    Rights: #[none]
                    Usage: #[none]
                    Purpose: #[none]
                    Comment: #[none]
                    Language: #[none]
                    Content: #[none]
                    Owner: #[none]
                ]]
                port: #[object! [
                    spec: #[none]
                    scheme: #[none]
                    actor: #[none]
                    awake: #[none]
                    state: #[none]
                    data: #[none]
                    extra: #[none]
                ]]
                error: #[object! [
                    code: #[none]
                    type: #[none]
                    id: #[none]
                    arg1: #[none]
                    arg2: #[none]
                    arg3: #[none]
                    near: #[none]
                    where: #[none]
                    stack: #[none]
                    files: #[none]
                ]]
                file-info: #[object! [
                    name: #[none]
                    size: #[none]
                    date: #[none]
                    type: #[none]
                ]]
                url-parts: #[object! [
                    scheme: #[none]
                    user-info: #[none]
                    host: #[none]
                    port: #[none]
                    path: #[none]
                    target: #[none]
                    query: #[none]
                    fragment: #[none]
                    ref: #[none]
                ]]
                scheme: #[object! [
                    name: #[none]
                    title: #[none]
                    info: #[none]
                    actor: #[none]
                    awake: #[none]
                ]]
            ]]
            lexer: #[object! [
                pre-load: #[none]
                err-pos: #[none]
                exit-states: #[none]
                trapper: #[datatype! function!]
                tracer: #[datatype! function!]
            ]]
            console: #[none]
            view: #[object! [
                screens: #[none]
                event-port: #[none]
                metrics: #[object! [
                    screen-size: #[none]
                    dpi: #[none]
                    paddings: #[none]
                    margins: #[none]
                    def-heights: #[none]
                    fixed-heights: #[none]
                    misc: #[none]
                    colors: #[none]
                ]]
                fonts: #[object! [
                    system: #[none]
                    fixed: #[none]
                    sans-serif: #[none]
                    serif: #[none]
                    size: #[none]
                ]]
                platform: #[object! [
                    mouse-event?: #[none]
                    make-null-handle: #[datatype! function!]
                    fetch-all-screens: #[datatype! function!]
                    get-current-screen: #[datatype! function!]
                    all-windows-closed?: #[datatype! function!]
                    refresh-screens: #[datatype! function!]
                    get-screen-size: #[datatype! function!]
                    size-text: #[datatype! function!]
                    on-change-facet: #[datatype! function!]
                    update-text: #[datatype! function!]
                    update-font: #[datatype! function!]
                    update-para: #[datatype! function!]
                    destroy-view: #[datatype! function!]
                    detach-image: #[datatype! function!]
                    update-view: #[datatype! function!]
                    refresh-window: #[datatype! function!]
                    redraw: #[datatype! function!]
                    show-window: #[datatype! function!]
                    make-view: #[datatype! function!]
                    draw-image: #[datatype! function!]
                    draw-face: #[datatype! function!]
                    do-event-loop: #[datatype! function!]
                    exit-event-loop: #[datatype! function!]
                    request-font: #[datatype! function!]
                    request-file: #[datatype! function!]
                    request-dir: #[datatype! function!]
                    text-box-metrics: #[datatype! function!]
                    update-scroller: #[datatype! function!]
                    set-dark-mode: #[datatype! function!]
                    support-dark-mode?: #[datatype! function!]
                    toggle-GPU: #[datatype! function!]
                    init: #[datatype! function!]
                    version: #[none]
                    build: #[none]
                    product: #[none]
                ]]
                VID: #[object! [
                    styles: #[none]
                    extras: #[none]
                    GUI-rules: #[object! [
                        active?: #[none]
                        debug?: #[none]
                        processors: #[object! [
                            count-faces: #[datatype! function!]
                            cancel-captions: #[none]
                            ok-captions: #[none]
                            Cancel-OK: #[datatype! function!]
                        ]]
                        general: #[none]
                        OS: #[none]
                        user: #[none]
                        process: #[datatype! function!]
                    ]]
                    debug?: #[none]
                    origin: #[none]
                    spacing: #[none]
                    pos-size!: #[none]
                    containers: #[none]
                    default-font: #[none]
                    opts-proto: #[object! [
                        type: #[none]
                        offset: #[none]
                        size: #[none]
                        size-x: #[none]
                        text: #[none]
                        color: #[none]
                        enabled?: #[none]
                        visible?: #[none]
                        selected: #[none]
                        image: #[none]
                        rate: #[none]
                        font: #[none]
                        flags: #[none]
                        options: #[none]
                        para: #[none]
                        data: #[none]
                        extra: #[none]
                        actors: #[none]
                        draw: #[none]
                        now?: #[none]
                        init: #[none]
                    ]]
                    throw-error: #[datatype! function!]
                    process-reactors: #[datatype! function!]
                    opt-as-integer: #[datatype! function!]
                    calc-size: #[datatype! function!]
                    align-faces: #[datatype! function!]
                    resize-child-panels: #[datatype! function!]
                    clean-style: #[datatype! function!]
                    process-draw: #[datatype! function!]
                    pre-load: #[datatype! function!]
                    preset-focus: #[datatype! function!]
                    add-option: #[datatype! function!]
                    add-flag: #[datatype! function!]
                    add-bounds: #[datatype! function!]
                    fetch-value: #[datatype! function!]
                    fetch-argument: #[datatype! function!]
                    fetch-expr: #[datatype! function!]
                    fetch-options: #[datatype! function!]
                    make-actor: #[datatype! function!]
                ]]
                handlers: #[none]
                evt-names: #[none]
                capture-events: #[datatype! function!]
                awake: #[datatype! function!]
                on-change*: #[datatype! function!]
                capturing?: #[none]
                auto-sync?: #[none]
                debug?: #[none]
                silent?: #[none]
                GPU?: #[none]
            ]]
            reactivity: #[object! [
                relations: #[none]
                queue: #[none]
                eat-events?: #[none]
                debug?: #[none]
                types!: #[none]
                not-safe!: #[none]
                add-relation: #[datatype! function!]
                identify-sources: #[datatype! function!]
                eval: #[datatype! function!]
                eval-reaction: #[datatype! function!]
                pending?: #[datatype! function!]
                check: #[datatype! function!]
            ]]
            tools: #[object! [
                fun-stk: #[none]
                expr-stk: #[none]
                watching: #[none]
                profiling: #[none]
                indent: #[none]
                hist-length: #[none]
                dbg-usage: #[none]
                options: #[object! [
                    debug: #[object! [
                        active?: #[none]
                        show-stack?: #[none]
                        show-parents?: #[none]
                        show-locals?: #[none]
                        stack-indent?: #[none]
                    ]]
                    trace: #[object! [
                        indent?: #[none]
                    ]]
                    profile: #[object! [
                        sort-by: #[none]
                        types: #[none]
                    ]]
                ]]
                calc-max: #[datatype! function!]
                show-context: #[datatype! function!]
                show-parents: #[datatype! function!]
                show-stack: #[datatype! function!]
                show-watching: #[datatype! function!]
                do-command: #[datatype! function!]
                debugger: #[datatype! function!]
                tracers: #[object! [
                    emit: #[none]
                    opening-marker: #[none]
                    closing-markers: #[none]
                    mold-part: #[datatype! function!]
                    dumper: #[datatype! function!]
                    push: #[datatype! function!]
                    drop: #[datatype! function!]
                    pop: #[datatype! function!]
                    top-of: #[datatype! function!]
                    step: #[datatype! function!]
                    mold-size: #[none]
                    free: #[object! [
                        list: #[none]
                        put: #[datatype! function!]
                        get: #[datatype! function!]
                    ]]
                    data: #[object! [
                        debug?: #[none]
                        inspect: #[none]
                        event-filter: #[none]
                        scope-filter: #[none]
                        inspect-sub-exprs?: #[none]
                        func-depth: #[none]
                        expr-depth: #[none]
                        path: #[none]
                        fetched: #[none]
                        fetched': #[none]
                        pushed: #[none]
                        pushed': #[none]
                        subexprs: #[none]
                        stack: #[none]
                        saved: #[none]
                        stack-period: #[none]
                        save-level: #[datatype! function!]
                        unroll-level: #[datatype! function!]
                        reset: #[datatype! function!]
                        collector: #[datatype! function!]
                    ]]
                    guided-trace: #[datatype! function!]
                    inspector: #[object! [
                        fixed-width: #[none]
                        last-path: #[none]
                        constants: #[none]
                        type-names: #[none]
                        ignored-words: #[none]
                        fetched-index: #[none]
                        fetched'-index: #[none]
                        inspect: #[datatype! function!]
                    ]]
                ]]
                profiler: #[datatype! function!]
                do-handler: #[datatype! function!]
            ]]
        ]] ctx||234 235 #[none] #[none] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||236 (red/objects/system/build) ctx||236 237 #[none] #[none] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||238 (red/objects/system/build/config) ctx||238 239 #[none] #[none] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||240 (red/objects/system/catalog) ctx||240 241 #[none] #[none] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||242 (red/objects/system/catalog/errors) ctx||242 243 #[none] #[none] ctx||244 (red/objects/system/catalog/errors/throw) ctx||244 245 #[none] #[none] ctx||246 (red/objects/system/catalog/errors/note) ctx||246 247 #[none] #[none] ctx||248 (red/objects/system/catalog/errors/syntax) ctx||248 249 #[none] #[none] ctx||250 (red/objects/system/catalog/errors/script) ctx||250 251 #[none] #[none] ctx||252 (red/objects/system/catalog/errors/math) ctx||252 253 #[none] #[none] ctx||254 (red/objects/system/catalog/errors/access) ctx||254 255 #[none] #[none] ctx||256 (red/objects/system/catalog/errors/reserved1) ctx||256 257 #[none] #[none] ctx||258 (red/objects/system/catalog/errors/reserved2) ctx||258 259 #[none] #[none] ctx||260 (red/objects/system/catalog/errors/user) ctx||260 261 #[none] #[none] ctx||262 (red/objects/system/catalog/errors/internal) ctx||262 263 #[none] #[none] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||264 (red/objects/system/state) ctx||264 265 #[none] #[none] ctx||267 (red/objects/system/state/callbacks) ctx||267 268 #[none] [7 2 -1 0 evt268] ctx||270 (red/objects/system/state/GC) ctx||270 271 #[none] #[none] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||272 (red/objects/system/ports) ctx||272 273 #[none] #[none] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||274 (red/objects/system/locale) ctx||274 275 #[none] #[none] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||276 (red/objects/system/locale/currencies) ctx||276 277 #[none] [1 0 2 0 evt277] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||280 (red/objects/system/options) ctx||280 281 #[none] [17 0 18 0 evt281] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||282 (red/objects/system/options/float) ctx||282 283 #[none] [2 0 -1 0 evt283] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||287 (red/objects/system/script) ctx||287 288 #[none] #[none] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||289 (red/objects/system/standard) ctx||289 290 #[none] #[none] ctx||291 (red/objects/system/standard/header) ctx||291 292 #[none] #[none] ctx||301 (red/objects/system/standard/port) ctx||301 302 #[none] #[none] ctx||303 (red/objects/system/standard/error) ctx||303 304 #[none] #[none] ctx||305 (red/objects/system/standard/file-info) ctx||305 306 #[none] #[none] ctx||308 (red/objects/system/standard/url-parts) ctx||308 309 #[none] #[none] ctx||310 (red/objects/system/standard/scheme) ctx||310 311 #[none] #[none] #[none] #[object! [
            p-indent: #[none]
            on-parse-event: #[datatype! function!]
        ]] ctx||183 184 #[none] #[none] ctx||312 (red/objects/system/lexer) ctx||312 313 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            encode: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||316 317 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            encode: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||319 320 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            encode: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||322 323 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            encode: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||325 326 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] 
        reactor! #[object! [
            on-change*: #[datatype! function!]
        ]] ctx||332 333 #[none] [0 0 -1 0 evt333] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] 
        deep-reactor! #[object! [
            on-change*: #[datatype! function!]
            on-deep-change*: #[datatype! function!]
        ]] ctx||335 336 #[none] [0 0 1 0 evt336] ctx||341 (red/objects/system/reactivity) ctx||341 342 #[none] #[none] 
        url-parser #[object! [
            =scheme: #[none]
            =user-info: #[none]
            =host: #[none]
            =port: #[none]
            =path: #[none]
            =query: #[none]
            =fragment: #[none]
            vars: #[none]
            alpha: #[none]
            digit: #[none]
            alpha-num: #[none]
            hex-digit: #[none]
            gen-delims: #[none]
            sub-delims: #[none]
            reserved: #[none]
            unreserved: #[none]
            pct-encoded: #[none]
            alpha-num+: #[datatype! function!]
            scheme-char: #[none]
            url-rules: #[none]
            scheme-part: #[none]
            hier-part: #[none]
            authority: #[none]
            user-info: #[none]
            IP-literal: #[none]
            host: #[none]
            port: #[none]
            path-abempty: #[none]
            path-absolute: #[none]
            path-rootless: #[none]
            path-empty: #[none]
            any-segments: #[none]
            segment: #[none]
            segment-nz: #[none]
            segment-nz-nc: #[none]
            pchar: #[none]
            query: #[none]
            fragment: #[none]
            parse-url: #[datatype! function!]
        ]] ctx||358 359 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] 
        preprocessor #[object! [
            exec: #[none]
            protos: #[none]
            macros: #[none]
            stack: #[none]
            syms: #[none]
            depth: #[none]
            active?: #[none]
            trace?: #[none]
            s: #[none]
            do-quit: #[datatype! function!]
            throw-error: #[datatype! function!]
            syntax-error: #[datatype! function!]
            do-safe: #[datatype! function!]
            do-code: #[datatype! function!]
            rebind-all: #[datatype! function!]
            count-args: #[datatype! function!]
            arg-mode?: #[datatype! function!]
            func-arity?: #[datatype! function!]
            value-path?: #[datatype! function!]
            fetch-next: #[datatype! function!]
            eval: #[datatype! function!]
            do-macro: #[datatype! function!]
            register-macro: #[datatype! function!]
            reset: #[datatype! function!]
            expand: #[datatype! function!]
        ]] ctx||364 365 #[none] #[none] ctx||383 (red/objects/system/tools) ctx||383 384 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] ctx||385 (red/objects/system/tools/options) ctx||385 386 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] ctx||387 (red/objects/system/tools/options/debug) ctx||387 388 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] ctx||389 (red/objects/system/tools/options/trace) ctx||389 390 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] ctx||391 (red/objects/system/tools/options/profile) ctx||391 392 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] ctx||400 (red/objects/system/tools/tracers) ctx||400 401 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] ctx||409 (red/objects/system/tools/tracers/free) ctx||409 410 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] ctx||413 (red/objects/system/tools/tracers/data) ctx||413 414 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] ctx||420 (red/objects/system/tools/tracers/inspector) ctx||420 421 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] 
        rich-text #[object! [
            rtd: #[object! [
                stack: #[none]
                color-stk: #[none]
                out: #[none]
                text: #[none]
                s-idx: #[none]
                s: #[none]
                pos: #[none]
                v: #[none]
                l: #[none]
                cur: #[none]
                pos1: #[none]
                mark: #[none]
                col: #[none]
                cols: #[none]
                nested: #[none]
                color: #[none]
                f-args: #[none]
                style!: #[none]
                style: #[none]
                rtd: #[none]
                tail-idx?: #[datatype! function!]
                push-color: #[datatype! function!]
                pop-color: #[datatype! function!]
                close-colors: #[datatype! function!]
                push: #[datatype! function!]
                pop: #[datatype! function!]
                pop-all: #[datatype! function!]
                optimize: #[datatype! function!]
            ]]
            line-height?: #[datatype! function!]
            line-count?: #[datatype! function!]
        ]] ctx||439 440 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] ctx||441 (red/objects/rich-text/rtd) ctx||441 442 #[none] #[none] 
        face! #[object! [
            type: #[none]
            offset: #[none]
            size: #[none]
            text: #[none]
            image: #[none]
            color: #[none]
            menu: #[none]
            data: #[none]
            enabled?: #[none]
            visible?: #[none]
            selected: #[none]
            flags: #[none]
            options: #[none]
            parent: #[none]
            pane: #[none]
            state: #[none]
            rate: #[none]
            edge: #[none]
            para: #[none]
            font: #[none]
            actors: #[none]
            extra: #[none]
            draw: #[none]
            on-change*: #[datatype! function!]
            on-deep-change*: #[datatype! function!]
        ]] ctx||461 462 #[none] [23 6 24 0 evt462] 
        font! #[object! [
            name: #[none]
            size: #[none]
            style: #[none]
            angle: #[none]
            color: #[none]
            anti-alias?: #[none]
            shadow: #[none]
            state: #[none]
            parent: #[none]
            on-change*: #[datatype! function!]
            on-deep-change*: #[datatype! function!]
        ]] ctx||465 466 #[none] [9 0 10 0 evt466] 
        para! #[object! [
            origin: #[none]
            padding: #[none]
            scroll: #[none]
            align: #[none]
            v-align: #[none]
            wrap?: #[none]
            parent: #[none]
            on-change*: #[datatype! function!]
        ]] ctx||469 470 #[none] [7 2 -1 0 evt470] 
        scroller! #[object! [
            position: #[none]
            page-size: #[none]
            min-size: #[none]
            max-size: #[none]
            visible?: #[none]
            vertical?: #[none]
            parent: #[none]
            on-change*: #[datatype! function!]
        ]] ctx||472 473 #[none] [7 0 -1 0 evt473] ctx||475 (red/objects/system/view) ctx||475 476 #[none] [10 4 -1 0 evt476] ctx||477 (red/objects/system/view/metrics) ctx||477 478 #[none] #[none] ctx||479 (red/objects/system/view/fonts) ctx||479 480 #[none] #[none] ctx||484 (red/objects/system/view/platform) ctx||484 485 #[none] #[none] ctx||490 (red/objects/system/view/VID) ctx||490 491 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] ctx||492 (red/objects/system/view/VID/GUI-rules) ctx||492 493 #[none] #[none] #[none] #[object! [
            title: #[none]
            name: #[none]
            mime-type: #[none]
            suffixes: #[none]
            compact?: #[none]
            encode: #[datatype! function!]
            encode*: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||328 329 #[none] #[none] ctx||494 (red/objects/system/view/VID/GUI-rules/processors) ctx||494 495 #[none] #[none] ctx||499 (red/objects/system/view/VID/opts-proto) ctx||499 500 #[none] #[none] #[none] #[object! [
            Title: #[none]
            Name: #[none]
            Mime-Type: #[none]
            Suffixes: #[none]
            encode: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||546 547 #[none] #[none] #[none] #[object! [
            ignore-empty?: #[none]
            strict?: #[none]
            quote-char: #[none]
            double-quote: #[none]
            quotable-chars: #[none]
            parsed?: #[none]
            non-aligned: #[none]
            to-csv-line: #[datatype! function!]
            escape-value: #[datatype! function!]
            next-column-name: #[datatype! function!]
            make-header: #[datatype! function!]
            get-columns: #[datatype! function!]
            encode-map: #[datatype! function!]
            encode-maps: #[datatype! function!]
            encode-flat: #[datatype! function!]
            encode-blocks: #[datatype! function!]
        ]] ctx||553 554 #[none] #[none] #[none] #[object! [
            non-line-ws: #[none]
            ws: #[none]
            ws*: #[none]
            ws+: #[none]
            sep: #[none]
            digit: #[none]
            non-zero-digit: #[none]
            hex-char: #[none]
            chars: #[none]
            not-word-char: #[none]
            word-1st: #[none]
            word-char: #[none]
            sign: #[none]
            int: #[none]
            frac: #[none]
            exp: #[none]
            number: #[none]
            numeric-literal: #[none]
            string-literal: #[none]
            json-esc-ch: #[none]
            unescape: #[datatype! function!]
            json-object: #[none]
            property-list: #[none]
            property: #[none]
            json-name: #[none]
            array-list: #[none]
            json-array: #[none]
            json-value: #[none]
            stack: #[none]
            push: #[datatype! function!]
            pop: #[datatype! function!]
            _out: #[none]
            _res: #[none]
            _tmp: #[none]
            _str: #[none]
            _s: #[none]
            _e: #[none]
            mark: #[none]
            line-ct: #[none]
            last-lf: #[none]
            emit: #[datatype! function!]
        ]] ctx||566 567 #[none] #[none] #[none] #[object! [
            indent: #[none]
            indent-level: #[none]
            normal-chars: #[none]
            escapes: #[none]
            init-state: #[datatype! function!]
            emit-indent: #[datatype! function!]
            emit-key-value: #[datatype! function!]
            red-to-json-value: #[datatype! function!]
        ]] ctx||572 573 #[none] #[none] context #[object! [
            Title: #[none]
            Name: #[none]
            Mime-Type: #[none]
            Suffixes: #[none]
            encode: #[datatype! function!]
            decode: #[datatype! function!]
        ]] ctx||579 580 #[none] #[none] ctx||584 (red/objects/system/script/header) ctx||584 585 [#[object! [
                Title: #[none]
                Name: #[none]
                Type: #[none]
                Version: #[none]
                Date: #[none]
                File: #[none]
                Home: #[none]
                Author: #[none]
                Tabs: #[none]
                Needs: #[none]
                License: #[none]
                Note: #[none]
                History: #[none]
                Rights: #[none]
                Usage: #[none]
                Purpose: #[none]
                Comment: #[none]
                Language: #[none]
                Content: #[none]
                Owner: #[none]
            ]]] #[none]
    ] #[hash![ctx||56 [spec body] ctx||57 [
            value1 
            value2
        ] ctx||58 [
            code 
            safer local all result
        ] ctx||59 [value] ctx||60 [
            return status
        ] ctx||61 [
            data
        ] ctx||62 [
            value
        ] ctx||63 [
            value
        ] ctx||64 [
            value
        ] ctx||65 [s] ctx||66 [s] ctx||67 [s] ctx||68 [s] ctx||69 [s] ctx||70 [s] ctx||71 [value] ctx||72 [value] ctx||73 [value] ctx||74 [value] ctx||75 [value] ctx||76 [value] ctx||77 [value] ctx||78 [value] ctx||79 [value] ctx||80 [value] ctx||81 [value] ctx||82 [value] ctx||83 [value] ctx||84 [value] ctx||85 [value] ctx||86 [value] ctx||87 [value] ctx||88 [value] ctx||89 [value] ctx||90 [value] ctx||91 [value] ctx||92 [value] ctx||93 [value] ctx||94 [value] ctx||95 [value] ctx||96 [value] ctx||97 [value] ctx||98 [value] ctx||99 [value] ctx||100 [value] ctx||101 [value] ctx||102 [value] ctx||103 [value] ctx||104 [value] ctx||105 [value] ctx||106 [value] ctx||107 [value] ctx||108 [value] ctx||109 [value] ctx||110 [value] ctx||111 [value] ctx||112 [value] ctx||113 [value] ctx||114 [value] ctx||115 [value] ctx||116 [value] ctx||117 [value] ctx||118 [value] ctx||119 [value] ctx||120 [value] ctx||121 [value] ctx||122 [value] ctx||123 [value] ctx||124 [value] ctx||125 [value] ctx||126 [value] ctx||127 [value] ctx||128 [value] ctx||129 [value] ctx||130 [value] ctx||131 [value] ctx||132 [value] ctx||133 [value] ctx||134 [value] ctx||135 [value] ctx||136 [value] ctx||137 [value] ctx||138 [value] ctx||139 [value] ctx||140 [value] ctx||141 [value] ctx||142 [value] ctx||143 [value] ctx||144 [value] ctx||145 [value] ctx||146 [value] ctx||147 [value] ctx||148 [value] ctx||149 [value] ctx||150 [value] ctx||151 [value] ctx||152 [value] ctx||153 [value] ctx||154 [value] ctx||155 [value] ctx||156 [value] ctx||157 [value] ctx||158 [value] ctx||159 [value] ctx||160 [value] ctx||161 [value] ctx||162 [value] ctx||163 [value] ctx||164 [value] ctx||165 [value] ctx||166 [value] ctx||167 [value] ctx||168 [value] ctx||169 [value] ctx||170 [value] ctx||171 [value] ctx||172 [value] ctx||173 [value] ctx||174 [value] ctx||175 [value] ctx||176 [
            spec
        ] ctx||177 [
            series 
            value
        ] ctx||178 [
            series1 
            series2
        ] ctx||179 [
            series 
            value 
            only
        ] ctx||180 [
            series 
            pattern 
            value 
            all 
            deep 
            case local parse? form? quote? deep? rule many? size seek active?
        ] ctx||181 [
            datum 
            safe local match 
            order infix tally enter recur count operator
        ] ctx||182 [
            spec
        ] ctx||183 [
            p-indent 
            on-parse-event
        ] ctx||185 [
            event 
            match? 
            rule 
            input 
            stack
        ] ctx||186 [
            input 
            rules 
            case 
            part 
            limit
        ] ctx||187 [
            path
        ] ctx||188 [
            buffer 
            next 
            fast
        ] ctx||189 [
            source 
            header 
            all 
            trap 
            next 
            position 
            part 
            length 
            into 
            out 
            as 
            type local codec suffix name mime pre-load err
        ] ctx||190 [
            where 
            value 
            header 
            header-data 
            all 
            length 
            as 
            format local dst codec data suffix find-encoder? name only pos header-str k v
        ] ctx||191 [
            err-type 
            err-id 
            args
        ] ctx||192 [
            str 
            n 
            left 
            with 
            c
        ] ctx||193 [
            a 
            b local r
        ] ctx||194 [
            a 
            b local r
        ] ctx||195 [value1] ctx||196 [
            path local colon? slash? len i c dst
        ] ctx||197 [file] ctx||198 [
            dir
        ] ctx||199 [local path] ctx||200 [
            dir
        ] ctx||201 [
            path 
            deep local dirs end created dir
        ] ctx||202 [
            series 
            width 
            index 
            pos 
            into 
            output
        ] ctx||203 [local args at-arg2 ws buf s] ctx||204 [
            body 
            into 
            collected local keep rule pos
        ] ctx||205 [
            path local file buffer flag
        ] ctx||206 [
            series dlm local s 
            num
        ] ctx||207 [
            path
        ] ctx||208 [
            file 
            only 
            dir local out cnt f not-file? prot
        ] ctx||209 [
            target local dir pos
        ] ctx||210 [file callback do-args local ws saved src code header? header list c done? found? obj 
            parent path args
        ] ctx||211 [
            url local so hash file path
        ] ctx||212 [
            url
        ] ctx||213 [
            url 
            update 
            binary local path data
        ] ctx||214 [
            url 
            update 
            as 
            type local path file
        ] ctx||215 [
            url 
            update
        ] ctx||216 [
            angle
        ] ctx||217 [
            angle
        ] ctx||218 [
            angle
        ] ctx||219 [
            cosine
        ] ctx||220 [
            sine
        ] ctx||221 [
            tangent
        ] ctx||222 [
            y 
            x
        ] ctx||223 [
            number
        ] ctx||224 [
            date
        ] ctx||225 [
            date
        ] ctx||226 [data local class used total i c frm unit] ctx||227 [
            src
        ] ctx||228 [
            block
        ] ctx||229 [
            values local result value
        ] ctx||230 [
            block
        ] ctx||231 [
            series
        ] ctx||232 [
            body local t0
        ] ctx||233 [
            code 
            times n local result 
            text dt unit
        ] ctx||234 [
            version 
            build 
            words 
            platform 
            catalog 
            state 
            modules 
            codecs 
            schemes 
            ports 
            locale 
            options 
            script 
            standard 
            lexer 
            console 
            view 
            reactivity 
            tools
        ] ctx||236 [
            date 
            git 
            config
        ] ctx||238 [
            config-name 
            OS 
            OS-version 
            ABI 
            link? 
            debug? 
            encap? 
            build-prefix 
            build-basename 
            build-suffix 
            format 
            type 
            target 
            cpu-version 
            verbosity 
            sub-system 
            runtime? 
            use-natives? 
            debug-safe? 
            dev-mode? 
            static-link? 
            need-main? 
            PIC? 
            base-address 
            dynamic-linker 
            syscall 
            export-ABI 
            stack-align-16? 
            literal-pool? 
            unicode? 
            red-pass? 
            red-only? 
            red-store-bodies? 
            red-strict-check? 
            red-tracing? 
            red-help? 
            redbin-compress? 
            legacy 
            gui-console? 
            libRed? 
            libRedRT? 
            libRedRT-update? 
            GUI-engine 
            draw-engine 
            modules 
            show 
            command-line 
            show-func-map?
        ] ctx||240 [
            datatypes 
            actions 
            natives 
            accessors 
            errors
        ] ctx||242 [
            throw 
            note 
            syntax 
            script 
            math 
            access 
            reserved1 
            reserved2 
            user 
            internal
        ] ctx||244 [
            code 
            type 
            break 
            return 
            throw 
            continue 
            while-cond
        ] ctx||246 [
            code 
            type 
            no-load
        ] ctx||248 [
            code 
            type 
            invalid 
            missing 
            no-header 
            no-rs-header 
            bad-header 
            malconstruct 
            bad-char
        ] ctx||250 [
            code 
            type 
            no-value 
            need-value 
            not-defined 
            not-in-context 
            no-arg 
            expect-arg 
            expect-val 
            expect-type 
            cannot-use 
            invalid-arg 
            invalid-type 
            invalid-type-spec 
            invalid-key-type 
            invalid-op 
            no-op-arg 
            bad-op-spec 
            invalid-data 
            invalid-part 
            not-same-type 
            not-same-class 
            not-related 
            bad-func-def 
            bad-func-arg 
            bad-func-extern 
            no-refine 
            bad-refines 
            bad-refine 
            dup-refine 
            word-first 
            empty-path 
            unset-path 
            invalid-path 
            invalid-path-set 
            invalid-path-get 
            bad-path-type 
            bad-path-type2 
            bad-path-set 
            bad-field-set 
            dup-vars 
            past-end 
            missing-arg 
            out-of-range 
            invalid-chars 
            invalid-compare 
            wrong-type 
            invalid-refine-arg 
            type-limit 
            size-limit 
            no-return 
            throw-usage 
            locked-word 
            protected 
            bad-bad 
            bad-make-arg 
            bad-to-arg 
            invalid-months 
            invalid-spec-field 
            missing-spec-field 
            move-bad 
            too-long 
            invalid-char 
            bad-loop-series 
            wrong-denom 
            bad-denom 
            invalid-obj-evt 
            parse-rule 
            parse-end 
            parse-invalid-ref 
            parse-block 
            parse-unsupported 
            parse-infinite 
            parse-stack 
            parse-keep 
            parse-into-bad 
            parse-into-type 
            draw-invalid 
            draw-infinite 
            invalid-data-facet 
            face-type 
            not-window 
            bad-window 
            not-linked 
            not-event-type 
            invalid-facet-type 
            vid-invalid-syntax 
            rtd-invalid-syntax 
            rtd-no-match 
            react-bad-func 
            react-not-enough 
            react-no-match 
            react-bad-obj 
            react-gctx 
            lib-invalid-arg 
            rb-invalid-record
        ] ctx||252 [
            code 
            type 
            zero-divide 
            overflow 
            positive
        ] ctx||254 [
            code 
            type 
            cannot-open 
            cannot-close 
            invalid-utf8 
            not-open 
            no-connect 
            no-scheme 
            unknown-scheme 
            invalid-spec 
            invalid-port 
            invalid-actor 
            no-port-action 
            no-create 
            no-codec 
            bad-media 
            invalid-cmd
        ] ctx||256 [
            code 
            type
        ] ctx||258 [
            code 
            type
        ] ctx||260 [
            code 
            type 
            message
        ] ctx||262 [
            code 
            type 
            bad-path 
            not-here 
            no-memory 
            wrong-mem 
            stack-overflow 
            limit-hit 
            too-deep 
            no-cycle 
            feature-na 
            not-done 
            invalid-error 
            routines 
            red-system 
            deprecated
        ] ctx||264 [
            interpreted? 
            last-error 
            stack-trace 
            source-files 
            callbacks 
            GC
        ] ctx||266 [] ctx||267 [
            lexer? 
            parse? 
            sort? 
            change? 
            deep? 
            port? 
            bits 
            on-change*
        ] ctx||269 [word old new local idx] ctx||270 [
            active? 
            series-cycles 
            nodes-cycles
        ] ctx||272 [] ctx||274 [
            language 
            language* 
            locale 
            locale* 
            months 
            days 
            currencies
        ] ctx||276 [
            list 
            on-change* 
            on-deep-change*
        ] ctx||278 [word old new] ctx||279 [owner word target action new index part] ctx||280 [
            boot 
            home 
            path 
            script 
            cache 
            thru-cache 
            args 
            do-arg 
            debug 
            secure 
            quiet 
            binary-base 
            decimal-digits 
            money-digits 
            module-paths 
            file-types 
            float 
            on-change* 
            on-deep-change*
        ] ctx||282 [
            pretty? 
            full? 
            on-change*
        ] ctx||284 [word old new] ctx||285 [word old new] ctx||286 [owner word target action new index part] ctx||287 [
            title header parent path 
            args
        ] ctx||289 [
            header 
            port 
            error 
            file-info 
            url-parts 
            scheme
        ] ctx||291 [
            Title Name Type Version Date File Home Author Tabs Needs License Note History 
            Rights Usage Purpose Comment Language Content Owner
        ] ctx||301 [
            spec scheme actor awake state data extra
        ] ctx||303 [
            code type id arg1 arg2 arg3 near where stack files
        ] ctx||305 [
            name size date type
        ] ctx||308 [
            scheme user-info host port path target query fragment ref
        ] ctx||310 [
            name title info actor awake
        ] ctx||312 [
            pre-load 
            err-pos 
            exit-states 
            trapper 
            tracer
        ] ctx||314 [
            event 
            input 
            type 
            line 
            token
        ] ctx||315 [
            event 
            input 
            type 
            line 
            token
        ] ctx||316 [
            title 
            name 
            mime-type 
            suffixes 
            encode 
            decode
        ] ctx||319 [
            title 
            name 
            mime-type 
            suffixes 
            encode 
            decode
        ] ctx||322 [
            title 
            name 
            mime-type 
            suffixes 
            encode 
            decode
        ] ctx||325 [
            title 
            name 
            mime-type 
            suffixes 
            encode 
            decode
        ] ctx||328 [
            title 
            name 
            mime-type 
            suffixes 
            compact? 
            encode 
            encode* 
            decode
        ] ctx||331 [data where] ctx||332 [
            on-change*
        ] ctx||334 [word old new] ctx||335 [
            on-change* 
            on-deep-change*
        ] ctx||337 [word old new] ctx||338 [owner word target action new index part] ctx||339 [spec] ctx||340 [spec] ctx||341 [
            relations 
            queue 
            eat-events? 
            debug? 
            types! 
            not-safe! 
            add-relation 
            identify-sources 
            eval 
            eval-reaction 
            pending? 
            check
        ] ctx||343 [
            obj 
            word 
            reaction 
            targets local new-rel
        ] ctx||344 [path reaction ctx local obj 
            p found? slice
        ] ctx||345 [code safe local result] ctx||346 [reactor reaction target mark] ctx||347 [reactor reaction local q] ctx||348 [reactor only field local pos reaction q q'] ctx||349 [
            body local result
        ] ctx||350 [
            face 
            deep local list pos f
        ] ctx||351 [] ctx||352 [local limit count obj field reaction target list] ctx||353 [
            field 
            reaction local obj rule item
        ] ctx||354 [] ctx||355 [
            reactor 
            field 
            target local pos
        ] ctx||356 [
            reaction 
            link 
            objects 
            unlink 
            src 
            later 
            with 
            ctx local objs found? rule item pos obj
        ] ctx||357 [
            spec 
            native 
            dispatch
        ] ctx||358 [
            =scheme =user-info =host =port =path =query =fragment 
            vars 
            alpha 
            digit 
            alpha-num 
            hex-digit 
            gen-delims 
            sub-delims 
            reserved 
            unreserved 
            pct-encoded 
            alpha-num+ 
            scheme-char 
            url-rules 
            scheme-part 
            hier-part 
            authority 
            user-info 
            IP-literal 
            host 
            port 
            path-abempty 
            path-absolute 
            path-rootless 
            path-empty 
            any-segments 
            segment 
            segment-nz 
            segment-nz-nc 
            pchar 
            query 
            fragment 
            parse-url
        ] ctx||360 [more] ctx||361 [
            url 
            throw-error local scheme user-info host port path target query fragment ref
        ] ctx||362 [
            url
        ] ctx||363 [url-obj local result] ctx||364 [
            exec 
            protos 
            macros 
            stack 
            syms 
            depth 
            active? 
            trace? 
            s 
            do-quit 
            throw-error 
            syntax-error 
            do-safe 
            do-code 
            rebind-all 
            count-args 
            arg-mode? 
            func-arity? 
            value-path? 
            fetch-next 
            eval 
            do-macro 
            register-macro 
            reset 
            expand
        ] ctx||366 [] ctx||367 [error cmd code local w] ctx||368 [s e] ctx||369 [code manual with cmd local res t? src] ctx||370 [code cmd local p] ctx||371 [local rule p] ctx||372 [spec block local total pos] ctx||373 [spec idx] ctx||374 [spec with path block local arity pos] ctx||375 [path local value i item selectable] ctx||376 [code local i left item item2 value fn-spec path f-arity at-op? op-mode] ctx||377 [code cmd local after expr] ctx||378 [name pos arity local cmd saved p v res] ctx||379 [spec local cnt rule p name macro pos valid? named?] ctx||380 [job] ctx||381 [
            code job 
            clean local rule e pos cond value then else cases body keep? expr src saved file new
        ] ctx||382 [
            code 
            clean local job saved
        ] ctx||383 [
            fun-stk 
            expr-stk 
            watching 
            profiling 
            indent 
            hist-length 
            dbg-usage 
            options 
            calc-max 
            show-context 
            show-parents 
            show-stack 
            show-watching 
            do-command 
            debugger 
            tracers 
            profiler 
            do-handler
        ] ctx||385 [
            debug 
            trace 
            profile
        ] ctx||387 [
            active? 
            show-stack? 
            show-parents? 
            show-locals? 
            stack-indent?
        ] ctx||389 [
            indent?
        ] ctx||391 [
            sort-by 
            types
        ] ctx||393 [used] ctx||394 [ctx local w out] ctx||395 [event local list w pos] ctx||396 [local indent frame] ctx||397 [local w out] ctx||398 [event local watch list w cmd add?] ctx||399 [
            event 
            code 
            offset 
            value 
            ref 
            frame local store idx pos indent sch out set-ref limit
        ] ctx||400 [
            emit 
            opening-marker 
            closing-markers 
            mold-part 
            dumper 
            push 
            drop 
            pop 
            top-of 
            step 
            mold-size 
            free 
            data 
            guided-trace 
            inspector
        ] ctx||402 [value part only local r open close] ctx||403 [
            event 
            code 
            offset 
            value 
            ref 
            frame
        ] ctx||404 [s i dup n] ctx||405 [s n] ctx||406 [s] ctx||407 [s] ctx||408 [s down] ctx||409 [
            list 
            put 
            get
        ] ctx||411 [block] ctx||412 [] ctx||413 [
            debug? 
            inspect 
            event-filter 
            scope-filter 
            inspect-sub-exprs? 
            func-depth 
            expr-depth 
            path 
            fetched 
            fetched' 
            pushed 
            pushed' 
            subexprs 
            stack 
            saved 
            stack-period 
            save-level 
            unroll-level 
            reset 
            collector
        ] ctx||415 [frame local word value] ctx||416 [local i n value word] ctx||417 [local block-name] ctx||418 [
            event 
            code 
            offset 
            value 
            ref 
            frame local call saved-frame isop? bgn word
        ] ctx||419 [
            inspect 
            code 
            all? 
            deep? 
            debug? local b rule
        ] ctx||420 [
            fixed-width 
            last-path 
            constants 
            type-names 
            ignored-words 
            fetched-index 
            fetched'-index 
            inspect
        ] ctx||422 [
            data 
            event 
            code 
            offset 
            value 
            ref local word 
            report? full width left right indent indent2 level expr path p pexpr orig-expr name
        ] ctx||423 [
            event 
            code 
            offset 
            value 
            ref 
            frame local anon time opt pos entry
        ] ctx||424 [code handler] ctx||425 [
            code 
            by 
            cat local saved rank name cnt duration
        ] ctx||426 [
            code 
            raw 
            deep 
            all 
            debug
        ] ctx||427 [
            code 
            later
        ] ctx||428 [
            hex local str bin
        ] ctx||429 [
            point 
            offset 
            size
        ] ctx||430 [
            A 
            B local A1 B1 A2 B2
        ] ctx||431 [
            A 
            B local d
        ] ctx||432 [
            event 
            no-wait
        ] ctx||433 [
            value
        ] ctx||434 [local handle screen] ctx||435 [
            face 
            with 
            text local h
        ] ctx||436 [
            face 
            pos 
            lower local opt
        ] ctx||437 [
            face 
            pt
        ] ctx||438 [
            face 
            pt
        ] ctx||439 [
            rtd 
            line-height? 
            line-count?
        ] ctx||441 [
            stack 
            color-stk 
            out text s-idx s pos v l cur pos1 
            mark col cols 
            nested 
            color 
            f-args 
            style! 
            style 
            rtd 
            tail-idx? 
            push-color 
            pop-color 
            close-colors 
            push 
            pop 
            pop-all 
            optimize
        ] ctx||443 [] ctx||444 [c] ctx||445 [local entry pos] ctx||446 [local pos] ctx||447 [style] ctx||448 [style local entry type] ctx||449 [mark local first? i] ctx||450 [local cur pos range pos1 e s l mov] ctx||451 [
            spec 
            only 
            with 
            face
        ] ctx||452 [
            face 
            pos
        ] ctx||453 [
            face
        ] ctx||454 [
            face 
            type 
            total 
            axis local res
        ] ctx||455 [
            face 
            flag 
            clear 
            toggle local flags pos
        ] ctx||456 [face] ctx||457 [owner word target action new index part state forced? local w diff? faces face modal? screen pane] ctx||458 [
            face 
            init local faces visible?
        ] ctx||459 [face type old new local parent found] ctx||460 [parent local f] ctx||461 [
            type 
            offset 
            size 
            text 
            image 
            color 
            menu 
            data 
            enabled? 
            visible? 
            selected 
            flags 
            options 
            parent 
            pane 
            state 
            rate 
            edge 
            para 
            font 
            actors 
            extra 
            draw 
            on-change* 
            on-deep-change*
        ] ctx||463 [word old new local same-pane? f new-type saved value] ctx||464 [owner word target action new index part] ctx||465 [
            name 
            size 
            style 
            angle 
            color 
            anti-alias? 
            shadow 
            state 
            parent 
            on-change* 
            on-deep-change*
        ] ctx||467 [word old new] ctx||468 [owner word target action new index part] ctx||469 [
            origin 
            padding 
            scroll 
            align 
            v-align 
            wrap? 
            parent 
            on-change*
        ] ctx||471 [word old new local f] ctx||472 [
            position 
            page-size 
            min-size 
            max-size 
            visible? 
            vertical? 
            parent 
            on-change*
        ] ctx||474 [word old new] ctx||475 [
            screens 
            event-port 
            metrics 
            fonts 
            platform 
            VID 
            handlers 
            evt-names 
            capture-events 
            awake 
            on-change* 
            capturing? 
            auto-sync? 
            debug? 
            silent? 
            GPU?
        ] ctx||477 [
            screen-size 
            dpi 
            paddings 
            margins 
            def-heights 
            fixed-heights 
            misc 
            colors
        ] ctx||479 [
            system 
            fixed 
            sans-serif 
            serif 
            size
        ] ctx||481 [face event local result] ctx||482 [event with face local result result2 
            name handler screen pos
        ] ctx||483 [word old new local screen wins win] ctx||484 [
            mouse-event? 
            make-null-handle 
            fetch-all-screens 
            get-current-screen 
            all-windows-closed? 
            refresh-screens 
            get-screen-size 
            size-text 
            on-change-facet 
            update-text 
            update-font 
            update-para 
            destroy-view 
            detach-image 
            update-view 
            refresh-window 
            redraw 
            show-window 
            make-view 
            draw-image 
            draw-face 
            do-event-loop 
            exit-event-loop 
            request-font 
            request-file 
            request-dir 
            text-box-metrics 
            update-scroller 
            set-dark-mode 
            support-dark-mode? 
            toggle-GPU 
            init 
            version 
            build 
            product
        ] ctx||486 [local closed?] ctx||487 [local svs spec screen] ctx||488 [local svs colors fonts] ctx||489 [
            image 
            cmd 
            transparent
        ] ctx||490 [
            styles 
            extras 
            GUI-rules 
            debug? 
            origin 
            spacing 
            pos-size! 
            containers 
            default-font 
            opts-proto 
            throw-error 
            process-reactors 
            opt-as-integer 
            calc-size 
            align-faces 
            resize-child-panels 
            clean-style 
            process-draw 
            pre-load 
            preset-focus 
            add-option 
            add-flag 
            add-bounds 
            fetch-value 
            fetch-argument 
            fetch-expr 
            fetch-options 
            make-actor
        ] ctx||492 [
            active? 
            debug? 
            processors 
            general 
            OS 
            user 
            process
        ] ctx||494 [
            count-faces 
            cancel-captions 
            ok-captions 
            Cancel-OK
        ] ctx||496 [parent type local cnt f] ctx||497 [
            root local pos-x last-but pos-y f
        ] ctx||498 [root local list name] ctx||499 [
            type offset size size-x text color enabled? visible? selected image 
            rate font flags options para data extra actors draw now? init
        ] ctx||501 [spec] ctx||502 [reactors local res 
            f blk later? ctx face
        ] ctx||503 [value local i] ctx||504 [face local min-sz data txt s len mark e new] ctx||505 [pane dir align max-sz local edge? top-left? axis svmm face offset mar type] ctx||506 [tab local tp-size pad pane] ctx||507 [tmpl type local para font] ctx||508 [code local rule pos color] ctx||509 [value local color] ctx||510 [face local p] ctx||511 [opts spec local field value] ctx||512 [obj facet field flag local blk] ctx||513 [proto spec] ctx||514 [blk local value] ctx||515 [expected pos local spec type value] ctx||516 [code] ctx||517 [
            face opts style spec css reactors styling? 
            no-skip 
            tight local opt? divides calc-y? do-with scaling obj-spec! sel-spec! rate! color! cursor! value match? drag-on default hint cursor tight? later? max-sz p words user-size? oi x font face-font field actors name f s b pad sz min-sz new mar
        ] ctx||518 [obj name body spec] ctx||519 [
            spec 
            tight 
            options 
            user-opts 
            flags 
            flgs 
            only 
            parent 
            panel 
            divides 
            styles 
            css local axis anti 
            background! list reactors local-styles pane-size direction align begin size max-sz current global? below? origin spacing top-left bound cursor opts opt-words re-align sz words reset focal-face svmp pad value anti2 at-offset later? name styling? style styled? st actors face h pos styled w blk vid-align prev mar divide? index dir pad2 image
        ] ctx||520 [
            no-wait local result screen win
        ] ctx||521 [] ctx||522 [code local result error] ctx||523 [face event type local result 
            act name
        ] ctx||524 [
            face 
            with 
            parent 
            force local show? f pending owner word target action new index part state handle new? p field pane
        ] ctx||525 [
            all 
            only 
            face local all? svs pane
        ] ctx||526 [
            spec 
            tight 
            options 
            opts 
            flags 
            flgs 
            no-wait 
            no-sync local sync? result
        ] ctx||527 [
            face 
            x 
            y 
            with 
            parent local pos
        ] ctx||528 [
            style 
            spec 
            blk 
            offset 
            xy 
            size 
            wh local 
            svv face styles model opts css
        ] ctx||529 [
            face local depth f
        ] ctx||530 [
            code local r e old
        ] ctx||531 [
            face 
            orientation
        ] ctx||532 [
            face
        ] ctx||533 [
            faces 
            back local origin checks flags f pane p
        ] ctx||534 [
            name 
            fun local svh
        ] ctx||535 [
            id local svh pos
        ] ctx||536 [
            font 
            ft 
            mono
        ] ctx||537 [
            title 
            text 
            file 
            name 
            filter 
            list 
            save 
            multi
        ] ctx||538 [
            title 
            text 
            dir 
            name 
            filter 
            list 
            keep 
            multi
        ] ctx||539 [
            face 
            after 
            before local from p
        ] ctx||540 [
            face 
            body 
            with 
            spec 
            post 
            sub post? local exec
        ] ctx||541 [
            msg
        ] ctx||543 [face event local drag-evt type flags result drag-info done? new box] ctx||545 [face event local flags faces back? pane new opt] ctx||546 [
            Title 
            Name 
            Mime-Type 
            Suffixes 
            encode 
            decode
        ] ctx||551 [data where] ctx||552 [text] ctx||553 [
            ignore-empty? 
            strict? 
            quote-char 
            double-quote 
            quotable-chars 
            parsed? 
            non-aligned 
            to-csv-line 
            escape-value 
            next-column-name 
            make-header 
            get-columns 
            encode-map 
            encode-maps 
            encode-flat 
            encode-blocks
        ] ctx||555 [
            data 
            delimiter
        ] ctx||556 [
            value 
            delimiter local quot? len
        ] ctx||557 [
            name local length index position previous
        ] ctx||558 [
            length local key
        ] ctx||559 [
            data local columns
        ] ctx||560 [
            data 
            delimiter local output keys length key index line
        ] ctx||561 [
            data 
            delimiter local columns value line column
        ] ctx||562 [
            data 
            delimiter 
            size
        ] ctx||563 [
            data 
            delimiter local length line csv-line
        ] ctx||564 [
            data 
            with 
            delimiter 
            header 
            as-columns 
            as-records 
            flat 
            trim 
            quote 
            qt-char local disallowed refs output out-map longest line value record newline quotchars valchars quoted-value char normal-value s e single-value values add-value add-line length index line-rule init parsed? mark key-index key
        ] ctx||565 [
            data 
            with 
            delimiter 
            skip 
            size 
            quote 
            qt-char local longest keyval? types value
        ] ctx||566 [
            non-line-ws 
            ws 
            ws* 
            ws+ 
            sep 
            digit 
            non-zero-digit 
            hex-char 
            chars 
            not-word-char 
            word-1st 
            word-char 
            sign 
            int 
            frac 
            exp 
            number 
            numeric-literal 
            string-literal 
            json-esc-ch 
            unescape 
            json-object 
            property-list 
            property 
            json-name 
            array-list 
            json-array 
            json-value 
            stack 
            push 
            pop 
            _out 
            _res 
            _tmp 
            _str 
            _s _e 
            mark 
            line-ct 
            last-lf 
            emit
        ] ctx||568 [val] ctx||569 [] ctx||570 [value] ctx||571 [
            input
        ] ctx||572 [
            indent 
            indent-level 
            normal-chars 
            escapes 
            init-state 
            emit-indent 
            emit-key-value 
            red-to-json-value
        ] ctx||574 [ind ascii?] ctx||575 [output level] ctx||576 [output sep map key local value] ctx||577 [output value local special-char mark1 mark2 escape int hi lo v keys k] ctx||578 [
            data 
            pretty indent 
            ascii local result
        ] ctx||579 [
            Title 
            Name 
            Mime-Type 
            Suffixes 
            encode 
            decode
        ] ctx||582 [data where] ctx||583 [text] ctx||584 [Title Name Type Version Date File Home Author Tabs Needs License Note History Rights Usage Purpose Comment Language Content Owner] ctx||605 [v only] ctx||622 [
            scheme 
            user-info 
            host 
            port 
            path 
            target 
            query 
            fragment 
            ref
        ] ctx||642 [face]]] [
        random 
        reflect 
        to 
        form 
        mold 
        modify 
        absolute 
        add 
        divide 
        multiply 
        negate 
        power 
        remainder 
        round 
        subtract 
        even? 
        odd? 
        and~ 
        complement 
        or~ 
        xor~ 
        append 
        at 
        back 
        change 
        clear 
        copy 
        find 
        head 
        head? 
        index? 
        insert 
        length? 
        move 
        next 
        pick 
        poke 
        put 
        remove 
        reverse 
        select 
        sort 
        skip 
        swap 
        tail 
        tail? 
        take 
        trim 
        create 
        close 
        delete 
        open 
        open? 
        query 
        read 
        rename 
        update 
        write
    ] [+ add - subtract * multiply / divide // modulo %"" remainder = equal? <> not-equal? == strict-equal? =? same? < lesser? > greater? <= lesser-or-equal? >= greater-or-equal? << shift-left >> shift-right ">>>" shift-logical ** power 
        and and~ 
        or or~ 
        xor xor~
    ] [datatype! 
        make unset! none! logic! block! string! integer! word! error! typeset! file! url! set-word! get-word! lit-word! refinement! binary! paren! char! issue! path! set-path! get-path! lit-path! native! action! op! function! routine! object! bitset! float! triple! vector! map! hash! pair! percent! tuple! image! time! tag! email! handle! date! port! money! ref! point2D! point3D! event! none set true false random reflect to form mold modify absolute add divide multiply negate power remainder round subtract even? odd? complement append at back change clear copy find head head? index? insert length? move next pick poke put remove reverse select sort skip swap tail tail? take trim create close delete open open? query read rename update write if unless either any all while until loop repeat forever foreach forall remove-each func function does has switch case do reduce compose get print prin equal? not-equal? strict-equal? lesser? greater? lesser-or-equal? greater-or-equal? same? not type? stats bind in parse union unique intersect difference exclude complement? dehex enhex negative? positive? max min shift to-hex sine cosine tangent arcsine arccosine arctangent arctangent2 NaN? zero? log-2 log-10 log-e exp square-root construct value? try uppercase lowercase as-pair as-point2D as-point3D as-money break continue exit return throw catch extend debase enbase to-local-file wait checksum unset new-line new-line? context? set-env get-env list-env now sign? as call size? browse compress decompress recycle transcode apply quit-return set-quiet set-slot-quiet shift-right shift-left shift-logical last-lf? get-current-dir set-current-dir create-dir exists? os-info as-color as-ipv4 as-rgba count-chars stack-size? pick-stack frame-index? collect-calls tracing? read-clipboard write-clipboard write-stdout yes on no off tab cr newline lf escape slash sp space null crlf enter dot comma dbl-quote pi Rebol null-handle internal! external! number! planar! any-point! scalar! any-word! all-word! any-list! any-path! any-block! any-function! any-object! any-string! series! immediate! default! any-type! aqua beige black blue brick brown coal coffee crimson cyan forest gold gray green ivory khaki leaf linen magenta maroon mint navy oldrab olive orange papaya pewter pink purple reblue rebolor red sienna silver sky snow tanned teal violet water wheat white yello yellow glass transparent routine also attempt comment quit empty? ?? probe quote first second third fourth fifth last spec-of body-of words-of class-of values-of bitset? binary? block? char? email? file? float? get-path? get-word? hash? integer? issue? lit-path? lit-word? logic? map? none? pair? paren? path? percent? refinement? set-path? set-word? string? tag? time? typeset? tuple? unset? url? word? image? date? money? ref? point2D? point3D? handle? error? action? native? datatype? function? object? op? routine? vector? any-list? any-block? any-function? any-object? any-path? any-string? any-word? series? number? immediate? scalar? all-word? any-point? planar? to-bitset to-binary to-block to-char to-email to-file to-float to-get-path to-get-word to-hash to-integer to-issue to-lit-path to-lit-word to-logic to-map to-none to-pair to-paren to-path to-percent to-refinement to-set-path to-set-word to-string to-tag to-time to-typeset to-tuple to-unset to-url to-word to-image to-date to-money to-ref to-point2D to-point3D context alter offset? repend replace math charset body p-indent on-parse-event parse-trace suffix? scan load save cause-error pad mod modulo eval-set-path to-red-file dir? normalize-dir what-dir change-dir make-dir extract extract-boot-args collect flip-exe-flag split dirize clean-path split-path do-file path-thru exists-thru? read-thru load-thru do-thru cos sin tan acos asin atan atan2 sqrt to-UTC-date to-local-date show-memory-stats transcode-trace rejoin sum average last? dt time-it clock single? keys-of object halt system version build date git config config-name Linux OS OS-version ABI link? debug? encap? build-prefix build-basename build-suffix format ELF type dll target IA-32 cpu-version verbosity sub-system console runtime? use-natives? debug-safe? dev-mode? static-link? need-main? PIC? base-address dynamic-linker syscall export-ABI stack-align-16? literal-pool? unicode? red-pass? red-only? red-store-bodies? red-strict-check? red-tracing? red-help? redbin-compress? legacy gui-console? libRed? libRedRT? libRedRT-update? GUI-engine native draw-engine modules show command-line show-func-map? words platform catalog datatypes actions natives accessors errors code while-cond note no-load syntax invalid missing no-header no-rs-header bad-header malconstruct bad-char script no-value need-value not-defined not-in-context no-arg expect-arg expect-val expect-type cannot-use invalid-arg invalid-type invalid-type-spec invalid-key-type invalid-op no-op-arg bad-op-spec invalid-data invalid-part not-same-type not-same-class not-related bad-func-def bad-func-arg bad-func-extern no-refine bad-refines bad-refine dup-refine word-first empty-path unset-path invalid-path invalid-path-set invalid-path-get bad-path-type bad-path-type2 bad-path-set bad-field-set dup-vars past-end missing-arg out-of-range invalid-chars invalid-compare wrong-type invalid-refine-arg type-limit size-limit no-return throw-usage locked-word protected bad-bad bad-make-arg bad-to-arg invalid-months invalid-spec-field missing-spec-field move-bad too-long invalid-char bad-loop-series wrong-denom bad-denom invalid-obj-evt parse-rule parse-end parse-invalid-ref parse-block parse-unsupported parse-infinite parse-stack parse-keep parse-into-bad parse-into-type draw-invalid draw-infinite invalid-data-facet face-type not-window bad-window not-linked not-event-type invalid-facet-type vid-invalid-syntax rtd-invalid-syntax rtd-no-match react-bad-func react-not-enough react-no-match react-bad-obj react-gctx lib-invalid-arg rb-invalid-record zero-divide overflow positive access cannot-open cannot-close invalid-utf8 not-open no-connect no-scheme unknown-scheme invalid-spec invalid-port invalid-actor no-port-action no-create no-codec bad-media invalid-cmd reserved1 reserved2 user message arg1 internal bad-path not-here no-memory wrong-mem stack-overflow limit-hit too-deep no-cycle feature-na not-done invalid-error routines red-system deprecated state interpreted? last-error stack-trace source-files callbacks lexer? parse? sort? change? deep? port? bits on-change* GC active? series-cycles nodes-cycles codecs schemes ports locale language language* locale* months days currencies list on-deep-change* options boot home path cache thru-cache args do-arg debug secure quiet binary-base decimal-digits money-digits module-paths file-types float pretty? full? title header parent standard Title Name Type Version Date File Home Author Tabs Needs License Note History Rights Usage Purpose Comment Language Content Owner port spec scheme actor awake data extra error id arg2 arg3 near where stack files file-info name size url-parts user-info host fragment ref info lexer pre-load err-pos exit-states 
        eof hex rawstring trapper tracer view reactivity tools + - * / // %"" = <> == =? < > <= >= << >> ">>>" ** and or xor eval-path png PNG mime-type suffixes encode decode jpeg JPEG bmp BMP gif GIF redbin Redbin compact? encode* reactor! deep-reactor! reactor deep-reactor relations queue eat-events? types! not-safe! add-relation identify-sources eval eval-reaction pending? check no-react stop-reactor clear-reactions dump-reactions relate is react? react register-scheme url-parser =scheme =user-info =host =port =path =query =fragment vars alpha digit alpha-num hex-digit gen-delims sub-delims reserved unreserved pct-encoded alpha-num+ scheme-char url-rules scheme-part hier-part authority IP-literal path-abempty path-absolute path-rootless path-empty any-segments segment segment-nz segment-nz-nc pchar parse-url decode-url encode-url preprocessor exec protos macros syms depth trace? s do-quit throw-error syntax-error do-safe do-code rebind-all count-args arg-mode? func-arity? value-path? fetch-next do-macro register-macro reset expand expand-directives fun-stk expr-stk watching profiling indent hist-length dbg-usage show-stack? show-parents? show-locals? stack-indent? trace indent? profile sort-by count types calc-max show-context show-parents show-stack show-watching do-command debugger tracers emit opening-marker closing-markers mold-part dumper push drop pop top-of step mold-size free inspect event-filter scope-filter inspect-sub-exprs? func-depth expr-depth fetched fetched' pushed pushed' subexprs saved stack-period save-level unroll-level collector guided-trace inspector fixed-width last-path constants type-names ignored-words fetched-index paren fetched'-index profiler do-handler Windows hex-to-rgb within? overlap? distance? event? send-event-os send-event face? get-current-screen size-text caret-to-offset offset-to-caret offset-to-char rich-text rtd color-stk out text s-idx pos v l cur pos1 mark col cols nested color f-args style! style tail-idx? push-color pop-color close-colors pop-all optimize rtd-layout line-height? line-count? metrics? set-flag find-flag? debug-info? on-face-deep-change* link-tabs-to-parent link-sub-to-parent update-font-faces face! face offset image menu enabled? visible? selected flags pane rate edge para font actors draw font! angle anti-alias? shadow para! origin padding scroll align v-align wrap? scroller! position page-size min-size max-size vertical? screens event-port metrics screen-size dpi paddings margins def-heights fixed-heights misc colors fonts fixed sans-serif serif VID handlers evt-names capture-events capturing? auto-sync? silent? GPU? mouse-event? make-null-handle fetch-all-screens all-windows-closed? refresh-screens get-screen-size on-change-facet update-text update-font update-para destroy-view detach-image update-view refresh-window redraw show-window make-view draw-image draw-face do-event-loop exit-event-loop request-font request-file request-dir text-box-metrics update-scroller set-dark-mode support-dark-mode? toggle-GPU init product styles extras GUI-rules processors count-faces cancel-captions ok-captions Cancel-OK general process spacing pos-size! containers default-font opts-proto size-x now? process-reactors opt-as-integer calc-size align-faces resize-child-panels clean-style process-draw preset-focus add-option add-flag add-bounds fetch-value fetch-argument fetch-expr fetch-options make-actor layout do-events stop-events do-actor unview center-face make-face dump-face do-no-sync get-scroller get-face-pane get-focusable insert-event-func remove-event-func set-focus foreach-face alert dragging radio reactors field-sync csv CSV Mime-Type Suffixes ignore-empty? strict? quote-char double-quote quotable-chars parsed? non-aligned to-csv-line escape-value next-column-name make-header get-columns encode-map encode-maps encode-flat encode-blocks load-csv to-csv non-line-ws ws ws* ws+ sep non-zero-digit hex-char chars not-word-char word-1st word-char sign int frac number numeric-literal string-literal json-esc-ch unescape json-object property-list property json-name array-list json-array json-value _out _res _tmp _str _s _e line-ct last-lf load-json indent-level normal-chars escapes init-state emit-indent emit-key-value red-to-json-value to-json json JSON result class values 
        else series pattern operator select-key* codec source mime Content-Type length k dir keep flag so MD5 timezone i frm value appended only owned p obj events? q f x field reaction url-obj halt-request res word item left f-arity | rule w frame ask history end fetch block-name saved-frame anon entry cnt duration str bin point y A B A1 B2 B1 A2 d screen handles _ bold italic underline strike backdrop gui-console-ctx terminal box win caret owner moved faces window modal tab-panel default new self sync detect event handler result2 with stop svs 
        xp 
        older font-fixed font-sans-serif font-serif silent silenced blk later? txt drop-list scroller min-sz area across middle below center at-offset mar tmpl opts on-drag-start panel default-actor styled template base oi face-font b sz local top svmp action index part on-create on-created svv model no-skip r ok drag-on all-over drag-start bounds over away? mid-down down drag-info drag key-down key control focusable owned-faces SHIFT opt prev refs out-map line
    ] [
        ctx||56: get-root-node2 120 
        ctx||57: get-root-node2 123 
        ctx||58: get-root-node2 126 
        ctx||59: get-root-node2 129 
        ctx||60: get-root-node2 132 
        ctx||61: get-root-node2 135 
        ctx||62: get-root-node2 138 
        ctx||63: get-root-node2 141 
        ctx||64: get-root-node2 144 
        ctx||65: get-root-node2 147 
        ctx||66: get-root-node2 150 
        ctx||67: get-root-node2 153 
        ctx||68: get-root-node2 156 
        ctx||69: get-root-node2 159 
        ctx||70: get-root-node2 162 
        ctx||71: get-root-node2 165 
        ctx||72: get-root-node2 168 
        ctx||73: get-root-node2 171 
        ctx||74: get-root-node2 174 
        ctx||75: get-root-node2 177 
        ctx||76: get-root-node2 180 
        ctx||77: get-root-node2 183 
        ctx||78: get-root-node2 186 
        ctx||79: get-root-node2 189 
        ctx||80: get-root-node2 192 
        ctx||81: get-root-node2 195 
        ctx||82: get-root-node2 198 
        ctx||83: get-root-node2 201 
        ctx||84: get-root-node2 204 
        ctx||85: get-root-node2 207 
        ctx||86: get-root-node2 210 
        ctx||87: get-root-node2 213 
        ctx||88: get-root-node2 216 
        ctx||89: get-root-node2 219 
        ctx||90: get-root-node2 222 
        ctx||91: get-root-node2 225 
        ctx||92: get-root-node2 228 
        ctx||93: get-root-node2 231 
        ctx||94: get-root-node2 234 
        ctx||95: get-root-node2 237 
        ctx||96: get-root-node2 240 
        ctx||97: get-root-node2 243 
        ctx||98: get-root-node2 246 
        ctx||99: get-root-node2 249 
        ctx||100: get-root-node2 252 
        ctx||101: get-root-node2 255 
        ctx||102: get-root-node2 258 
        ctx||103: get-root-node2 261 
        ctx||104: get-root-node2 264 
        ctx||105: get-root-node2 267 
        ctx||106: get-root-node2 270 
        ctx||107: get-root-node2 273 
        ctx||108: get-root-node2 276 
        ctx||109: get-root-node2 279 
        ctx||110: get-root-node2 282 
        ctx||111: get-root-node2 285 
        ctx||112: get-root-node2 288 
        ctx||113: get-root-node2 291 
        ctx||114: get-root-node2 294 
        ctx||115: get-root-node2 297 
        ctx||116: get-root-node2 300 
        ctx||117: get-root-node2 303 
        ctx||118: get-root-node2 306 
        ctx||119: get-root-node2 309 
        ctx||120: get-root-node2 312 
        ctx||121: get-root-node2 315 
        ctx||122: get-root-node2 318 
        ctx||123: get-root-node2 321 
        ctx||124: get-root-node2 324 
        ctx||125: get-root-node2 327 
        ctx||126: get-root-node2 330 
        ctx||127: get-root-node2 333 
        ctx||128: get-root-node2 336 
        ctx||129: get-root-node2 339 
        ctx||130: get-root-node2 342 
        ctx||131: get-root-node2 345 
        ctx||132: get-root-node2 348 
        ctx||133: get-root-node2 351 
        ctx||134: get-root-node2 354 
        ctx||135: get-root-node2 357 
        ctx||136: get-root-node2 360 
        ctx||137: get-root-node2 363 
        ctx||138: get-root-node2 366 
        ctx||139: get-root-node2 369 
        ctx||140: get-root-node2 372 
        ctx||141: get-root-node2 375 
        ctx||142: get-root-node2 378 
        ctx||143: get-root-node2 381 
        ctx||144: get-root-node2 384 
        ctx||145: get-root-node2 387 
        ctx||146: get-root-node2 390 
        ctx||147: get-root-node2 393 
        ctx||148: get-root-node2 396 
        ctx||149: get-root-node2 399 
        ctx||150: get-root-node2 402 
        ctx||151: get-root-node2 405 
        ctx||152: get-root-node2 408 
        ctx||153: get-root-node2 411 
        ctx||154: get-root-node2 414 
        ctx||155: get-root-node2 417 
        ctx||156: get-root-node2 420 
        ctx||157: get-root-node2 423 
        ctx||158: get-root-node2 426 
        ctx||159: get-root-node2 429 
        ctx||160: get-root-node2 432 
        ctx||161: get-root-node2 435 
        ctx||162: get-root-node2 438 
        ctx||163: get-root-node2 441 
        ctx||164: get-root-node2 444 
        ctx||165: get-root-node2 447 
        ctx||166: get-root-node2 450 
        ctx||167: get-root-node2 453 
        ctx||168: get-root-node2 456 
        ctx||169: get-root-node2 459 
        ctx||170: get-root-node2 462 
        ctx||171: get-root-node2 465 
        ctx||172: get-root-node2 468 
        ctx||173: get-root-node2 471 
        ctx||174: get-root-node2 474 
        ctx||175: get-root-node2 477 
        ctx||176: get-root-node2 480 
        ctx||177: get-root-node2 483 
        ctx||178: get-root-node2 486 
        ctx||179: get-root-node2 489 
        ctx||180: get-root-node2 492 
        ctx||181: get-root-node2 495 
        ctx||182: get-root-node2 498 
        ctx||183: get-root-node2 501 
        ctx||185: get-root-node2 502 
        ctx||186: get-root-node2 505 
        ctx||187: get-root-node2 508 
        ctx||188: get-root-node2 511 
        ctx||189: get-root-node2 514 
        ctx||190: get-root-node2 517 
        ctx||191: get-root-node2 520 
        ctx||192: get-root-node2 523 
        ctx||193: get-root-node2 526 
        ctx||194: get-root-node2 529 
        ctx||195: get-root-node2 532 
        ctx||196: get-root-node2 535 
        ctx||197: get-root-node2 538 
        ctx||198: get-root-node2 541 
        ctx||199: get-root-node2 544 
        ctx||200: get-root-node2 547 
        ctx||201: get-root-node2 550 
        ctx||202: get-root-node2 553 
        ctx||203: get-root-node2 556 
        ctx||204: get-root-node2 559 
        ctx||205: get-root-node2 562 
        ctx||206: get-root-node2 565 
        ctx||207: get-root-node2 568 
        ctx||208: get-root-node2 571 
        ctx||209: get-root-node2 574 
        ctx||210: get-root-node2 577 
        ctx||211: get-root-node2 580 
        ctx||212: get-root-node2 583 
        ctx||213: get-root-node2 586 
        ctx||214: get-root-node2 589 
        ctx||215: get-root-node2 592 
        ctx||216: get-root-node2 595 
        ctx||217: get-root-node2 598 
        ctx||218: get-root-node2 601 
        ctx||219: get-root-node2 604 
        ctx||220: get-root-node2 607 
        ctx||221: get-root-node2 610 
        ctx||222: get-root-node2 613 
        ctx||223: get-root-node2 616 
        ctx||224: get-root-node2 619 
        ctx||225: get-root-node2 622 
        ctx||226: get-root-node2 625 
        ctx||227: get-root-node2 628 
        ctx||228: get-root-node2 631 
        ctx||229: get-root-node2 634 
        ctx||230: get-root-node2 637 
        ctx||231: get-root-node2 640 
        ctx||232: get-root-node2 643 
        ctx||233: get-root-node2 646 
        ctx||234: get-root-node2 649 
        ctx||236: get-root-node2 651 
        ctx||238: get-root-node2 653 
        ctx||240: get-root-node2 658 
        ctx||242: get-root-node2 660 
        ctx||244: get-root-node2 661 
        ctx||246: get-root-node2 668 
        ctx||248: get-root-node2 671 
        ctx||250: get-root-node2 680 
        ctx||252: get-root-node2 776 
        ctx||254: get-root-node2 781 
        ctx||256: get-root-node2 798 
        ctx||258: get-root-node2 800 
        ctx||260: get-root-node2 802 
        ctx||262: get-root-node2 804 
        ctx||264: get-root-node2 820 
        ctx||266: get-root-node2 821 
        ctx||267: get-root-node2 824 
        ctx||269: get-root-node2 825 
        evt268: as node! 0 
        ctx||270: get-root-node2 828 
        ctx||272: get-root-node2 835 
        ctx||274: get-root-node2 836 
        ctx||276: get-root-node2 839 
        ctx||278: get-root-node2 841 
        ctx||279: get-root-node2 844 
        evt277: as node! 0 
        ctx||280: get-root-node2 847 
        ctx||282: get-root-node2 848 
        ctx||284: get-root-node2 849 
        evt283: as node! 0 
        ctx||285: get-root-node2 852 
        ctx||286: get-root-node2 855 
        evt281: as node! 0 
        ctx||287: get-root-node2 858 
        ctx||289: get-root-node2 859 
        ctx||291: get-root-node2 860 
        ctx||301: get-root-node2 861 
        ctx||303: get-root-node2 862 
        ctx||305: get-root-node2 863 
        ctx||308: get-root-node2 864 
        ctx||310: get-root-node2 865 
        ctx||312: get-root-node2 866 
        ctx||314: get-root-node2 867 
        ctx||315: get-root-node2 870 
        ctx||316: get-root-node2 875 
        ctx||319: get-root-node2 885 
        ctx||322: get-root-node2 895 
        ctx||325: get-root-node2 905 
        ctx||328: get-root-node2 915 
        ctx||331: get-root-node2 919 
        ctx||332: get-root-node2 926 
        ctx||334: get-root-node2 927 
        evt333: as node! 0 
        ctx||335: get-root-node2 930 
        ctx||337: get-root-node2 931 
        ctx||338: get-root-node2 934 
        evt336: as node! 0 
        ctx||339: get-root-node2 937 
        ctx||340: get-root-node2 940 
        ctx||341: get-root-node2 943 
        ctx||343: get-root-node2 946 
        ctx||344: get-root-node2 949 
        ctx||345: get-root-node2 952 
        ctx||346: get-root-node2 955 
        ctx||347: get-root-node2 958 
        ctx||348: get-root-node2 961 
        ctx||349: get-root-node2 964 
        ctx||350: get-root-node2 967 
        ctx||351: get-root-node2 970 
        ctx||352: get-root-node2 973 
        ctx||353: get-root-node2 976 
        ctx||354: get-root-node2 979 
        ctx||355: get-root-node2 982 
        ctx||356: get-root-node2 985 
        ctx||357: get-root-node2 990 
        ctx||358: get-root-node2 994 
        ctx||360: get-root-node2 1004 
        ctx||361: get-root-node2 1027 
        ctx||362: get-root-node2 1030 
        ctx||363: get-root-node2 1033 
        ctx||364: get-root-node2 1036 
        ctx||366: get-root-node2 1039 
        ctx||367: get-root-node2 1042 
        ctx||368: get-root-node2 1045 
        ctx||369: get-root-node2 1048 
        ctx||370: get-root-node2 1051 
        ctx||371: get-root-node2 1054 
        ctx||372: get-root-node2 1057 
        ctx||373: get-root-node2 1060 
        ctx||374: get-root-node2 1063 
        ctx||375: get-root-node2 1066 
        ctx||376: get-root-node2 1069 
        ctx||377: get-root-node2 1072 
        ctx||378: get-root-node2 1075 
        ctx||379: get-root-node2 1078 
        ctx||380: get-root-node2 1081 
        ctx||381: get-root-node2 1084 
        ctx||382: get-root-node2 1087 
        ctx||383: get-root-node2 1090 
        ctx||385: get-root-node2 1092 
        ctx||387: get-root-node2 1093 
        ctx||389: get-root-node2 1094 
        ctx||391: get-root-node2 1095 
        ctx||393: get-root-node2 1097 
        ctx||394: get-root-node2 1100 
        ctx||395: get-root-node2 1103 
        ctx||396: get-root-node2 1106 
        ctx||397: get-root-node2 1109 
        ctx||398: get-root-node2 1112 
        ctx||399: get-root-node2 1115 
        ctx||400: get-root-node2 1118 
        ctx||402: get-root-node2 1121 
        ctx||403: get-root-node2 1124 
        ctx||404: get-root-node2 1127 
        ctx||405: get-root-node2 1130 
        ctx||406: get-root-node2 1133 
        ctx||407: get-root-node2 1136 
        ctx||408: get-root-node2 1139 
        ctx||409: get-root-node2 1142 
        ctx||411: get-root-node2 1143 
        ctx||412: get-root-node2 1146 
        ctx||413: get-root-node2 1149 
        ctx||415: get-root-node2 1158 
        ctx||416: get-root-node2 1161 
        ctx||417: get-root-node2 1164 
        ctx||418: get-root-node2 1167 
        ctx||419: get-root-node2 1170 
        ctx||420: get-root-node2 1173 
        ctx||422: get-root-node2 1186 
        ctx||423: get-root-node2 1189 
        ctx||424: get-root-node2 1192 
        ctx||425: get-root-node2 1195 
        ctx||426: get-root-node2 1198 
        ctx||427: get-root-node2 1201 
        ctx||428: get-root-node2 1224 
        ctx||429: get-root-node2 1227 
        ctx||430: get-root-node2 1230 
        ctx||431: get-root-node2 1233 
        ctx||432: get-root-node2 1240 
        ctx||433: get-root-node2 1243 
        ctx||434: get-root-node2 1246 
        ctx||435: get-root-node2 1249 
        ctx||436: get-root-node2 1252 
        ctx||437: get-root-node2 1255 
        ctx||438: get-root-node2 1258 
        ctx||439: get-root-node2 1261 
        ctx||441: get-root-node2 1262 
        ctx||443: get-root-node2 1269 
        ctx||444: get-root-node2 1272 
        ctx||445: get-root-node2 1275 
        ctx||446: get-root-node2 1278 
        ctx||447: get-root-node2 1281 
        ctx||448: get-root-node2 1284 
        ctx||449: get-root-node2 1287 
        ctx||450: get-root-node2 1290 
        ctx||451: get-root-node2 1293 
        ctx||452: get-root-node2 1296 
        ctx||453: get-root-node2 1299 
        ctx||454: get-root-node2 1302 
        ctx||455: get-root-node2 1305 
        ctx||456: get-root-node2 1310 
        ctx||457: get-root-node2 1313 
        ctx||458: get-root-node2 1316 
        ctx||459: get-root-node2 1319 
        ctx||460: get-root-node2 1322 
        ctx||461: get-root-node2 1325 
        ctx||463: get-root-node2 1326 
        ctx||464: get-root-node2 1329 
        evt462: as node! 0 
        ctx||465: get-root-node2 1332 
        ctx||467: get-root-node2 1333 
        ctx||468: get-root-node2 1336 
        evt466: as node! 0 
        ctx||469: get-root-node2 1339 
        ctx||471: get-root-node2 1340 
        evt470: as node! 0 
        ctx||472: get-root-node2 1343 
        ctx||474: get-root-node2 1344 
        evt473: as node! 0 
        ctx||475: get-root-node2 1347 
        ctx||477: get-root-node2 1348 
        ctx||479: get-root-node2 1349 
        ctx||481: get-root-node2 1351 
        ctx||482: get-root-node2 1354 
        ctx||483: get-root-node2 1357 
        evt476: as node! 0 
        ctx||484: get-root-node2 1362 
        ctx||486: get-root-node2 1369 
        ctx||487: get-root-node2 1372 
        ctx||488: get-root-node2 1425 
        ctx||489: get-root-node2 1432 
        ctx||490: get-root-node2 1435 
        ctx||492: get-root-node2 1438 
        ctx||494: get-root-node2 1439 
        ctx||496: get-root-node2 1440 
        ctx||497: get-root-node2 1445 
        ctx||498: get-root-node2 1451 
        ctx||499: get-root-node2 1456 
        ctx||501: get-root-node2 1457 
        ctx||502: get-root-node2 1460 
        ctx||503: get-root-node2 1463 
        ctx||504: get-root-node2 1466 
        ctx||505: get-root-node2 1469 
        ctx||506: get-root-node2 1472 
        ctx||507: get-root-node2 1475 
        ctx||508: get-root-node2 1478 
        ctx||509: get-root-node2 1481 
        ctx||510: get-root-node2 1484 
        ctx||511: get-root-node2 1487 
        ctx||512: get-root-node2 1490 
        ctx||513: get-root-node2 1493 
        ctx||514: get-root-node2 1496 
        ctx||515: get-root-node2 1499 
        ctx||516: get-root-node2 1502 
        ctx||517: get-root-node2 1505 
        ctx||518: get-root-node2 1508 
        ctx||519: get-root-node2 1511 
        ctx||520: get-root-node2 1517 
        ctx||521: get-root-node2 1520 
        ctx||522: get-root-node2 1523 
        ctx||523: get-root-node2 1526 
        ctx||524: get-root-node2 1529 
        ctx||525: get-root-node2 1532 
        ctx||526: get-root-node2 1535 
        ctx||527: get-root-node2 1538 
        ctx||528: get-root-node2 1541 
        ctx||529: get-root-node2 1544 
        ctx||530: get-root-node2 1547 
        ctx||531: get-root-node2 1550 
        ctx||532: get-root-node2 1553 
        ctx||533: get-root-node2 1556 
        ctx||534: get-root-node2 1559 
        ctx||535: get-root-node2 1562 
        ctx||536: get-root-node2 1565 
        ctx||537: get-root-node2 1568 
        ctx||538: get-root-node2 1571 
        ctx||539: get-root-node2 1574 
        ctx||540: get-root-node2 1577 
        ctx||541: get-root-node2 1580 
        ctx||543: get-root-node2 1583 
        ctx||545: get-root-node2 1591 
        ctx||546: get-root-node2 1596 
        ctx||551: get-root-node2 1600 
        ctx||552: get-root-node2 1603 
        ctx||553: get-root-node2 1606 
        ctx||555: get-root-node2 1610 
        ctx||556: get-root-node2 1613 
        ctx||557: get-root-node2 1616 
        ctx||558: get-root-node2 1619 
        ctx||559: get-root-node2 1622 
        ctx||560: get-root-node2 1625 
        ctx||561: get-root-node2 1628 
        ctx||562: get-root-node2 1631 
        ctx||563: get-root-node2 1634 
        ctx||564: get-root-node2 1637 
        ctx||565: get-root-node2 1640 
        ctx||566: get-root-node2 1643 
        ctx||568: get-root-node2 1671 
        ctx||569: get-root-node2 1674 
        ctx||570: get-root-node2 1677 
        ctx||571: get-root-node2 1680 
        ctx||572: get-root-node2 1683 
        ctx||574: get-root-node2 1685 
        ctx||575: get-root-node2 1688 
        ctx||576: get-root-node2 1691 
        ctx||577: get-root-node2 1694 
        ctx||578: get-root-node2 1697 
        ctx||579: get-root-node2 1702 
        ctx||582: get-root-node2 1706 
        ctx||583: get-root-node2 1709 
        ctx||584: get-root-node2 1712 
        ctx||605: get-root-node2 1856 
        ctx||622: get-root-node2 2027 
        ctx||642: get-root-node2 2747
    ] 653 [%modules/view/view.red %environment/codecs/CSV.red %environment/codecs/JSON.red] [f_routine #[object! [
            spec: #[none]
            body: #[none]
        ]] ctx||56 [{Defines a function with a given Red spec and Red/System body} spec [block!] body [block!]] f_also #[object! [
            value1: #[none]
            value2: #[none]
        ]] ctx||57 [
            {Returns the first value, but also evaluates the second} 
            value1 [any-type!] 
            value2 [any-type!]
        ] f_attempt #[object! [
            code: #[none]
            safer: #[none]
            local: #[none]
            all: #[none]
            result: #[none]
        ]] ctx||58 [
            {Tries to evaluate a block and returns result or NONE on error} 
            code [block!] 
            /safer "Capture all possible errors and exceptions" 
            /local all result
        ] f_comment #[object! [
            value: #[none]
        ]] ctx||59 ["Consume but don't evaluate the next value" 'value] f_quit #[object! [
            return: #[none]
            status: #[none]
        ]] ctx||60 [
            "Stops evaluation and exits the program" 
            /return status [integer!] "Return an exit status"
        ] f_empty? #[object! [
            data: #[none]
        ]] ctx||61 [
            {Returns true if data is a series at its tail or an empty map} 
            data [map! none! series!] 
            return: [logic!]
        ] f_?? #[object! [
            value: #[none]
        ]] ctx||62 [
            "Prints a word and the value it refers to (molded)" 
            'value [path! word!]
        ] f_probe #[object! [
            value: #[none]
        ]] ctx||63 [
            "Returns a value after printing its molded form" 
            value [any-type!]
        ] f_quote #[object! [
            value: #[none]
        ]] ctx||64 [
            "Return but don't evaluate the next value" 
            :value [any-type!]
        ] f_first #[object! [
            s: #[none]
        ]] ctx||65 ["Returns the first value in a series" s [any-point! date! pair! series! time! tuple!]] f_second #[object! [
            s: #[none]
        ]] ctx||66 ["Returns the second value in a series" s [any-point! date! pair! series! time! tuple!]] f_third #[object! [
            s: #[none]
        ]] ctx||67 ["Returns the third value in a series" s [date! point3D! series! time! tuple!]] f_fourth #[object! [
            s: #[none]
        ]] ctx||68 ["Returns the fourth value in a series" s [date! series! tuple!]] f_fifth #[object! [
            s: #[none]
        ]] ctx||69 ["Returns the fifth value in a series" s [date! series! tuple!]] f_last #[object! [
            s: #[none]
        ]] ctx||70 ["Returns the last value in a series" s [series! tuple!]] f_spec-of #[object! [
            value: #[none]
        ]] ctx||71 [{Returns the spec of a value that supports reflection} value] f_body-of #[object! [
            value: #[none]
        ]] ctx||72 [{Returns the body of a value that supports reflection} value] f_words-of #[object! [
            value: #[none]
        ]] ctx||73 [{Returns the list of words of a value that supports reflection} value] f_class-of #[object! [
            value: #[none]
        ]] ctx||74 ["Returns the class ID of an object" value] f_values-of #[object! [
            value: #[none]
        ]] ctx||75 [{Returns the list of values of a value that supports reflection} value] f_bitset? #[object! [
            value: #[none]
        ]] ctx||76 
        ["Returns true if the value is this type" value [any-type!]] f_binary? #[object! [
            value: #[none]
        ]] ctx||77 
        ["Returns true if the value is this type" value [any-type!]] f_block? #[object! [
            value: #[none]
        ]] ctx||78 
        ["Returns true if the value is this type" value [any-type!]] f_char? #[object! [
            value: #[none]
        ]] ctx||79 
        ["Returns true if the value is this type" value [any-type!]] f_email? #[object! [
            value: #[none]
        ]] ctx||80 
        ["Returns true if the value is this type" value [any-type!]] f_file? #[object! [
            value: #[none]
        ]] ctx||81 
        ["Returns true if the value is this type" value [any-type!]] f_float? #[object! [
            value: #[none]
        ]] ctx||82 
        ["Returns true if the value is this type" value [any-type!]] f_get-path? #[object! [
            value: #[none]
        ]] ctx||83 
        ["Returns true if the value is this type" value [any-type!]] f_get-word? #[object! [
            value: #[none]
        ]] ctx||84 
        ["Returns true if the value is this type" value [any-type!]] f_hash? #[object! [
            value: #[none]
        ]] ctx||85 
        ["Returns true if the value is this type" value [any-type!]] f_integer? #[object! [
            value: #[none]
        ]] ctx||86 
        ["Returns true if the value is this type" value [any-type!]] f_issue? #[object! [
            value: #[none]
        ]] ctx||87 
        ["Returns true if the value is this type" value [any-type!]] f_lit-path? #[object! [
            value: #[none]
        ]] ctx||88 
        ["Returns true if the value is this type" value [any-type!]] f_lit-word? #[object! [
            value: #[none]
        ]] ctx||89 
        ["Returns true if the value is this type" value [any-type!]] f_logic? #[object! [
            value: #[none]
        ]] ctx||90 
        ["Returns true if the value is this type" value [any-type!]] f_map? #[object! [
            value: #[none]
        ]] ctx||91 
        ["Returns true if the value is this type" value [any-type!]] f_none? #[object! [
            value: #[none]
        ]] ctx||92 
        ["Returns true if the value is this type" value [any-type!]] f_pair? #[object! [
            value: #[none]
        ]] ctx||93 
        ["Returns true if the value is this type" value [any-type!]] f_paren? #[object! [
            value: #[none]
        ]] ctx||94 
        ["Returns true if the value is this type" value [any-type!]] f_path? #[object! [
            value: #[none]
        ]] ctx||95 
        ["Returns true if the value is this type" value [any-type!]] f_percent? #[object! [
            value: #[none]
        ]] ctx||96 
        ["Returns true if the value is this type" value [any-type!]] f_refinement? #[object! [
            value: #[none]
        ]] ctx||97 
        ["Returns true if the value is this type" value [any-type!]] f_set-path? #[object! [
            value: #[none]
        ]] ctx||98 
        ["Returns true if the value is this type" value [any-type!]] f_set-word? #[object! [
            value: #[none]
        ]] ctx||99 
        ["Returns true if the value is this type" value [any-type!]] f_string? #[object! [
            value: #[none]
        ]] ctx||100 
        ["Returns true if the value is this type" value [any-type!]] f_tag? #[object! [
            value: #[none]
        ]] ctx||101 
        ["Returns true if the value is this type" value [any-type!]] f_time? #[object! [
            value: #[none]
        ]] ctx||102 
        ["Returns true if the value is this type" value [any-type!]] f_typeset? #[object! [
            value: #[none]
        ]] ctx||103 
        ["Returns true if the value is this type" value [any-type!]] f_tuple? #[object! [
            value: #[none]
        ]] ctx||104 
        ["Returns true if the value is this type" value [any-type!]] f_unset? #[object! [
            value: #[none]
        ]] ctx||105 
        ["Returns true if the value is this type" value [any-type!]] f_url? #[object! [
            value: #[none]
        ]] ctx||106 
        ["Returns true if the value is this type" value [any-type!]] f_word? #[object! [
            value: #[none]
        ]] ctx||107 
        ["Returns true if the value is this type" value [any-type!]] f_image? #[object! [
            value: #[none]
        ]] ctx||108 
        ["Returns true if the value is this type" value [any-type!]] f_date? #[object! [
            value: #[none]
        ]] ctx||109 
        ["Returns true if the value is this type" value [any-type!]] f_money? #[object! [
            value: #[none]
        ]] ctx||110 
        ["Returns true if the value is this type" value [any-type!]] f_ref? #[object! [
            value: #[none]
        ]] ctx||111 
        ["Returns true if the value is this type" value [any-type!]] f_point2D? #[object! [
            value: #[none]
        ]] ctx||112 
        ["Returns true if the value is this type" value [any-type!]] f_point3D? #[object! [
            value: #[none]
        ]] ctx||113 
        ["Returns true if the value is this type" value [any-type!]] f_handle? #[object! [
            value: #[none]
        ]] ctx||114 
        ["Returns true if the value is this type" value [any-type!]] f_error? #[object! [
            value: #[none]
        ]] ctx||115 
        ["Returns true if the value is this type" value [any-type!]] f_action? #[object! [
            value: #[none]
        ]] ctx||116 
        ["Returns true if the value is this type" value [any-type!]] f_native? #[object! [
            value: #[none]
        ]] ctx||117 
        ["Returns true if the value is this type" value [any-type!]] f_datatype? #[object! [
            value: #[none]
        ]] ctx||118 
        ["Returns true if the value is this type" value [any-type!]] f_function? #[object! [
            value: #[none]
        ]] ctx||119 
        ["Returns true if the value is this type" value [any-type!]] f_object? #[object! [
            value: #[none]
        ]] ctx||120 
        ["Returns true if the value is this type" value [any-type!]] f_op? #[object! [
            value: #[none]
        ]] ctx||121 
        ["Returns true if the value is this type" value [any-type!]] f_routine? #[object! [
            value: #[none]
        ]] ctx||122 
        ["Returns true if the value is this type" value [any-type!]] f_vector? #[object! [
            value: #[none]
        ]] ctx||123 
        ["Returns true if the value is this type" value [any-type!]] f_any-list? #[object! [
            value: #[none]
        ]] ctx||124 ["Returns true if the value is any type of any-list" value [any-type!]] f_any-block? #[object! [
            value: #[none]
        ]] ctx||125 ["Returns true if the value is any type of any-block" value [any-type!]] f_any-function? #[object! [
            value: #[none]
        ]] ctx||126 [{Returns true if the value is any type of any-function} value [any-type!]] f_any-object? #[object! [
            value: #[none]
        ]] ctx||127 [{Returns true if the value is any type of any-object} value [any-type!]] f_any-path? #[object! [
            value: #[none]
        ]] ctx||128 ["Returns true if the value is any type of any-path" value [any-type!]] f_any-string? #[object! [
            value: #[none]
        ]] ctx||129 [{Returns true if the value is any type of any-string} value [any-type!]] f_any-word? #[object! [
            value: #[none]
        ]] ctx||130 ["Returns true if the value is any type of any-word" value [any-type!]] f_series? #[object! [
            value: #[none]
        ]] ctx||131 ["Returns true if the value is any type of series" value [any-type!]] f_number? #[object! [
            value: #[none]
        ]] ctx||132 ["Returns true if the value is any type of number" value [any-type!]] f_immediate? #[object! [
            value: #[none]
        ]] ctx||133 ["Returns true if the value is any type of immediate" value [any-type!]] f_scalar? #[object! [
            value: #[none]
        ]] ctx||134 ["Returns true if the value is any type of scalar" value [any-type!]] f_all-word? #[object! [
            value: #[none]
        ]] ctx||135 ["Returns true if the value is any type of all-word" value [any-type!]] f_any-point? #[object! [
            value: #[none]
        ]] ctx||136 ["Returns true if the value is any type of any-point" value [any-type!]] f_planar? #[object! [
            value: #[none]
        ]] ctx||137 ["Returns true if the value is any type of planar" value [any-type!]] f_to-bitset #[object! [
            value: #[none]
        ]] ctx||138 ["Convert to bitset! value" value] f_to-binary #[object! [
            value: #[none]
        ]] ctx||139 ["Convert to binary! value" value] f_to-block #[object! [
            value: #[none]
        ]] ctx||140 ["Convert to block! value" value] f_to-char #[object! [
            value: #[none]
        ]] ctx||141 ["Convert to char! value" value] f_to-email #[object! [
            value: #[none]
        ]] ctx||142 ["Convert to email! value" value] f_to-file #[object! [
            value: #[none]
        ]] ctx||143 ["Convert to file! value" value] f_to-float #[object! [
            value: #[none]
        ]] ctx||144 ["Convert to float! value" value] f_to-get-path #[object! [
            value: #[none]
        ]] ctx||145 ["Convert to get-path! value" value] f_to-get-word #[object! [
            value: #[none]
        ]] ctx||146 ["Convert to get-word! value" value] f_to-hash #[object! [
            value: #[none]
        ]] ctx||147 ["Convert to hash! value" value] f_to-integer #[object! [
            value: #[none]
        ]] ctx||148 ["Convert to integer! value" value] f_to-issue #[object! [
            value: #[none]
        ]] ctx||149 ["Convert to issue! value" value] f_to-lit-path #[object! [
            value: #[none]
        ]] ctx||150 ["Convert to lit-path! value" value] f_to-lit-word #[object! [
            value: #[none]
        ]] ctx||151 ["Convert to lit-word! value" value] f_to-logic #[object! [
            value: #[none]
        ]] ctx||152 ["Convert to logic! value" value] f_to-map #[object! [
            value: #[none]
        ]] ctx||153 ["Convert to map! value" value] f_to-none #[object! [
            value: #[none]
        ]] ctx||154 ["Convert to none! value" value] f_to-pair #[object! [
            value: #[none]
        ]] ctx||155 ["Convert to pair! value" value] f_to-paren #[object! [
            value: #[none]
        ]] ctx||156 ["Convert to paren! value" value] f_to-path #[object! [
            value: #[none]
        ]] ctx||157 ["Convert to path! value" value] f_to-percent #[object! [
            value: #[none]
        ]] ctx||158 ["Convert to percent! value" value] f_to-refinement #[object! [
            value: #[none]
        ]] ctx||159 ["Convert to refinement! value" value] f_to-set-path #[object! [
            value: #[none]
        ]] ctx||160 ["Convert to set-path! value" value] f_to-set-word #[object! [
            value: #[none]
        ]] ctx||161 ["Convert to set-word! value" value] f_to-string #[object! [
            value: #[none]
        ]] ctx||162 ["Convert to string! value" value] f_to-tag #[object! [
            value: #[none]
        ]] ctx||163 ["Convert to tag! value" value] f_to-time #[object! [
            value: #[none]
        ]] ctx||164 ["Convert to time! value" value] f_to-typeset #[object! [
            value: #[none]
        ]] ctx||165 ["Convert to typeset! value" value] f_to-tuple #[object! [
            value: #[none]
        ]] ctx||166 ["Convert to tuple! value" value] f_to-unset #[object! [
            value: #[none]
        ]] ctx||167 ["Convert to unset! value" value] f_to-url #[object! [
            value: #[none]
        ]] ctx||168 ["Convert to url! value" value] f_to-word #[object! [
            value: #[none]
        ]] ctx||169 ["Convert to word! value" value] f_to-image #[object! [
            value: #[none]
        ]] ctx||170 ["Convert to image! value" value] f_to-date #[object! [
            value: #[none]
        ]] ctx||171 ["Convert to date! value" value] f_to-money #[object! [
            value: #[none]
        ]] ctx||172 ["Convert to money! value" value] f_to-ref #[object! [
            value: #[none]
        ]] ctx||173 ["Convert to ref! value" value] f_to-point2D #[object! [
            value: #[none]
        ]] ctx||174 ["Convert to point2D! value" value] f_to-point3D #[object! [
            value: #[none]
        ]] ctx||175 ["Convert to point3D! value" value] f_context #[object! [
            spec: #[none]
        ]] ctx||176 [
            "Makes a new object from an evaluated spec" 
            spec [block!]
        ] f_alter #[object! [
            series: #[none]
            value: #[none]
        ]] ctx||177 [
            {If a value is not found in a series, append it; otherwise, remove it. Returns true if added} 
            series [series!] 
            value
        ] f_offset? #[object! [
            series1: #[none]
            series2: #[none]
        ]] ctx||178 [
            "Returns the offset between two series positions" 
            series1 [series!] 
            series2 [series!]
        ] f_repend #[object! [
            series: #[none]
            value: #[none]
            only: #[none]
        ]] ctx||179 [
            {Appends a reduced value to a series and returns the series head} 
            series [series!] 
            value 
            /only "Appends a block value as a block"
        ] f_replace #[object! [
            series: #[none]
            pattern: #[none]
            value: #[none]
            all: #[none]
            deep: #[none]
            case: #[none]
            local: #[none]
            parse?: #[none]
            form?: #[none]
            quote?: #[none]
            deep?: #[none]
            rule: #[none]
            many?: #[none]
            size: #[none]
            seek: #[none]
            active?: #[none]
        ]] ctx||180 [
            "Replaces values in a series, in place" 
            series [any-block! any-string! binary! vector!] "The series to be modified" 
            pattern "Specific value or parse rule pattern to match" 
            value "New value, replaces pattern in the series" 
            /all "Replace all occurrences, not just the first" 
            /deep "Replace pattern in all sub-lists as well" 
            /case "Case-sensitive replacement" 
            /local parse? form? quote? deep? rule many? size seek active?
        ] f_math #[object! [
            datum: #[none]
            safe: #[none]
            local: #[none]
            match: #[none]
            order: #[none]
            infix: #[none]
            tally: #[none]
            enter: #[none]
            recur: #[none]
            count: #[none]
            operator: #[none]
        ]] ctx||181 [
            "Evaluates expression using math precedence rules" 
            datum [block! paren!] "Expression to evaluate" 
            /safe "Returns NONE on error" 
            /local match 
            order infix tally enter recur count operator
        ] f_charset #[object! [
            spec: #[none]
        ]] ctx||182 [
            "Shortcut for `make bitset!`" 
            spec [binary! bitset! block! char! integer! string!]
        ] f_ctx||183~on-parse-event #[object! [
            event: #[none]
            match?: #[none]
            rule: #[none]
            input: #[none]
            stack: #[none]
        ]] ctx||185 [
            "Standard parse/trace callback used by PARSE-TRACE" 
            event [word!] {Trace events: push, pop, fetch, match, iterate, paren, end} 
            match? [logic!] "Result of last matching operation" 
            rule [block!] "Current rule at current position" 
            input [series!] "Input series at next position to match" 
            stack [block!] "Internal parse rules stack" 
            return: [logic!] {TRUE: continue parsing, FALSE: stop and exit parsing}
        ] f_parse-trace #[object! [
            input: #[none]
            rules: #[none]
            case: #[none]
            part: #[none]
            limit: #[none]
        ]] ctx||186 [
            {Wrapper for parse/trace using the default event processor} 
            input [series!] 
            rules [block!] 
            /case "Uses case-sensitive comparison" 
            /part "Limit to a length or position" 
            limit [integer!] 
            return: [logic! block!]
        ] f_suffix? #[object! [
            path: #[none]
        ]] ctx||187 [
            {Returns the suffix (extension) of a filename or url, or NONE if there is no suffix} 
            path [email! file! string! url!]
        ] f_scan #[object! [
            buffer: #[none]
            next: #[none]
            fast: #[none]
        ]] ctx||188 [
            {Returns the guessed type of the first serialized value from the input} 
            buffer [binary! string!] "Input UTF-8 buffer or string" 
            /next {Returns both the type and the input after the value} 
            /fast "Fast scanning, returns best guessed type" 
            return: [datatype! none!] "Recognized or guessed type, or NONE on empty input"
        ] f_load #[object! [
            source: #[none]
            header: #[none]
            all: #[none]
            trap: #[none]
            next: #[none]
            position: #[none]
            part: #[none]
            length: #[none]
            into: #[none]
            out: #[none]
            as: #[none]
            type: #[none]
            local: #[none]
            codec: #[none]
            suffix: #[none]
            name: #[none]
            mime: #[none]
            pre-load: #[none]
            err: #[none]
        ]] ctx||189 [
            {Returns a value or block of values by reading and evaluating a source} 
            source [binary! file! string! url!] 
            /header "TBD" 
            /all {Load all values, returns a block. TBD: Don't evaluate Red header} 
            /trap "Load all values, returns [[values] position error]" 
            /next {Load the next value only, updates source series word} 
            position [word!] "Word updated with new series position" 
            /part "Limit to a length or position" 
            length [integer! string!] 
            /into {Put results in out block, instead of creating a new block} 
            out [block!] "Target block for results" 
            /as "Specify the type of data; use NONE to load as code" 
            type [none! word!] "E.g. bmp, gif, jpeg, png, redbin, json, csv" 
            /local codec suffix name mime pre-load err
        ] f_save #[object! [
            where: #[none]
            value: #[none]
            header: #[none]
            header-data: #[none]
            all: #[none]
            length: #[none]
            as: #[none]
            format: #[none]
            local: #[none]
            dst: #[none]
            codec: #[none]
            data: #[none]
            suffix: #[none]
            find-encoder?: #[none]
            name: #[none]
            only: #[none]
            pos: #[none]
            header-str: #[none]
            k: #[none]
            v: #[none]
        ]] ctx||190 [
            {Saves a value, block, or other data to a file, URL, binary, or string} 
            where [binary! file! none! string! url!] "Where to save" 
            value [any-type!] "Value(s) to save" 
            /header {Provide a Red header block (or output non-code datatypes)} 
            header-data [block! object!] 
            /all "TBD: Save in serialized format" 
            /length {Save the length of the script content in the header} 
            /as {Specify the format of data; use NONE to save as plain text} 
            format [none! word!] "E.g. bmp, gif, jpeg, png, redbin, json, csv" 
            /local dst codec data suffix find-encoder? name only pos header-str k v
        ] f_cause-error #[object! [
            err-type: #[none]
            err-id: #[none]
            args: #[none]
        ]] ctx||191 [
            {Causes an immediate error throw, with the provided information} 
            err-type [word!] 
            err-id [word!] 
            args [block! string!]
        ] f_pad #[object! [
            str: #[none]
            n: #[none]
            left: #[none]
            with: #[none]
            c: #[none]
        ]] ctx||192 [
            "Pad a FORMed value on right side with spaces" 
            str "Value to pad, FORM it if not a string" 
            n [integer!] "Total size (in characters) of the new string" 
            /left "Pad the string on left side" 
            /with "Pad with char" 
            c [char!] 
            return: [string!] "Modified input string at head"
        ] f_mod #[object! [
            a: #[none]
            b: #[none]
            local: #[none]
            r: #[none]
        ]] ctx||193 [
            "Compute a nonnegative remainder of A divided by B" 
            a [char! money! number! pair! time! tuple! vector!] 
            b [char! money! number! pair! time! tuple! vector!] "Must be nonzero" 
            return: [number! money! char! pair! tuple! vector! time!] 
            /local r
        ] f_modulo #[object! [
            a: #[none]
            b: #[none]
            local: #[none]
            r: #[none]
        ]] ctx||194 [
            {Wrapper for MOD that handles errors like REMAINDER. Negligible values (compared to A and B) are rounded to zero} 
            a [char! money! number! pair! time! tuple! vector!] 
            b [char! money! number! pair! time! tuple! vector!] 
            return: [number! money! char! pair! tuple! vector! time!] 
            /local r
        ] f_eval-set-path #[object! [
            value1: #[none]
        ]] ctx||195 ["Internal Use Only" value1] f_to-red-file #[object! [
            path: #[none]
            local: #[none]
            colon?: #[none]
            slash?: #[none]
            len: #[none]
            i: #[none]
            c: #[none]
            dst: #[none]
        ]] ctx||196 [
            {Converts a local system file path to a Red file path} 
            path [file! string!] 
            return: [file!] 
            /local colon? slash? len i c dst
        ] f_dir? #[object! [
            file: #[none]
        ]] ctx||197 [{Returns TRUE if the value looks like a directory spec} file [file! url!]] f_normalize-dir #[object! [
            dir: #[none]
        ]] ctx||198 [
            "Returns an absolute directory spec" 
            dir [file! path! word!]
        ] f_what-dir #[object! [
            local: #[none]
            path: #[none]
        ]] ctx||199 [
            "Returns the active directory path" 
            /local path
        ] f_change-dir #[object! [
            dir: #[none]
        ]] ctx||200 [
            "Changes the active directory path" 
            dir [file! path! word!] {New active directory of relative path to the new one}
        ] f_make-dir #[object! [
            path: #[none]
            deep: #[none]
            local: #[none]
            dirs: #[none]
            end: #[none]
            created: #[none]
            dir: #[none]
        ]] ctx||201 [
            {Creates the specified directory. No error if already exists} 
            path [file!] 
            /deep "Create subdirectories too" 
            /local dirs end created dir
        ] f_extract #[object! [
            series: #[none]
            width: #[none]
            index: #[none]
            pos: #[none]
            into: #[none]
            output: #[none]
        ]] ctx||202 [
            {Extracts a value from a series at regular intervals} 
            series [series!] 
            width [integer!] "Size of each entry (the skip)" 
            /index "Extract from an offset position" 
            pos [integer!] "The position" 
            /into {Provide an output series instead of creating a new one} 
            output [series!] "Output series"
        ] f_extract-boot-args #[object! [
            local: #[none]
            args: #[none]
            at-arg2: #[none]
            ws: #[none]
            buf: #[none]
            s: #[none]
        ]] ctx||203 [
            {Process command-line arguments and store values in system/options (internal usage)} 
            /local args at-arg2 ws buf s
        ] f_collect #[object! [
            body: #[none]
            into: #[none]
            collected: #[none]
            local: #[none]
            keep: #[none]
            rule: #[none]
            pos: #[none]
        ]] ctx||204 [
            {Collect in a new block all the values passed to KEEP function from the body block} 
            body [block!] "Block to evaluate" 
            /into {Insert into a buffer instead (returns position after insert)} 
            collected [series!] "The buffer series (modified)" 
            /local keep rule pos
        ] f_flip-exe-flag #[object! [
            path: #[none]
            local: #[none]
            file: #[none]
            buffer: #[none]
            flag: #[none]
        ]] ctx||205 [
            {Flip the sub-system for the red.exe between console and GUI modes (Windows only)} 
            path [file!] "Path to the red.exe" 
            /local file buffer flag
        ] f_split #[object! [
            series: #[none]
            dlm: #[none]
            local: #[none]
            s: #[none]
            num: #[none]
        ]] ctx||206 [
            {Break a string series into pieces using the provided delimiters} 
            series [any-string!] dlm [bitset! char! string!] /local s 
            num
        ] f_dirize #[object! [
            path: #[none]
        ]] ctx||207 [
            "Returns a copy of the path turned into a directory" 
            path [file! string! url!]
        ] f_clean-path #[object! [
            file: #[none]
            only: #[none]
            dir: #[none]
            local: #[none]
            out: #[none]
            cnt: #[none]
            f: #[none]
            not-file?: #[none]
            prot: #[none]
        ]] ctx||208 [
            [no-trace] 
            {Cleans-up '.' and '..' in path; returns the cleaned path} 
            file [file! string! url!] 
            /only "Do not prepend current directory" 
            /dir "Add a trailing / if missing" 
            /local out cnt f not-file? prot
        ] f_split-path #[object! [
            target: #[none]
            local: #[none]
            dir: #[none]
            pos: #[none]
        ]] ctx||209 [
            [no-trace] 
            {Splits a file or URL path. Returns a block containing path and target} 
            target [file! url!] 
            /local dir pos
        ] f_do-file #[object! [
            file: #[none]
            callback: #[none]
            do-args: #[none]
            local: #[none]
            ws: #[none]
            saved: #[none]
            src: #[none]
            code: #[none]
            header?: #[none]
            header: #[none]
            list: #[none]
            c: #[none]
            done?: #[none]
            found?: #[none]
            obj: #[none]
            parent: #[none]
            path: #[none]
            args: #[none]
        ]] ctx||210 [
            "Internal Use Only" file [file! url!] callback [function! none!] do-args 
            /local ws saved src code header? header list c done? found? obj 
            parent path args
        ] f_path-thru #[object! [
            url: #[none]
            local: #[none]
            so: #[none]
            hash: #[none]
            file: #[none]
            path: #[none]
        ]] ctx||211 [
            "Returns the local disk cache path of a remote file" 
            url [url!] "Remote file address" 
            return: [file!] 
            /local so hash file path
        ] f_exists-thru? #[object! [
            url: #[none]
        ]] ctx||212 [
            {Returns true if the remote file is present in the local disk cache} 
            url [file! url!] "Remote file address"
        ] f_read-thru #[object! [
            url: #[none]
            update: #[none]
            binary: #[none]
            local: #[none]
            path: #[none]
            data: #[none]
        ]] ctx||213 [
            "Reads a remote file through local disk cache" 
            url [url!] "Remote file address" 
            /update "Force a cache update" 
            /binary "Use binary mode" 
            /local path data
        ] f_load-thru #[object! [
            url: #[none]
            update: #[none]
            as: #[none]
            type: #[none]
            local: #[none]
            path: #[none]
            file: #[none]
        ]] ctx||214 [
            "Loads a remote file through local disk cache" 
            url [url!] "Remote file address" 
            /update "Force a cache update" 
            /as "Specify the type of data; use NONE to load as code" 
            type [none! word!] "E.g. bmp, gif, jpeg, png" 
            /local path file
        ] f_do-thru #[object! [
            url: #[none]
            update: #[none]
        ]] ctx||215 [
            {Evaluates a remote Red script through local disk cache} 
            url [url!] "Remote file address" 
            /update "Force a cache update"
        ] f_cos #[object! [
            angle: #[none]
        ]] ctx||216 [
            "Returns the trigonometric cosine" 
            angle [float!] "Angle in radians"
        ] f_sin #[object! [
            angle: #[none]
        ]] ctx||217 [
            "Returns the trigonometric sine" 
            angle [float!] "Angle in radians"
        ] f_tan #[object! [
            angle: #[none]
        ]] ctx||218 [
            "Returns the trigonometric tangent" 
            angle [float!] "Angle in radians"
        ] f_acos #[object! [
            cosine: #[none]
        ]] ctx||219 [
            {Returns the trigonometric arccosine in radians in range [0,pi]} 
            cosine [float!] "in range [-1,1]"
        ] f_asin #[object! [
            sine: #[none]
        ]] ctx||220 [
            {Returns the trigonometric arcsine in radians in range [-pi/2,pi/2])} 
            sine [float!] "in range [-1,1]"
        ] f_atan #[object! [
            tangent: #[none]
        ]] ctx||221 [
            {Returns the trigonometric arctangent in radians in range [-pi/2,+pi/2]} 
            tangent [float!] "in range [-inf,+inf]"
        ] f_atan2 #[object! [
            y: #[none]
            x: #[none]
        ]] ctx||222 [
            {Returns the smallest angle between the vectors (1,0) and (x,y) in range (-pi,pi]} 
            y [float! integer!] 
            x [float! integer!] 
            return: [float!]
        ] f_sqrt #[object! [
            number: #[none]
        ]] ctx||223 [
            "Returns the square root of a number" 
            number [float! integer! percent!] 
            return: [float!]
        ] f_to-UTC-date #[object! [
            date: #[none]
        ]] ctx||224 [
            "Returns the date with UTC zone" 
            date [date!] 
            return: [date!]
        ] f_to-local-date #[object! [
            date: #[none]
        ]] ctx||225 [
            "Returns the date with local zone" 
            date [date!] 
            return: [date!]
        ] f_show-memory-stats #[object! [
            data: #[none]
            local: #[none]
            class: #[none]
            used: #[none]
            total: #[none]
            i: #[none]
            c: #[none]
            frm: #[none]
            unit: #[none]
        ]] ctx||226 [data [block!] 
            /local class used total i c frm unit
        ] f_transcode-trace #[object! [
            src: #[none]
        ]] ctx||227 [
            {Shortcut function for transcoding while tracing all lexer events} 
            src [binary! string!]
        ] f_rejoin #[object! [
            block: #[none]
        ]] ctx||228 [
            "Reduces and joins a block of values." 
            block [block!] "Values to reduce and join"
        ] f_sum #[object! [
            values: #[none]
            local: #[none]
            result: #[none]
            value: #[none]
        ]] ctx||229 [
            "Returns the sum of all values in a block" 
            values [block! hash! paren! vector!] 
            /local result value
        ] f_average #[object! [
            block: #[none]
        ]] ctx||230 [
            "Returns the average of all values in a block" 
            block [block! hash! paren! vector!]
        ] f_last? #[object! [
            series: #[none]
        ]] ctx||231 [
            "Returns TRUE if the series length is 1" 
            series [series!]
        ] f_dt #[object! [
            body: #[none]
            local: #[none]
            t0: #[none]
        ]] ctx||232 [
            "Returns the time required to evaluate a block" 
            body [block!] 
            return: [time!] 
            /local t0
        ] f_clock #[object! [
            code: #[none]
            times: #[none]
            n: #[none]
            local: #[none]
            result: #[none]
            text: #[none]
            dt: #[none]
            unit: #[none]
        ]] ctx||233 [
            {Display execution time of code, returning result of it's evaluation} 
            code [block!] 
            /times n [float! integer!] 
            {Repeat N times (default: once); displayed time is per iteration} 
            /local result 
            text dt unit
        ] f_ctx||264~interpreted? #[object! [
        ]] ctx||266 ["Return TRUE if called from the interpreter"] f_ctx||267~on-change* #[object! [
            word: #[none]
            old: #[none]
            new: #[none]
            local: #[none]
            idx: #[none]
        ]] ctx||269 [word old new 
            /local idx
        ] f_ctx||276~on-change* #[object! [
            word: #[none]
            old: #[none]
            new: #[none]
        ]] ctx||278 [word old new] f_ctx||276~on-deep-change* #[object! [
            owner: #[none]
            word: #[none]
            target: #[none]
            action: #[none]
            new: #[none]
            index: #[none]
            part: #[none]
        ]] ctx||279 [owner word target action new index part] f_ctx||282~on-change* #[object! [
            word: #[none]
            old: #[none]
            new: #[none]
        ]] ctx||284 [word old new] f_ctx||280~on-change* #[object! [
            word: #[none]
            old: #[none]
            new: #[none]
        ]] ctx||285 [word old new] f_ctx||280~on-deep-change* #[object! [
            owner: #[none]
            word: #[none]
            target: #[none]
            action: #[none]
            new: #[none]
            index: #[none]
            part: #[none]
        ]] ctx||286 [owner word target action new index part] f_ctx||312~trapper #[object! [
            event: #[none]
            input: #[none]
            type: #[none]
            line: #[none]
            token: #[none]
        ]] ctx||314 [
            event [word!] 
            input [binary! string!] 
            type [datatype! none! word!] 
            line [integer!] 
            token 
            return: [logic!]
        ] f_ctx||312~tracer #[object! [
            event: #[none]
            input: #[none]
            type: #[none]
            line: #[none]
            token: #[none]
        ]] ctx||315 [
            event [word!] 
            input [binary! string!] 
            type [datatype! none! word!] 
            line [integer!] 
            token 
            return: [logic!]
        ] f_ctx||328~encode #[object! [
            data: #[none]
            where: #[none]
        ]] ctx||331 [data [any-type!] where [any-type!]] f_ctx||332~on-change* #[object! [
            word: #[none]
            old: #[none]
            new: #[none]
        ]] ctx||334 [word old new] f_ctx||335~on-change* #[object! [
            word: #[none]
            old: #[none]
            new: #[none]
        ]] ctx||337 [word old new] f_ctx||335~on-deep-change* #[object! [
            owner: #[none]
            word: #[none]
            target: #[none]
            action: #[none]
            new: #[none]
            index: #[none]
            part: #[none]
        ]] ctx||338 [owner word target action new index part] f_reactor #[object! [
            spec: #[none]
        ]] ctx||339 [spec [block!]] f_deep-reactor #[object! [
            spec: #[none]
        ]] ctx||340 [spec [block!]] f_ctx||341~add-relation #[object! [
            obj: #[none]
            word: #[none]
            reaction: #[none]
            targets: #[none]
            local: #[none]
            new-rel: #[none]
        ]] ctx||343 [
            obj [object!] 
            word 
            reaction [block! function!] 
            targets [block! none! object! set-word!] 
            /local new-rel
        ] f_ctx||341~identify-sources #[object! [
            path: #[none]
            reaction: #[none]
            ctx: #[none]
            local: #[none]
            obj: #[none]
            p: #[none]
            found?: #[none]
            slice: #[none]
        ]] ctx||344 [path [any-path!] reaction ctx return: [logic!] /local obj 
            p found? slice
        ] f_ctx||341~eval #[object! [
            code: #[none]
            safe: #[none]
            local: #[none]
            result: #[none]
        ]] ctx||345 [code [block!] /safe 
            /local result
        ] f_ctx||341~eval-reaction #[object! [
            reactor: #[none]
            reaction: #[none]
            target: #[none]
            mark: #[none]
        ]] ctx||346 [reactor [object!] reaction [block! function!] target /mark] f_ctx||341~pending? #[object! [
            reactor: #[none]
            reaction: #[none]
            local: #[none]
            q: #[none]
        ]] ctx||347 [reactor [object!] reaction [block! function!] 
            /local q
        ] f_ctx||341~check #[object! [
            reactor: #[none]
            only: #[none]
            field: #[none]
            local: #[none]
            pos: #[none]
            reaction: #[none]
            q: #[none]
            q': #[none]
        ]] ctx||348 [reactor [object!] /only field [set-word! word!] 
            /local pos reaction q q'
        ] f_no-react #[object! [
            body: #[none]
            local: #[none]
            result: #[none]
        ]] ctx||349 [
            {Evaluates a block with all previously defined reactions disabled} 
            body [block!] "Code block to evaluate" 
            /local result
        ] f_stop-reactor #[object! [
            face: #[none]
            deep: #[none]
            local: #[none]
            list: #[none]
            pos: #[none]
            f: #[none]
        ]] ctx||350 [
            face [object!] 
            /deep 
            /local list pos f
        ] f_clear-reactions #[object! [
        ]] ctx||351 ["Removes all reactive relations"] f_dump-reactions #[object! [
            local: #[none]
            limit: #[none]
            count: #[none]
            obj: #[none]
            field: #[none]
            reaction: #[none]
            target: #[none]
            list: #[none]
        ]] ctx||352 [
            {Outputs all the current reactive relations for debugging purpose} 
            /local limit count obj field reaction target list
        ] f_relate #[object! [
            field: #[none]
            reaction: #[none]
            local: #[none]
            obj: #[none]
            rule: #[none]
            item: #[none]
        ]] ctx||353 [
            {Defines a reactive relation whose result is assigned to a word} 
            'field [set-word!] {Set-word which will get set to the result of the reaction} 
            reaction [block!] "Reactive relation" 
            /local obj rule item
        ] f_is #[object! [
        ]] ctx||354 [] f_react? #[object! [
            reactor: #[none]
            field: #[none]
            target: #[none]
            local: #[none]
            pos: #[none]
        ]] ctx||355 [
            {Returns a reactive relation if an object's field is a reactive source} 
            reactor [object!] "Object to check" 
            field [word!] "Field to check" 
            /target {Check if it's a target of an `is` reaction instead of a source} 
            return: [block! function! word! none!] "Returns reaction, type or NONE" 
            /local pos
        ] f_react #[object! [
            reaction: #[none]
            link: #[none]
            objects: #[none]
            unlink: #[none]
            src: #[none]
            later: #[none]
            with: #[none]
            ctx: #[none]
            local: #[none]
            objs: #[none]
            found?: #[none]
            rule: #[none]
            item: #[none]
            pos: #[none]
            obj: #[none]
        ]] ctx||356 [
            {Defines a new reactive relation between two or more objects} 
            reaction [block! function!] "Reactive relation" 
            /link "Link objects together using a reactive relation" 
            objects [block!] "Objects to link together" 
            /unlink "Removes an existing reactive relation" 
            src [block! object! word!] "'all word, or a reactor or a list of reactors" 
            /later "Run the reaction on next change instead of now" 
            /with "Specifies an optional face object (internal use)" 
            ctx [none! object! set-word!] "Optional context for VID faces or target set-word" 
            return: [block! function! none!] {The reactive relation or NONE if no relation was processed} 
            /local objs found? rule item pos obj
        ] f_register-scheme #[object! [
            spec: #[none]
            native: #[none]
            dispatch: #[none]
        ]] ctx||357 [
            "Registers a new scheme" 
            spec [object!] "Scheme definition" 
            /native 
            dispatch [handle!]
        ] f_ctx||358~alpha-num+ #[object! [
            more: #[none]
        ]] ctx||360 [more [string!]] f_ctx||358~parse-url #[object! [
            url: #[none]
            throw-error: #[none]
            local: #[none]
            scheme: #[none]
            user-info: #[none]
            host: #[none]
            port: #[none]
            path: #[none]
            target: #[none]
            query: #[none]
            fragment: #[none]
            ref: #[none]
        ]] ctx||361 [
            {Return object with URL components, or cause an error if not a valid URL} 
            url [string! url!] 
            /throw-error "Throw an error, instead of returning NONE." 
            /local scheme user-info host port path target query fragment ref
        ] f_decode-url #[object! [
            url: #[none]
        ]] ctx||362 [
            {Decode a URL into an object containing its constituent parts} 
            url [string! url!]
        ] f_encode-url #[object! [
            url-obj: #[none]
            local: #[none]
            result: #[none]
        ]] ctx||363 [url-obj [object!] "What you'd get from decode-url" 
            /local result
        ] f_ctx||364~do-quit #[object! [
        ]] ctx||366 [] f_ctx||364~throw-error #[object! [
            error: #[none]
            cmd: #[none]
            code: #[none]
            local: #[none]
            w: #[none]
        ]] ctx||367 [error [error!] cmd [issue!] code [block!] /local w] f_ctx||364~syntax-error #[object! [
            s: #[none]
            e: #[none]
        ]] ctx||368 [s [block! paren!] e [block! paren!]] f_ctx||364~do-safe #[object! [
            code: #[none]
            manual: #[none]
            with: #[none]
            cmd: #[none]
            local: #[none]
            res: #[none]
            t?: #[none]
            src: #[none]
        ]] ctx||369 [code [block! paren!] /manual /with cmd [issue!] /local res t? src] f_ctx||364~do-code #[object! [
            code: #[none]
            cmd: #[none]
            local: #[none]
            p: #[none]
        ]] ctx||370 [code [block! paren!] cmd [issue!] /local p] f_ctx||364~rebind-all #[object! [
            local: #[none]
            rule: #[none]
            p: #[none]
        ]] ctx||371 [/local rule p] f_ctx||364~count-args #[object! [
            spec: #[none]
            block: #[none]
            local: #[none]
            total: #[none]
            pos: #[none]
        ]] ctx||372 [spec [block!] /block /local total pos] f_ctx||364~arg-mode? #[object! [
            spec: #[none]
            idx: #[none]
        ]] ctx||373 [spec [block!] idx [integer!]] f_ctx||364~func-arity? #[object! [
            spec: #[none]
            with: #[none]
            path: #[none]
            block: #[none]
            local: #[none]
            arity: #[none]
            pos: #[none]
        ]] ctx||374 [spec [block!] /with path [path!] /block /local arity pos] f_ctx||364~value-path? #[object! [
            path: #[none]
            local: #[none]
            value: #[none]
            i: #[none]
            item: #[none]
            selectable: #[none]
        ]] ctx||375 [path [path!] /local value i item selectable] f_ctx||364~fetch-next #[object! [
            code: #[none]
            local: #[none]
            i: #[none]
            left: #[none]
            item: #[none]
            item2: #[none]
            value: #[none]
            fn-spec: #[none]
            path: #[none]
            f-arity: #[none]
            at-op?: #[none]
            op-mode: #[none]
        ]] ctx||376 [code [block! paren!] /local i left item item2 value fn-spec path f-arity at-op? op-mode] f_ctx||364~eval #[object! [
            code: #[none]
            cmd: #[none]
            local: #[none]
            after: #[none]
            expr: #[none]
        ]] ctx||377 [code [block! paren!] cmd [issue!] /local after expr] f_ctx||364~do-macro #[object! [
            name: #[none]
            pos: #[none]
            arity: #[none]
            local: #[none]
            cmd: #[none]
            saved: #[none]
            p: #[none]
            v: #[none]
            res: #[none]
        ]] ctx||378 [name pos [block! paren!] arity [integer!] /local cmd saved p v res] f_ctx||364~register-macro #[object! [
            spec: #[none]
            local: #[none]
            cnt: #[none]
            rule: #[none]
            p: #[none]
            name: #[none]
            macro: #[none]
            pos: #[none]
            valid?: #[none]
            named?: #[none]
        ]] ctx||379 [spec [block!] /local cnt rule p name macro pos valid? named?] f_ctx||364~reset #[object! [
            job: #[none]
        ]] ctx||380 [job [none! object!]] f_ctx||364~expand #[object! [
            code: #[none]
            job: #[none]
            clean: #[none]
            local: #[none]
            rule: #[none]
            e: #[none]
            pos: #[none]
            cond: #[none]
            value: #[none]
            then: #[none]
            else: #[none]
            cases: #[none]
            body: #[none]
            keep?: #[none]
            expr: #[none]
            src: #[none]
            saved: #[none]
            file: #[none]
            new: #[none]
        ]] ctx||381 [
            code [block! paren!] job [none! object!] 
            /clean 
            /local rule e pos cond value then else cases body keep? expr src saved file new
        ] f_expand-directives #[object! [
            code: #[none]
            clean: #[none]
            local: #[none]
            job: #[none]
            saved: #[none]
        ]] ctx||382 [
            {Invokes the preprocessor on argument list, modifying and returning it} 
            code [block! paren!] "List of Red values to preprocess" 
            /clean "Clear all previously created macros and words" 
            /local job saved
        ] f_ctx||383~calc-max #[object! [
            used: #[none]
        ]] ctx||393 [used [integer!] return: [integer!]] f_ctx||383~show-context #[object! [
            ctx: #[none]
            local: #[none]
            w: #[none]
            out: #[none]
        ]] ctx||394 [ctx [function! object!] 
            /local w out
        ] f_ctx||383~show-parents #[object! [
            event: #[none]
            local: #[none]
            list: #[none]
            w: #[none]
            pos: #[none]
        ]] ctx||395 [event [word!] 
            /local list w pos
        ] f_ctx||383~show-stack #[object! [
            local: #[none]
            indent: #[none]
            frame: #[none]
        ]] ctx||396 [
            /local indent frame
        ] f_ctx||383~show-watching #[object! [
            local: #[none]
            w: #[none]
            out: #[none]
        ]] ctx||397 [
            /local w out
        ] f_ctx||383~do-command #[object! [
            event: #[none]
            local: #[none]
            watch: #[none]
            list: #[none]
            w: #[none]
            cmd: #[none]
            add?: #[none]
        ]] ctx||398 [event [word!] 
            /local watch list w cmd add?
        ] f_ctx||383~debugger #[object! [
            event: #[none]
            code: #[none]
            offset: #[none]
            value: #[none]
            ref: #[none]
            frame: #[none]
            local: #[none]
            store: #[none]
            idx: #[none]
            pos: #[none]
            indent: #[none]
            sch: #[none]
            out: #[none]
            set-ref: #[none]
            limit: #[none]
        ]] ctx||399 [
            event [word!] 
            code [any-block! none!] 
            offset [integer!] 
            value [any-type!] 
            ref [any-type!] 
            frame [pair!] 
            /local store idx pos indent sch out set-ref limit
        ] f_ctx||400~mold-part #[object! [
            value: #[none]
            part: #[none]
            only: #[none]
            local: #[none]
            r: #[none]
            open: #[none]
            close: #[none]
        ]] ctx||402 [value [any-type!] part [integer!] /only 
            /local r open close
        ] f_ctx||400~dumper #[object! [
            event: #[none]
            code: #[none]
            offset: #[none]
            value: #[none]
            ref: #[none]
            frame: #[none]
        ]] ctx||403 [
            event [word!] 
            code [any-block! none!] 
            offset [integer!] 
            value [any-type!] 
            ref [any-type!] 
            frame [pair!]
        ] f_ctx||400~push #[object! [
            s: #[none]
            i: #[none]
            dup: #[none]
            n: #[none]
        ]] ctx||404 [s [series!] i [any-type!] /dup n [integer!]] f_ctx||400~drop #[object! [
            s: #[none]
            n: #[none]
        ]] ctx||405 [s [series!] n [integer!]] f_ctx||400~pop #[object! [
            s: #[none]
        ]] ctx||406 [s [series!]] f_ctx||400~top-of #[object! [
            s: #[none]
        ]] ctx||407 [s [series!]] f_ctx||400~step #[object! [
            s: #[none]
            down: #[none]
        ]] ctx||408 [s [series!] /down] f_ctx||409~put #[object! [
            block: #[none]
        ]] ctx||411 [block [block!]] f_ctx||409~get #[object! [
        ]] ctx||412 [] f_ctx||413~save-level #[object! [
            frame: #[none]
            local: #[none]
            word: #[none]
            value: #[none]
        ]] ctx||415 ["Save current nesting level on the stack" frame [pair!] 
            /local word value
        ] f_ctx||413~unroll-level #[object! [
            local: #[none]
            i: #[none]
            n: #[none]
            value: #[none]
            word: #[none]
        ]] ctx||416 ["Unroll last nesting level from the stack" 
            /local i n value word
        ] f_ctx||413~reset #[object! [
            local: #[none]
            block-name: #[none]
        ]] ctx||417 ["Reset collector's data" 
            /local block-name
        ] f_ctx||413~collector #[object! [
            event: #[none]
            code: #[none]
            offset: #[none]
            value: #[none]
            ref: #[none]
            frame: #[none]
            local: #[none]
            call: #[none]
            saved-frame: #[none]
            isop?: #[none]
            bgn: #[none]
            word: #[none]
        ]] ctx||418 [
            {Generic tracer that collects high-level tracing info} 
            event [word!] 
            code [default!] 
            offset [integer!] 
            value [any-type!] 
            ref [any-type!] 
            frame [pair!] 
            /local call saved-frame isop? bgn word
        ] f_ctx||400~guided-trace #[object! [
            inspect: #[none]
            code: #[none]
            all?: #[none]
            deep?: #[none]
            debug?: #[none]
            local: #[none]
            b: #[none]
            rule: #[none]
        ]] ctx||419 [
            {Trace a block of code, providing 'inspect' tracer with collected data} 
            inspect [function!] {func [data [object!] event code offset value ref frame]} 
            code [any-type!] 
            all? [logic!] "Trace all sub-expressions of each expression" 
            deep? [logic!] "Enter functions and natives" 
            debug? [logic!] "Dump all events encountered" 
            /local b rule
        ] f_ctx||420~inspect #[object! [
            data: #[none]
            event: #[none]
            code: #[none]
            offset: #[none]
            value: #[none]
            ref: #[none]
            local: #[none]
            word: #[none]
            report?: #[none]
            full: #[none]
            width: #[none]
            left: #[none]
            right: #[none]
            indent: #[none]
            indent2: #[none]
            level: #[none]
            expr: #[none]
            path: #[none]
            p: #[none]
            pexpr: #[none]
            orig-expr: #[none]
            name: #[none]
        ]] ctx||422 [
            data [object!] 
            event [word!] 
            code [default!] 
            offset [integer!] 
            value [any-type!] 
            ref [any-type!] 
            /local word 
            report? full width left right indent indent2 level expr path p pexpr orig-expr name
        ] f_ctx||383~profiler #[object! [
            event: #[none]
            code: #[none]
            offset: #[none]
            value: #[none]
            ref: #[none]
            frame: #[none]
            local: #[none]
            anon: #[none]
            time: #[none]
            opt: #[none]
            pos: #[none]
            entry: #[none]
        ]] ctx||423 [
            event [word!] 
            code [any-block! none!] 
            offset [integer!] 
            value [any-type!] 
            ref [any-type!] 
            frame [pair!] 
            /local anon time opt pos entry
        ] f_ctx||383~do-handler #[object! [
            code: #[none]
            handler: #[none]
        ]] ctx||424 [code [any-type!] handler [function!]] f_profile #[object! [
            code: #[none]
            by: #[none]
            cat: #[none]
            local: #[none]
            saved: #[none]
            rank: #[none]
            name: #[none]
            cnt: #[none]
            duration: #[none]
        ]] ctx||425 [
            {Profile the argument code, counting calls and their cumulative duration, then print a report} 
            code [any-type!] "Code to profile" 
            /by 
            cat [word!] "Sort by: 'name, 'count, 'time" 
            /local saved rank name cnt duration
        ] f_trace #[object! [
            code: #[none]
            raw: #[none]
            deep: #[none]
            all: #[none]
            debug: #[none]
        ]] ctx||426 [
            {Runs argument code and prints an evaluation trace; also turns on/off tracing} 
            code [any-type!] "Code to trace or tracing mode (logic!)" 
            /raw {Switch to raw interpreter events tracing (incompatible with other modes)} 
            /deep "Trace into functions and natives" 
            /all "Trace all sub-expressions of each expression" 
            /debug {Used internally to debug the tracer itself (outputs all events)}
        ] f_debug #[object! [
            code: #[none]
            later: #[none]
        ]] ctx||427 [
            "Runs argument code through an interactive debugger" 
            code [any-type!] "Code to debug" 
            /later {Enters the interactive debugger later, on reading @stop value}
        ] f_hex-to-rgb #[object! [
            hex: #[none]
            local: #[none]
            str: #[none]
            bin: #[none]
        ]] ctx||428 [
            {Converts a color in hex format to a tuple value; returns NONE if it fails} 
            hex [issue!] "Accepts #rgb, #rrggbb, #rrggbbaa" 
            return: [tuple! none!] 
            /local str bin
        ] f_within? #[object! [
            point: #[none]
            offset: #[none]
            size: #[none]
        ]] ctx||429 [
            {Return TRUE if the point is within the rectangle bounds} 
            point [planar!] "XY position" 
            offset [planar!] "Offset of area" 
            size [planar!] "Size of area" 
            return: [logic!]
        ] f_overlap? #[object! [
            A: #[none]
            B: #[none]
            local: #[none]
            A1: #[none]
            B1: #[none]
            A2: #[none]
            B2: #[none]
        ]] ctx||430 [
            {Return TRUE if the two faces bounding boxes are overlapping} 
            A [object!] "First face" 
            B [object!] "Second face" 
            return: [logic!] "TRUE if overlapping" 
            /local A1 B1 A2 B2
        ] f_distance? #[object! [
            A: #[none]
            B: #[none]
            local: #[none]
            d: #[none]
        ]] ctx||431 [
            {Returns the distance between 2 points or face centers} 
            A [object! planar!] "First face or point" 
            B [object! planar!] "Second face or point" 
            return: [float!] "Distance between them" 
            /local d
        ] f_send-event #[object! [
            event: #[none]
            no-wait: #[none]
        ]] ctx||432 [
            event [event!] 
            /no-wait 
            return: [logic!]
        ] f_face? #[object! [
            value: #[none]
        ]] ctx||433 [
            value 
            return: [logic!]
        ] f_get-current-screen #[object! [
            local: #[none]
            handle: #[none]
            screen: #[none]
        ]] ctx||434 [
            return: [object!] 
            /local handle screen
        ] f_size-text #[object! [
            face: #[none]
            with: #[none]
            text: #[none]
            local: #[none]
            h: #[none]
        ]] ctx||435 [
            face [object!] 
            /with 
            text [string!] 
            return: [point2D! none!] 
            /local h
        ] f_caret-to-offset #[object! [
            face: #[none]
            pos: #[none]
            lower: #[none]
            local: #[none]
            opt: #[none]
        ]] ctx||436 [
            face [object!] 
            pos [integer!] 
            /lower 
            return: [point2D!] 
            /local opt
        ] f_offset-to-caret #[object! [
            face: #[none]
            pt: #[none]
        ]] ctx||437 [
            face [object!] 
            pt [planar!] 
            return: [integer!]
        ] f_offset-to-char #[object! [
            face: #[none]
            pt: #[none]
        ]] ctx||438 [
            face [object!] 
            pt [planar!] 
            return: [integer!]
        ] f_ctx||441~tail-idx? #[object! [
        ]] ctx||443 [] f_ctx||441~push-color #[object! [
            c: #[none]
        ]] ctx||444 [c [tuple!]] f_ctx||441~pop-color #[object! [
            local: #[none]
            entry: #[none]
            pos: #[none]
        ]] ctx||445 [/local entry pos] f_ctx||441~close-colors #[object! [
            local: #[none]
            pos: #[none]
        ]] ctx||446 [/local pos] f_ctx||441~push #[object! [
            style: #[none]
        ]] ctx||447 [style [block! word!]] f_ctx||441~pop #[object! [
            style: #[none]
            local: #[none]
            entry: #[none]
            type: #[none]
        ]] ctx||448 [style [word!] 
            /local entry type
        ] f_ctx||441~pop-all #[object! [
            mark: #[none]
            local: #[none]
            first?: #[none]
            i: #[none]
        ]] ctx||449 [mark [block!] 
            /local first? i
        ] f_ctx||441~optimize #[object! [
            local: #[none]
            cur: #[none]
            pos: #[none]
            range: #[none]
            pos1: #[none]
            e: #[none]
            s: #[none]
            l: #[none]
            mov: #[none]
        ]] ctx||450 [
            /local cur pos range pos1 e s l mov
        ] f_rtd-layout #[object! [
            spec: #[none]
            only: #[none]
            with: #[none]
            face: #[none]
        ]] ctx||451 [
            "Returns a rich-text face from a RTD source code" 
            spec [block!] "RTD source code" 
            /only "Returns only [text data] facets" 
            /with "Populate an existing face object" 
            face [object!] "Face object to populate" 
            return: [object! block!]
        ] f_ctx||439~line-height? #[object! [
            face: #[none]
            pos: #[none]
        ]] ctx||452 [
            face [object!] 
            pos [integer!] 
            return: [float!]
        ] f_ctx||439~line-count? #[object! [
            face: #[none]
        ]] ctx||453 [
            face [object!] 
            return: [integer!]
        ] f_metrics? #[object! [
            face: #[none]
            type: #[none]
            total: #[none]
            axis: #[none]
            local: #[none]
            res: #[none]
        ]] ctx||454 [
            face [object!] 
            type [word!] 
            /total 
            axis [word!] 
            /local res
        ] f_set-flag #[object! [
            face: #[none]
            flag: #[none]
            clear: #[none]
            toggle: #[none]
            local: #[none]
            flags: #[none]
            pos: #[none]
        ]] ctx||455 [
            face [object!] 
            flag [any-type!] 
            /clear 
            /toggle 
            /local flags pos
        ] f_debug-info? #[object! [
            face: #[none]
        ]] ctx||456 [face [object!] return: [logic!]] f_on-face-deep-change* #[object! [
            owner: #[none]
            word: #[none]
            target: #[none]
            action: #[none]
            new: #[none]
            index: #[none]
            part: #[none]
            state: #[none]
            forced?: #[none]
            local: #[none]
            w: #[none]
            diff?: #[none]
            faces: #[none]
            face: #[none]
            modal?: #[none]
            screen: #[none]
            pane: #[none]
        ]] ctx||457 [owner word target action new index part state forced? 
            /local w diff? faces face modal? screen pane
        ] f_link-tabs-to-parent #[object! [
            face: #[none]
            init: #[none]
            local: #[none]
            faces: #[none]
            visible?: #[none]
        ]] ctx||458 [
            face [object!] 
            /init 
            /local faces visible?
        ] f_link-sub-to-parent #[object! [
            face: #[none]
            type: #[none]
            old: #[none]
            new: #[none]
            local: #[none]
            parent: #[none]
            found: #[none]
        ]] ctx||459 [face [object!] type [word!] old new 
            /local parent found
        ] f_update-font-faces #[object! [
            parent: #[none]
            local: #[none]
            f: #[none]
        ]] ctx||460 [parent [block! none!] 
            /local f
        ] f_ctx||461~on-change* #[object! [
            word: #[none]
            old: #[none]
            new: #[none]
            local: #[none]
            same-pane?: #[none]
            f: #[none]
            new-type: #[none]
            saved: #[none]
            value: #[none]
        ]] ctx||463 [word old new 
            /local same-pane? f new-type saved value
        ] f_ctx||461~on-deep-change* #[object! [
            owner: #[none]
            word: #[none]
            target: #[none]
            action: #[none]
            new: #[none]
            index: #[none]
            part: #[none]
        ]] ctx||464 [owner word target action new index part] f_ctx||465~on-change* #[object! [
            word: #[none]
            old: #[none]
            new: #[none]
        ]] ctx||467 [word old new] f_ctx||465~on-deep-change* #[object! [
            owner: #[none]
            word: #[none]
            target: #[none]
            action: #[none]
            new: #[none]
            index: #[none]
            part: #[none]
        ]] ctx||468 [owner word target action new index part] f_ctx||469~on-change* #[object! [
            word: #[none]
            old: #[none]
            new: #[none]
            local: #[none]
            f: #[none]
        ]] ctx||471 [word old new 
            /local f
        ] f_ctx||472~on-change* #[object! [
            word: #[none]
            old: #[none]
            new: #[none]
        ]] ctx||474 [word old new] f_ctx||475~capture-events #[object! [
            face: #[none]
            event: #[none]
            local: #[none]
            result: #[none]
        ]] ctx||481 [face [object!] event [event!] /local result] f_ctx||475~awake #[object! [
            event: #[none]
            with: #[none]
            face: #[none]
            local: #[none]
            result: #[none]
            result2: #[none]
            name: #[none]
            handler: #[none]
            screen: #[none]
            pos: #[none]
        ]] ctx||482 [event [event!] /with face /local result result2 
            name handler screen pos
        ] f_ctx||475~on-change* #[object! [
            word: #[none]
            old: #[none]
            new: #[none]
            local: #[none]
            screen: #[none]
            wins: #[none]
            win: #[none]
        ]] ctx||483 [word old new 
            /local screen wins win
        ] f_ctx||484~all-windows-closed? #[object! [
            local: #[none]
            closed?: #[none]
        ]] ctx||486 [return: [logic!] /local closed? [logic!]] f_ctx||484~refresh-screens #[object! [
            local: #[none]
            svs: #[none]
            spec: #[none]
            screen: #[none]
        ]] ctx||487 [/local svs spec screen] f_ctx||484~init #[object! [
            local: #[none]
            svs: #[none]
            colors: #[none]
            fonts: #[none]
        ]] ctx||488 [/local svs colors fonts] f_draw #[object! [
            image: #[none]
            cmd: #[none]
            transparent: #[none]
        ]] ctx||489 [
            "Draws scalable vector graphics to an image" 
            image [image! pair!] "Image or size for an image" 
            cmd [block!] "Draw commands" 
            /transparent "Make a transparent image, if pair! spec is used" 
            return: [image!]
        ] f_ctx||494~count-faces #[object! [
            parent: #[none]
            type: #[none]
            local: #[none]
            cnt: #[none]
            f: #[none]
        ]] ctx||496 [parent [object!] type [block! word!] 
            /local cnt f
        ] f_ctx||494~Cancel-OK #[object! [
            root: #[none]
            local: #[none]
            pos-x: #[none]
            last-but: #[none]
            pos-y: #[none]
            f: #[none]
        ]] ctx||497 [
            "Put OK buttons last" 
            root [object!] 
            /local pos-x last-but pos-y f
        ] f_ctx||492~process #[object! [
            root: #[none]
            local: #[none]
            list: #[none]
            name: #[none]
        ]] ctx||498 [root [object!] 
            /local list name
        ] f_ctx||490~throw-error #[object! [
            spec: #[none]
        ]] ctx||501 [spec [block!]] f_ctx||490~process-reactors #[object! [
            reactors: #[none]
            local: #[none]
            res: #[none]
            f: #[none]
            blk: #[none]
            later?: #[none]
            ctx: #[none]
            face: #[none]
        ]] ctx||502 [reactors [block!] /local res 
            f blk later? ctx face
        ] f_ctx||490~opt-as-integer #[object! [
            value: #[none]
            local: #[none]
            i: #[none]
        ]] ctx||503 [value [float! integer!] 
            /local i
        ] f_ctx||490~calc-size #[object! [
            face: #[none]
            local: #[none]
            min-sz: #[none]
            data: #[none]
            txt: #[none]
            s: #[none]
            len: #[none]
            mark: #[none]
            e: #[none]
            new: #[none]
        ]] ctx||504 [face [object!] 
            /local min-sz data txt s len mark e new
        ] f_ctx||490~align-faces #[object! [
            pane: #[none]
            dir: #[none]
            align: #[none]
            max-sz: #[none]
            local: #[none]
            edge?: #[none]
            top-left?: #[none]
            axis: #[none]
            svmm: #[none]
            face: #[none]
            offset: #[none]
            mar: #[none]
            type: #[none]
        ]] ctx||505 [pane [block!] dir [word!] align [word!] max-sz [float! integer!] 
            /local edge? top-left? axis svmm face offset mar type
        ] f_ctx||490~resize-child-panels #[object! [
            tab: #[none]
            local: #[none]
            tp-size: #[none]
            pad: #[none]
            pane: #[none]
        ]] ctx||506 [tab [object!] 
            /local tp-size pad pane
        ] f_ctx||490~clean-style #[object! [
            tmpl: #[none]
            type: #[none]
            local: #[none]
            para: #[none]
            font: #[none]
        ]] ctx||507 [tmpl [block!] type [word!] /local para font] f_ctx||490~process-draw #[object! [
            code: #[none]
            local: #[none]
            rule: #[none]
            pos: #[none]
            color: #[none]
        ]] ctx||508 [code [block!] 
            /local rule pos color
        ] f_ctx||490~pre-load #[object! [
            value: #[none]
            local: #[none]
            color: #[none]
        ]] ctx||509 [value 
            /local color
        ] f_ctx||490~preset-focus #[object! [
            face: #[none]
            local: #[none]
            p: #[none]
        ]] ctx||510 [face [object!] 
            /local p
        ] f_ctx||490~add-option #[object! [
            opts: #[none]
            spec: #[none]
            local: #[none]
            field: #[none]
            value: #[none]
        ]] ctx||511 [opts [object!] spec [block!] 
            /local field value
        ] f_ctx||490~add-flag #[object! [
            obj: #[none]
            facet: #[none]
            field: #[none]
            flag: #[none]
            local: #[none]
            blk: #[none]
        ]] ctx||512 [obj [object!] facet [word!] field [word!] flag return: [logic!] 
            /local blk
        ] f_ctx||490~add-bounds #[object! [
            proto: #[none]
            spec: #[none]
        ]] ctx||513 [proto [object!] spec [block!]] f_ctx||490~fetch-value #[object! [
            blk: #[none]
            local: #[none]
            value: #[none]
        ]] ctx||514 [blk 
            /local value
        ] f_ctx||490~fetch-argument #[object! [
            expected: #[none]
            pos: #[none]
            local: #[none]
            spec: #[none]
            type: #[none]
            value: #[none]
        ]] ctx||515 [expected [datatype! typeset!] 'pos [word!] 
            /local spec type value
        ] f_ctx||490~fetch-expr #[object! [
            code: #[none]
        ]] ctx||516 [code [word!]] f_ctx||490~fetch-options #[object! [
            face: #[none]
            opts: #[none]
            style: #[none]
            spec: #[none]
            css: #[none]
            reactors: #[none]
            styling?: #[none]
            no-skip: #[none]
            tight: #[none]
            local: #[none]
            opt?: #[none]
            divides: #[none]
            calc-y?: #[none]
            do-with: #[none]
            scaling: #[none]
            obj-spec!: #[none]
            sel-spec!: #[none]
            rate!: #[none]
            color!: #[none]
            cursor!: #[none]
            value: #[none]
            match?: #[none]
            drag-on: #[none]
            default: #[none]
            hint: #[none]
            cursor: #[none]
            tight?: #[none]
            later?: #[none]
            max-sz: #[none]
            p: #[none]
            words: #[none]
            user-size?: #[none]
            oi: #[none]
            x: #[none]
            font: #[none]
            face-font: #[none]
            field: #[none]
            actors: #[none]
            name: #[none]
            f: #[none]
            s: #[none]
            b: #[none]
            pad: #[none]
            sz: #[none]
            min-sz: #[none]
            new: #[none]
            mar: #[none]
        ]] ctx||517 [
            face [object!] opts [object!] style [block!] spec [block!] css [block!] reactors [block!] styling? [logic!] 
            /no-skip 
            /tight 
            return: [block!] 
            /local opt? divides calc-y? do-with scaling obj-spec! sel-spec! rate! color! cursor! value match? drag-on default hint cursor tight? later? max-sz p words user-size? oi x font face-font field actors name f s b pad sz min-sz new mar
        ] f_ctx||490~make-actor #[object! [
            obj: #[none]
            name: #[none]
            body: #[none]
            spec: #[none]
        ]] ctx||518 [obj [object!] name [word!] body spec [block!]] f_layout #[object! [
            spec: #[none]
            tight: #[none]
            options: #[none]
            user-opts: #[none]
            flags: #[none]
            flgs: #[none]
            only: #[none]
            parent: #[none]
            panel: #[none]
            divides: #[none]
            styles: #[none]
            css: #[none]
            local: #[none]
            axis: #[none]
            anti: #[none]
            background!: #[none]
            list: #[none]
            reactors: #[none]
            local-styles: #[none]
            pane-size: #[none]
            direction: #[none]
            align: #[none]
            begin: #[none]
            size: #[none]
            max-sz: #[none]
            current: #[none]
            global?: #[none]
            below?: #[none]
            origin: #[none]
            spacing: #[none]
            top-left: #[none]
            bound: #[none]
            cursor: #[none]
            opts: #[none]
            opt-words: #[none]
            re-align: #[none]
            sz: #[none]
            words: #[none]
            reset: #[none]
            focal-face: #[none]
            svmp: #[none]
            pad: #[none]
            value: #[none]
            anti2: #[none]
            at-offset: #[none]
            later?: #[none]
            name: #[none]
            styling?: #[none]
            style: #[none]
            styled?: #[none]
            st: #[none]
            actors: #[none]
            face: #[none]
            h: #[none]
            pos: #[none]
            styled: #[none]
            w: #[none]
            blk: #[none]
            vid-align: #[none]
            prev: #[none]
            mar: #[none]
            divide?: #[none]
            index: #[none]
            dir: #[none]
            pad2: #[none]
            image: #[none]
        ]] ctx||519 [
            [no-trace] 
            {Return a face with a pane built from a VID description} 
            spec [block!] "Dialect block of styles, attributes, and layouts" 
            /tight "Zero offset and origin" 
            /options 
            user-opts [block!] "Optional features in [name: value] format" 
            /flags 
            flgs [block! word!] "One or more window flags" 
            /only "Returns only the pane block" 
            /parent 
            panel [object!] 
            divides [integer! none!] 
            /styles "Use an existing styles list" 
            css [block!] "Styles list" 
            /local axis anti 
            background! list reactors local-styles pane-size direction align begin size max-sz current global? below? origin spacing top-left bound cursor opts opt-words re-align sz words reset focal-face svmp pad value anti2 at-offset later? name styling? style styled? st actors face h pos styled w blk vid-align prev mar divide? index dir pad2 image
        ] f_do-events #[object! [
            no-wait: #[none]
            local: #[none]
            result: #[none]
            screen: #[none]
            win: #[none]
        ]] ctx||520 [
            /no-wait 
            return: [logic! word!] 
            /local result screen win
        ] f_stop-events #[object! [
        ]] ctx||521 [] f_do-safe #[object! [
            code: #[none]
            local: #[none]
            result: #[none]
            error: #[none]
        ]] ctx||522 [code [block!] /local result error] f_do-actor #[object! [
            face: #[none]
            event: #[none]
            type: #[none]
            local: #[none]
            result: #[none]
            act: #[none]
            name: #[none]
        ]] ctx||523 [face [object!] event [event! none!] type [word!] /local result 
            act name
        ] f_show #[object! [
            face: #[none]
            with: #[none]
            parent: #[none]
            force: #[none]
            local: #[none]
            show?: #[none]
            f: #[none]
            pending: #[none]
            owner: #[none]
            word: #[none]
            target: #[none]
            action: #[none]
            new: #[none]
            index: #[none]
            part: #[none]
            state: #[none]
            handle: #[none]
            new?: #[none]
            p: #[none]
            field: #[none]
            pane: #[none]
        ]] ctx||524 [
            face [block! object!] 
            /with 
            parent [object!] 
            /force 
            return: [logic!] 
            /local show? f pending owner word target action new index part state handle new? p field pane
        ] f_unview #[object! [
            all: #[none]
            only: #[none]
            face: #[none]
            local: #[none]
            all?: #[none]
            svs: #[none]
            pane: #[none]
        ]] ctx||525 [
            /all 
            /only 
            face [object!] 
            /local all? svs pane
        ] f_view #[object! [
            spec: #[none]
            tight: #[none]
            options: #[none]
            opts: #[none]
            flags: #[none]
            flgs: #[none]
            no-wait: #[none]
            no-sync: #[none]
            local: #[none]
            sync?: #[none]
            result: #[none]
        ]] ctx||526 [
            spec [block! object!] 
            /tight 
            /options 
            opts [block!] 
            /flags 
            flgs [block! word!] 
            /no-wait 
            /no-sync 
            /local sync? result
        ] f_center-face #[object! [
            face: #[none]
            x: #[none]
            y: #[none]
            with: #[none]
            parent: #[none]
            local: #[none]
            pos: #[none]
        ]] ctx||527 [
            face [object!] 
            /x 
            /y 
            /with 
            parent [object!] 
            return: [object!] 
            /local pos
        ] f_make-face #[object! [
            style: #[none]
            spec: #[none]
            blk: #[none]
            offset: #[none]
            xy: #[none]
            size: #[none]
            wh: #[none]
            local: #[none]
            svv: #[none]
            face: #[none]
            styles: #[none]
            model: #[none]
            opts: #[none]
            css: #[none]
        ]] ctx||528 [
            style [word!] 
            /spec 
            blk [block!] 
            /offset 
            xy [pair!] 
            /size 
            wh [pair!] 
            /local 
            svv face styles model opts css
        ] f_dump-face #[object! [
            face: #[none]
            local: #[none]
            depth: #[none]
            f: #[none]
        ]] ctx||529 [
            face [object!] 
            /local depth f
        ] f_do-no-sync #[object! [
            code: #[none]
            local: #[none]
            r: #[none]
            e: #[none]
            old: #[none]
        ]] ctx||530 [
            code [block!] 
            /local r e old
        ] f_get-scroller #[object! [
            face: #[none]
            orientation: #[none]
        ]] ctx||531 [
            face [object!] 
            orientation [word!] 
            return: [object!]
        ] f_get-face-pane #[object! [
            face: #[none]
        ]] ctx||532 [
            face [object!] 
            return: [block! none!]
        ] f_get-focusable #[object! [
            faces: #[none]
            back: #[none]
            local: #[none]
            origin: #[none]
            checks: #[none]
            flags: #[none]
            f: #[none]
            pane: #[none]
            p: #[none]
        ]] ctx||533 [
            faces [block!] 
            /back 
            /local origin checks flags f pane p
        ] f_insert-event-func #[object! [
            name: #[none]
            fun: #[none]
            local: #[none]
            svh: #[none]
        ]] ctx||534 [
            name [word!] 
            fun [block! function!] 
            /local svh
        ] f_remove-event-func #[object! [
            id: #[none]
            local: #[none]
            svh: #[none]
            pos: #[none]
        ]] ctx||535 [
            id [function! word!] 
            /local svh pos
        ] f_request-font #[object! [
            font: #[none]
            ft: #[none]
            mono: #[none]
        ]] ctx||536 [
            /font 
            ft [object!] 
            /mono
        ] f_request-file #[object! [
            title: #[none]
            text: #[none]
            file: #[none]
            name: #[none]
            filter: #[none]
            list: #[none]
            save: #[none]
            multi: #[none]
        ]] ctx||537 [
            /title 
            text [string!] 
            /file 
            name [file! string!] 
            /filter 
            list [block!] 
            /save 
            /multi
        ] f_request-dir #[object! [
            title: #[none]
            text: #[none]
            dir: #[none]
            name: #[none]
            filter: #[none]
            list: #[none]
            keep: #[none]
            multi: #[none]
        ]] ctx||538 [
            /title 
            text [string!] 
            /dir 
            name [file! string!] 
            /filter 
            list [block!] 
            /keep 
            /multi
        ] f_set-focus #[object! [
            face: #[none]
            after: #[none]
            before: #[none]
            local: #[none]
            from: #[none]
            p: #[none]
        ]] ctx||539 [
            face [object!] 
            /after 
            /before 
            /local from p
        ] f_foreach-face #[object! [
            face: #[none]
            body: #[none]
            with: #[none]
            spec: #[none]
            post: #[none]
            sub: #[none]
            post?: #[none]
            local: #[none]
            exec: #[none]
        ]] ctx||540 [
            face [object!] 
            body [block! function!] 
            /with 
            spec [block! none!] 
            /post 
            /sub post? 
            /local exec
        ] f_alert #[object! [
            msg: #[none]
        ]] ctx||541 [
            msg [block! string!]
        ] f_~anon542~ #[object! [
            face: #[none]
            event: #[none]
            local: #[none]
            drag-evt: #[none]
            type: #[none]
            flags: #[none]
            result: #[none]
            drag-info: #[none]
            done?: #[none]
            new: #[none]
            box: #[none]
        ]] ctx||543 [face event 
            /local drag-evt type flags result drag-info done? new box
        ] f_~anon544~ #[object! [
            face: #[none]
            event: #[none]
            local: #[none]
            flags: #[none]
            faces: #[none]
            back?: #[none]
            pane: #[none]
            new: #[none]
            opt: #[none]
        ]] ctx||545 [face event 
            /local flags faces back? pane new opt
        ] f_ctx||546~encode #[object! [
            data: #[none]
            where: #[none]
        ]] ctx||551 [data [any-type!] where [file! none! url!]] f_ctx||546~decode #[object! [
            text: #[none]
        ]] ctx||552 [text [binary! file! string!]] f_ctx||553~to-csv-line #[object! [
            data: #[none]
            delimiter: #[none]
        ]] ctx||555 [
            data [block!] 
            delimiter [char! string!]
        ] f_ctx||553~escape-value #[object! [
            value: #[none]
            delimiter: #[none]
            local: #[none]
            quot?: #[none]
            len: #[none]
        ]] ctx||556 [
            value [any-type!] 
            delimiter [char! string!] 
            /local quot? len
        ] f_ctx||553~next-column-name #[object! [
            name: #[none]
            local: #[none]
            length: #[none]
            index: #[none]
            position: #[none]
            previous: #[none]
        ]] ctx||557 [
            name [char! string!] 
            /local length index position previous
        ] f_ctx||553~make-header #[object! [
            length: #[none]
            local: #[none]
            key: #[none]
        ]] ctx||558 [
            length [integer!] 
            /local key
        ] f_ctx||553~get-columns #[object! [
            data: #[none]
            local: #[none]
            columns: #[none]
        ]] ctx||559 [
            data [block!] 
            /local columns
        ] f_ctx||553~encode-map #[object! [
            data: #[none]
            delimiter: #[none]
            local: #[none]
            output: #[none]
            keys: #[none]
            length: #[none]
            key: #[none]
            index: #[none]
            line: #[none]
        ]] ctx||560 [
            data [map!] 
            delimiter [char! string!] 
            /local output keys length key index line
        ] f_ctx||553~encode-maps #[object! [
            data: #[none]
            delimiter: #[none]
            local: #[none]
            columns: #[none]
            value: #[none]
            line: #[none]
            column: #[none]
        ]] ctx||561 [
            data [block!] 
            delimiter [char! string!] 
            /local columns value line column
        ] f_ctx||553~encode-flat #[object! [
            data: #[none]
            delimiter: #[none]
            size: #[none]
        ]] ctx||562 [
            data [block!] 
            delimiter [char! string!] 
            size [integer!]
        ] f_ctx||553~encode-blocks #[object! [
            data: #[none]
            delimiter: #[none]
            local: #[none]
            length: #[none]
            line: #[none]
            csv-line: #[none]
        ]] ctx||563 [
            data [block!] 
            delimiter [char! string!] 
            /local length line csv-line
        ] f_load-csv #[object! [
            data: #[none]
            with: #[none]
            delimiter: #[none]
            header: #[none]
            as-columns: #[none]
            as-records: #[none]
            flat: #[none]
            trim: #[none]
            quote: #[none]
            qt-char: #[none]
            local: #[none]
            disallowed: #[none]
            refs: #[none]
            output: #[none]
            out-map: #[none]
            longest: #[none]
            line: #[none]
            value: #[none]
            record: #[none]
            newline: #[none]
            quotchars: #[none]
            valchars: #[none]
            quoted-value: #[none]
            char: #[none]
            normal-value: #[none]
            s: #[none]
            e: #[none]
            single-value: #[none]
            values: #[none]
            add-value: #[none]
            add-line: #[none]
            length: #[none]
            index: #[none]
            line-rule: #[none]
            init: #[none]
            parsed?: #[none]
            mark: #[none]
            key-index: #[none]
            key: #[none]
        ]] ctx||564 [
            data [string!] 
            /with 
            delimiter [char! string!] 
            /header 
            /as-columns 
            /as-records 
            /flat 
            /trim 
            /quote 
            qt-char [char!] 
            /local disallowed refs output out-map longest line value record newline quotchars valchars quoted-value char normal-value s e single-value values add-value add-line length index line-rule init parsed? mark key-index key
        ] f_to-csv #[object! [
            data: #[none]
            with: #[none]
            delimiter: #[none]
            skip: #[none]
            size: #[none]
            quote: #[none]
            qt-char: #[none]
            local: #[none]
            longest: #[none]
            keyval?: #[none]
            types: #[none]
            value: #[none]
        ]] ctx||565 [
            data [block! map! object!] 
            /with 
            delimiter [char! string!] 
            /skip 
            size [integer!] 
            /quote 
            qt-char [char!] 
            /local longest keyval? types value
        ] f_ctx||566~push #[object! [
            val: #[none]
        ]] ctx||568 [val] f_ctx||566~pop #[object! [
        ]] ctx||569 [] f_ctx||566~emit #[object! [
            value: #[none]
        ]] ctx||570 [value] f_load-json #[object! [
            input: #[none]
        ]] ctx||571 [
            input [string!]
        ] f_ctx||572~init-state #[object! [
            ind: #[none]
            ascii?: #[none]
        ]] ctx||574 [ind ascii?] f_ctx||572~emit-indent #[object! [
            output: #[none]
            level: #[none]
        ]] ctx||575 [output level] f_ctx||572~emit-key-value #[object! [
            output: #[none]
            sep: #[none]
            map: #[none]
            key: #[none]
            local: #[none]
            value: #[none]
        ]] ctx||576 [output sep map key 
            /local value
        ] f_ctx||572~red-to-json-value #[object! [
            output: #[none]
            value: #[none]
            local: #[none]
            special-char: #[none]
            mark1: #[none]
            mark2: #[none]
            escape: #[none]
            int: #[none]
            hi: #[none]
            lo: #[none]
            v: #[none]
            keys: #[none]
            k: #[none]
        ]] ctx||577 [output value 
            /local special-char mark1 mark2 escape int hi lo v keys k
        ] f_to-json #[object! [
            data: #[none]
            pretty: #[none]
            indent: #[none]
            ascii: #[none]
            local: #[none]
            result: #[none]
        ]] ctx||578 [
            data 
            /pretty indent [string!] 
            /ascii 
            /local result
        ] f_ctx||579~encode #[object! [
            data: #[none]
            where: #[none]
        ]] ctx||582 [data [any-type!] where [file! none! url!]] f_ctx||579~decode #[object! [
            text: #[none]
        ]] ctx||583 [text [binary! file! string!]] f_keep #[object! [
            v: #[none]
            only: #[none]
        ]] ctx||605 [v /only]
    ]]