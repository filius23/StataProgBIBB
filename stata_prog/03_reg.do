


* ------------------------ *
* in einen separaten Datensatz

clear all
qui use "${data}/BIBBBAuA_2018_suf1.0.dta", clear
quietly{
		mvdecode zpalter, mv(9999)
		mvdecode F518_SUF, mv( 99998/ 99999)
		mvdecode F200, mv( 97/99)
		mvdecode m1202, mv(-1)
}
reg F518_SUF F200
mat C = r(table)
mat C = C'

cap frame drop results
frame create results
frame results: xsvmat C, collabels(coef) names(col) fast
frame change results
browse


frame change default
mat l C


* -------------------------- *
* Koeffizient suchen

frame change default
cap frame drop results
local predictors i.S1 c.F200 c.F200#c.F200 i.m1202 zpalter c.zpalter#c.zpalter
local uv 
local r = 1
foreach v of local predictors {
    local uv `uv' `v'
	qui regress F518_SUF `uv', noheader
	if ("`uv'" == "i.S1") mat R = _b[2.S1] 
	if ("`uv'" != "i.S1") mat R = R\_b[2.S1]
	glo cmd`r' = 	"`e(cmdline)'"
	loc ++r
}
mat l R

global allglo:  all globals "cmd*"
mac l allglo
mac l cmd1


frame create results
frame results: xsvmat R, collabels(coef) names(col) fast rownames(coef)
frame change results
list

gen c0 = real(substr(coef,2,2))
list

scatter c0 c1



reg F518_SUF i.S1 c.F200 c.F200#c.F200

mat l e(b)
dis _b[2.S1]


* -------------------------- *
* mehrere Regressionsmodelle 

tokenize "`predictors'"
display "1=|`1'|, 2=|`2'| " _c " 3=|`3'|" 

tokenize some words

mat drop R
frame change default
cap frame drop results
local predictors i.S1 c.F200 c.F200#c.F200 i.m1202 zpalter c.zpalter#c.zpalter
local uv 
local r  = 1
foreach v of local predictors {
    local uv `uv' `v'
	qui regress F518_SUF `uv'
	mat C = r(table)
	mat C = C' 
	mat l C
	if ("`uv'" == "i.S1") mat R = C 
	if ("`uv'" != "i.S1") mat R = R\C
	glo g`r' "`e(cmdline)'"
	loc ++r
}
mat l R


cap frame drop results
frame create results
frame results: xsvmat R, collabels(coef) names(col) fast rownames(coef)
frame change results
list
gen mod = sum(coef == "2.S1")
list
keep if coef == "2.S1"
list
graph twoway (scatter mod b  ) (rcap ll ul mod,horizontal ) , ///
	ylabel(1 "${g1}" 2 "${g2}" 3 "${g3}" 4 "${g4}" 5 "${g5}" 6 "${g6}", angle(0) labsize(small))
	

	lab def mods 1 "${g1}" 2 "${g2}" 3 "${g3}" 4 "${g4}" 5 "${g5}" 6 "${g6}"
	lab val mod mods
	list
	

	 
mac l g1

	xlabel( 1 )
frame change default

dis	"`e(cmdline)'"



local predictors c.F200 c.F200#c.F200 i.m1202 zpalter c.zpalter#c.zpalter
local uv 
local r  = 1
foreach v of local predictors {
    local uv `uv' `v'
	qui regress F518_SUF `uv', noheader
	
	est store m`r'
	
	loc ++r
}


esttab m*,  keep(F200) nomtitle nonumber stats(N)


 ssc install frameappend
help frameappend



local predictors c.F200 c.F200#c.F200 i.m1202 zpalter c.zpalter#c.zpalter
local uv 
foreach v of local predictors {
    local uv `uv' `v'
	regress F518_SUF `uv', noheader
	mat C = r(table)
	mat C = C' 
	if ("`uv'" == "c.F200") mat R = C 
	if ("`uv'" != "c.F200") mat R = R\C
}

mat l R

















mat l C
frame create output str30(varname) b se ll ul pvalue
frame create results  b se t pvalue ll ul df crit eform
frame post results (C)

foreach v of local predictors {
    local uv `uv' `v'
	qui regress F518_SUF `uv'
		local or = r(table)[1,1]
		local lb = r(table)[5,1]
		local ub = r(table)[6,1]
		local p =  r(table)[4,1]

}

frame create output str30(varname) b

local cmd : di _dup(3) "`e(cmdline)'"
mac l _cmd

frames post res1 ("`e(cmd)'") (`b') 

dis "`e(cmdline)'"



(`lb') (`ub') (`p')


mat l C
