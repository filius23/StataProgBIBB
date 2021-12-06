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





* ------------------------------- *
* Dateien 

help frame
frame put if S1 == 2, into(women)
frame put if S1 == 1, into(men)

frame dir

frame change men 
reg F518_SUF zpalter i.m1202
est store mx

frame change women 
reg F518_SUF zpalter i.m1202
est store wx

frame change default

est dir

frame 


* ------------------------------- *
* Labels
* --> val label loop.do

* ------------------------------- *
* matrix 
* regression und dann coefficient extrahieren und speichern

