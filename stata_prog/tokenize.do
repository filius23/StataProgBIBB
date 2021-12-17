
tokenize 0 2 4 6 8 10 // store elements of list in sequential locals
forvalues i = 1(1)6 { // for each value of `i' = [1,6]
di ``i'' // display the `i'th positional local
} // repeat/end loop


dis "${S_FN}"

tokenize "Satz,weiter gehts", parse(",")
di "1=|`1'|, 2=|`2'|, 3=|`3'|"


tokenize "D:\oCloud\Home-Cloud\Lehre\BIBB\StataBIBB3/data/BIBBBAuA_2018_suf1.0_clean.dta", parse("\")
di "1=|`1'|, 2=|`2'|, 3=|`3'|"


tokenize ${S_FN}, parse("\")


di "1=|`1'|, 2=|`2'|, 3=|`3'|"




glo x = 4
loc x = 3

glo y = _x*4


glo t1 "Hallo"
glo t2 " zusammen"
glo t3 "! :-)"
glo t4: display "${t1}, ${t2}${t3}"

dis "${t4}"
mac list t1 t2 t3 t4



reg F518_SUF zpalter
glo xx: all globals "_e"
