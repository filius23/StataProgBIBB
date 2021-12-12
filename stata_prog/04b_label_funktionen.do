* --------------------------------- *
* Programmieren mit Stata
* Kapitel 4b: Label-Funktionen
* --------------------------------- *

* einlesen
glo data  	"D:\Datenspeicher\BIBB_BAuA/"
glo graph 	"D:\oCloud\Home-Cloud\Lehre\BIBB\StataProgBIBB\graph"
use "${data}/BIBBBAuA_2018_suf1.0.dta", clear

mvdecode zpalter, mv(9999)
mvdecode F518_SUF, mv( 99998/ 99999)
mvdecode F200, mv( 97/99)
mvdecode m1202, mv(-1)



* -------------------------------- *
* Labelfunktionen 

loc v mod2
local vartype:     type `v' 				  // Variablen "storage type" (byte etc)
local varlab:      variable label `v' // variable label
local vallabname:  value label `v' 	  // Name des value label
local vallab1 :    label (`v') 1		 	// Value label für Wert = 1

* Die so erstellten `local`s können wir dann in der bekannten Methode wieder darstellen:
dis "`vartype'"     // display local "vartype"
dis "`varlab'"      // display local "varlabel"
dis "`vallabname'"  // display local "valuelabname"
dis "`vallab1'"     // display local "valuelab1"


* Wir können die Labels und Eigenschaften von `v' auch in einem Schritt anzeigen lassen, die Syntax sieht aber etwas eigenwillig aus:
loc v mod2
dis "`: type `v''" 				   // "storage type" (byte etc) der Variable
dis "`: variable label `v''"  // variable label
dis "`: value label `v''" 		 // Name des value label
dis "`: label (`v') 1'" 		   // Value label für Wert = 1



* ------------------------------- *
* Anwendungen

*Ein Label kürzen:
	local longlabel: var label m1201
	local shortlabel = substr("`longlabel'",1,10)
	label var m1202 "`shortlabel'"


* label copy & label (`v') `lvl'

local lblname: value label m1202
label copy `lblname' `lblname'_n



* ------------------------------- *
* Alle value labels bearbeiten

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

	
* ------------------------------- *
* Nach Variablen mit bestimmten Werten suchen
ds
local varlist1 `r(varlist)'
foreach v of local varlist1 {
  qui count if `v' == -9
  if r(N) > 0 display "`v'"
}


quietly ds
mac drop var4
local varlist1 `r(varlist)'
foreach v of local varlist1 {
  qui count if `v' == -9
  if r(N) > 0 glo var4 "${var4} `v'"
}
mac l var4
	
	
	
