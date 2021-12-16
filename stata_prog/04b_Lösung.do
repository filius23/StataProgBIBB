

foreach v of varlist *wib* {
	
	d `v'
}

*

 * F100_wib1 F1401_wib1 F100_wib2 F1401_wib2 F100_wib3 F1401_wib3 F1609_wib1 F1610_wib1 F1609_wib2 F1610_wib2 F1609_wib3 F1610_wib3


foreach v of varlist  {
	local longlabel: var label `v'
	local shortlabel = substr("`longlabel'",1,15)
	label var `v' "`shortlabel'"
}
