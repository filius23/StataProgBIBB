clear
set obs 10
gen x = ""
replace x = "The quick brown fox jumps over the lazy dog." in 1
replace x = "the sun is shining. The birds are singing." in 2
replace x = "  Pi equals 3.14159265" in 3
replace x = "TheRe arE 9 plANetS in THE solar SYstem.  eARth's mOOn is round" in 4
replace x = "I LOVE Stata 16 . " in 5
replace x = "Always correct the regressions for clustered standard errors." in 6
replace x = "I get an error code r(997.55). What do i do next?" in 7
replace x = "myname@coolmail.com, Tel: +43 444 5555" in 8
replace x = " othername@dmail.net, Tel: +1 800 1337. " in 9
replace x = "Firstname  Lastname  03-06-1990" in 10

list
gen t4 = ustrregexs(0) if ustrregexm(x, "^[t|T]he")

gen t5_0 = ustrregexs(0) if ustrregexm(x, "(.*\.)(.*\.)")  
gen t5_1 = ustrregexs(1) if ustrregexm(x, "(.*\.)(.*\.)")  
gen t5_2 = ustrregexs(2) if ustrregexm(x, "(.*\.)(.*\.)")

lis
