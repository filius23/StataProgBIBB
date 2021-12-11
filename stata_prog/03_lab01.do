clear all
qui use "${data}/BIBBBAuA_2018_suf1.0.dta", clear
quietly{
		mvdecode zpalter, mv(9999)
		mvdecode F518_SUF, mv( 99998/ 99999)
		mvdecode F200, mv( 97/99)
		mvdecode m1202, mv(-1)
}


mat G2 = J(4,5,.) // leere Matrix 
mat l G2
mat colname G2 = m1202 p25 mean median p75 
mat l G2

foreach lvl  of global ausb {
	qui su zpalter if m1202 == `lvl', det
	mat GX = `lvl', r(p25), r(mean), r(p50), r(p75) 
	mat G2[`lvl',1] = GX
}
mat l G2


* ------------------------------------------- *
* Extended macro functions für Variablen und Labels

loc v m1202
local vartype:     type `v' 		  // Variablen "storage type" (byte etc)
local varlab:      variable label `v' // variable label
local vallabname:  value label `v' 	  // Name des value label
local vallab1 :    label (`v') 1	// Value label für Wert = 1

di "`vartype'"     
di "`varlab'"      
di "`vallabname'"  
di "`vallab1'"     


* direkt anzeigen:
loc v m1202
di "`: type `v''" 			 // "storage type" (byte etc) der Variable
di "`: variable label `v''"  // variable label
di "`: value label `v''" 	 // Name des value label
di "`: label (`v') 1'" 		 // Value label für Wert = 1


* ------------------------------------------- *
* Zeilennamen aus Labels 

loc lvl = 1
qui su zpalter if m1202 == `lvl', det
mat GX = `lvl', r(p25), r(mean), r(p50), r(p75) 
local vallab1 :    label (m1202) `lvl'
mat rowname GX =  "`vallab1'"
mat l GX



* eigentliche Sammlung
mat G2 = J(4,5,.) // leere Matrix 
mat l G2
mat colname G2 = m1202 p25 mean median p75 
mat l G2

foreach lvl  of global ausb {
	qui su zpalter if m1202 == `lvl', det
	mat GX`lvl' = `lvl', r(p25), r(mean), r(p50), r(p75) 
	mat colname GX`lvl' = m1202 p25 mean median p75 
	
	local vallab1 :    label (m1202) `lvl'
	mat rowname GX`lvl' =  "`vallab1'"
}
mat G = GX1\GX2\GX3\GX4
mat l G


xsvmat G, collabels(coef) names(col) fast rownames(lab)
list, noobs clean

help xsvmat

global M_per 6 12 24 36 72 120
local max1 = max(`: subinstr global M_per " " ", ", all')
mac l _max1

local a `"first`=char(34)'second"'
display "`a'"
display `"`a'"'

