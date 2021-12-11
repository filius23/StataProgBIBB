clear all
qui use "${data}/BIBBBAuA_2018_suf1.0.dta", clear
quietly{
		mvdecode zpalter, mv(9999)
		mvdecode F518_SUF, mv( 99998/ 99999)
		mvdecode F200, mv( 97/99)
		mvdecode m1202, mv(-1)
}

levelsof m1202, loc(ausb)
glo ausb `ausb'
mac l ausb

glo rwn = ""
foreach lvl  of global ausb {
	qui su zpalter if m1202 == `lvl', det
	mat GX = `lvl', r(p25), r(mean), r(p50), r(p75) 
	
	local vallab1 :    label (m1202) `lvl'
	glo val1 "`vallab1'"
	glo rwn ${rwn} "${val1}"
	
	mat G2[`lvl',1] = GX	
}
mat l G2
mac l rwn

loc lvl = 1
	local vallab1 :    label (m1202) `lvl'
	local vallabs `"  "`vallab1'" "'
	dis `vallabs'

foreach lvl  of global ausb {
	local vallab1 :    label (m1202) `lvl'
	local vallabs `"  "`vallab1'" "'
	glo val1 ${val1} `vallabs'
}

mac l val1

mat l G2
mat rowname G2 = "${val1}"




foreach lvl  of global ausb {
	qui su zpalter if m1202 == `lvl', det
	mat GX`lvl' = `lvl', r(p25), r(mean), r(p50), r(p75) 
	mat colname GX`lvl' = m1202 p25 mean median p75 
	
	local vallab1 :    label (m1202) `lvl'
	mat rowname GX`lvl' =  "`vallab1'"
	if "`ferest()'" == "" {
			mat G = J(1,5,.)
			mat G = m1202 p25 mean median p75 
		forvalues 1/`lvl'{
				mat G = G\GX`lvl'
		}
	}
}
mat l G

dis max(${ausb})
