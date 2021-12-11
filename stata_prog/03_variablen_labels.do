* ------------------------------- *
* Labels







* --> val label loop.do


* ------------------------------- *
foreach v in lm0? {

    *capture confirm numeric variable `v'
    *if !_rc {

    *label dir
    *labelbook `r(names)'
	labelbook `: value label `v''
    *}

}


return list
dis `r(notused)'


* ------------------------------- *
* Variableneigenschaften

* 1. Access attributes of variable v

loc v m1202

local vartype: type `v' 				// get variable storage type
local varlab: variable label `v' 		// get variable label
local vallabname : value label `v' 		// get value label name
local vallab1 : label (`v') 1		 	// get label for value of 1

* 2. Display 'captured' attribute of pcode
di "`vartype'" // display local "vartype"
di "`varlab'" // display local "varlabel"
di "`vallabname'" // display local "valuelabname"
di "`vallab1'" // display local "valuelab1"

/*
	global vartype: type `v' 				// get variable storage type
	global varlab : variable label `v' 		// get variable label
	global valuelabname : value label `v' 	// get value label name
	global valuelab1 : label (`v') 1		 	// get label for value of 1

	global v_glo:  all globals "va*"
	mac l v_glo
*/


loc v m1202
* 3. Access and display attributes of `v' in one step
di "`: type `v''" 				// display variable storage type
di "`: variable label `v''" 	// display variable label
di "`: value label `v''" 		// display value label name
di "`: label (`v') 1'" 		// display label for value of 1
di "`: format `v''" 				// display variable format

loc v m1202
 	
	
	
	
	
       type 			varname
       format 			varname
       value label 		varname
       variable label 	varname
       data label
       sortedby
       label { valuelabelname | (varname) } { maxlength | # [#_2] } [, strict ]
       constraint { dir | # }
       char { varname[] | varname[charname] }
       char { _dta[] | _dta[charname] }
	   
	   
	   
	   Basic-Stata-Programming.pdf
	   
* ------------------------------- *
** existiert eine Variable?
capture confirm  variable lm02
if !_rc dis "ja"
if _rc 	dis	"nein"

** ist variable numerisch?
capture confirm numeric variable lm02
if !_rc dis "ja"
if _rc 	dis	"nein"

**ist sie 

str18 

foreach i of varlist sin3* {
	local longlabel: var label `i'
	local shortlabel = substr("`longlabel'",1,12)
	label var `i' "`shortlabel'"
}


* ------------------------------- *
* Variablen nach Wert durchsuchen
loc v m1202
count if `v' == -1
if r(N) > 0 qui glo var1: display "${var1} `v'"

qui ds
local varlist1 `r(varlist)'
glo var1 ""
foreach v of local varlist1 {
  qui count if `v' == -1
  *display "`v'"
  if r(N) > 0 {
      qui glo var1: display "${var1} `v'"
  }
}
mac l var1

return list



glo var4 ""
glo var1 ""
glo var4: display "${var4} "`v'



* globals durchsuchen:
* wildcards -> ? ersetzt ein Zeichen, * mehrere oder keines

glo x1 = 2
glo x2 "das ist x2"
glo x 291
global allglo:  all globals "x*"
mac l allglo

global allglo2:  all globals "x?"
mac l allglo2 allglo




