clear all
cd "D:\Datenspeicher\BIBB_BAuA" // wo liegt der Datensatz?
use "BIBBBAuA_2018_suf1.0_Kopie.dta", clear
mvdecode zpalter, mv(9999)
mvdecode F518_SUF, mv( 99998/ 99999)
mvdecode F200, mv( 97/99)
mvdecode m1202, mv(-1)

	foreach i of varlist * {
	local longlabel: var label `i'
	local shortlabel = substr("`longlabel'",1,32)
	label var `i' "`shortlabel'"
}

	loc v m1202
		local lblname: value label `v'
		cap label drop `lblname'_n
		label copy `lblname' `lblname'_n
		levelsof `v', loc(x)
		foreach lvl of local x {
			local lab1: label (`v') `lvl'
			loc lab2 = substr("`lab1'",1,8)
			label define `lblname'_n `lvl' "`lab2'", modify
		}
		lab val `v' `lblname'_n
	tab m1202

saveold "BIBBBAuA_2018_suf1.0_clean.dta", replace ver(13)


use "D:\Datenspeicher\BIBB_BAuA/BIBBBAuA_2018_suf1.0_clean.dta", replace 

* -.--------------
dis  %20.2fc 8.5219e+09
dis  %20.2fc 1.9886e+11


local longlabel: val label M1202
dis `longlabel'



foreach v of varlist rep78 {
    local label8: label (`v') 8
    if `"`label8'"' == "Don't Know" {
        clonevar Dk_`v' = `v'
        replace Dk_`v' = -2 if Dk_`v' == 8
        local lblname: value label Dk_`v'
        label copy `lblname' Dk_`lblname'
        label values Dk_`v' Dk_`lblname'
        label define Dk_`lblname' -2 "don't know", modify
        label define Dk_`lblname' 8 "", modify
    }
}




foreach v of varlist * {
    local label8: label (`v') 8
    if `"`label8'"' == "Don't Know" {
        rename `v' Dk_`v'
        replace Dk_`v' = -2 if Dk_`v' == 8
        local lblname: value label Dk_`v'
        label define `lblname' -2 "don't know", modify
    }
}


	
	loc v m1202
    local label8: label (`v') 2
	dis "`v'"
	local lblname: value label `v'
	dis "`lblname'"
	
		
	lookfor Ä

qui label dir 
return list
loc labs: `r(names)'



	loc v m1202
		local lblname: value label `v'
		cap label drop `lblname'_n
		label copy `lblname' `lblname'_n
		levelsof `v', loc(x)
		foreach lvl of local x {
			local lab1: label (`v') `lvl'
			loc lab2 = substr("`lab1'",1,8)
			label define `lblname'_n `lvl' "`lab2'", modify
		}
		lab val `v' `lblname'_n
	tab m1202