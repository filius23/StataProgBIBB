clear all
glo pfad "D:\Datenspeicher\BIBB_BAuA" // wo liegt der Datensatz?
use "${pfad}/BIBBBAuA_2018_suf1.0.dta", clear
mvdecode zpalter, mv(9999)
mvdecode F518_SUF, mv( 99998/ 99999)
mvdecode F200, mv( 97/99)
mvdecode m1202, mv(-1)


* ------------------------------- *
* local / global


* global und locals definieren:
glo xg = 1
loc xl = 2

dis ${xg}
dis `xl'


glo x = 1
loc y = 2
mac list x
mac list _y

* geht, aber ist nicht zu empfehlen:
glo yx = 1
loc yx = 2
mac list yx
mac list _yx


* achtung bei Rechnungen:
local m1 2+2
local m2 = 2+2
display `m1'
display `m2'
mac list _m1 _m2


* macros für Dateipfade
glo pfad "D:\Datenspeicher\BIBB_BAuA" // wo liegt der Datensatz?
use "${pfad}/BIBBBAuA_2018_suf1.0.dta", clear


* mehrere Nutzer:
glo pfad "C:\Projekte\Micha" // wo liegt der Datensatz bei Alex?
glo pfad "D:\Arbeit\Alex"    // wo liegt der Datensatz bei Micha?

glo prog "${pfad}/prog"  
glo data "${pfad}/data"
glo log  "${pfad}/log"

use "${pfad}/BIBBBAuA_2018_suf1.0.dta", clear // laden des Datensatzes 


* voreingestellte Macros
dis "$S_DATE $S_TIME"

dis "Start: $S_DATE um $S_TIME"
sleep 6000 // 6 sekunden warten 
dis "Start: $S_DATE um $S_TIME"

dis "`c(username)'"
dis "`c(machine_type)'"
dis "`c(os)'"

* globals durchsuchen:
* wildcards -> ? ersetzt ein Zeichen, * mehrere oder keines

glo x1 = 2
glo x2 "das ist x2"
glo x 291
global allglo:  all globals "x*"
mac l allglo



* if
if ("`c(username)'" == "Filser") display "Du bist Filser"
if ("`c(username)'" != "Fischer") display "Du bist nicht Fischer"

* mehrere Nutzer:
if ("`c(username)'" == "Alex")   glo pfad "C:\Projekte\Micha" // wo liegt der Datensatz bei Alex?
if ("`c(username)'" == "Micha")  glo pfad "D:\Arbeit\Alex"    // wo liegt der Datensatz bei Micha?
if ("`c(username)'" == "Filser") glo pfad "D:\Datenspeicher\BIBB_BAuA"   
mac l pfad

glo prog "${pfad}/prog"  
glo data "${pfad}/data"
glo log  "${pfad}/log"

use "${pfad}/BIBBBAuA_2018_suf1.0.dta", clear // laden des Datensatzes 


* ------------------------------- *
* if & else 
loc n = 3
if `n'==1 {
	local word "one"
     }
else if `n'==2 {
	local word "two"
}
else if `n'==3 {
	local word "three"
}
else {
	local word "big"
}
display "`word'"


* angepasste Pfade mit if & else:
if "`c(username)'" == "Alex" {
  glo pfad "C:\Projekte\Micha" // wo liegt der Datensatz bei Alex?
	} 
else if "`c(username)'" == "Micha" {
  glo pfad "D:\Arbeit\Alex"    // wo liegt der Datensatz bei Micha?
}
else {
 display as error "Hier fehlt der passende Pfad"
 exit 
}
  
tab S1

* ------------------------------- *
* Schleifen basics
foreach n of numlist 1/3 6(1)9  {
    dis "`n'"
}

foreach n of numlist 6 4: -4  {
    dis "`n'"
}

loc i = 1
while `i' <= 5 {
  display "`i'"
  loc i = `i' + 1
}

loc i = 1
while `i' <= 5 {
  display "`i'"
  loc ++i
}

* ferest():
foreach n of numlist 1(1)5 {
    dis "`n'"
    dis "Es kommen noch: `ferest()'"
}

* ----------------------------------- *
* Anwendung

foreach v of numlist 19(5)35 {
	display "Alter bis `v'"
	tab S1 if zpalter <= `v'
}

foreach v of numlist 19(5)35 {
	display "Alter " `v' - 4 " bis " `v'
 	tab S1 if inrange(zpalter,`v'-4, `v')
	*su zpalter if inrange(zpalter,`v'-4, `v')
}

* ----------------------------------- *
* Schleifen aufbauen:
* Schleife 1-10 die anzeigt, ob `n' gerade oder ungerade ist

** Welche Fälle gibt es?
loc n = 4
if `n' == 2 display "ja"
if `n' != 2 display "nein"


loc n = 8
if trunc(`n'/2) == `n'/2 display "ja"
if trunc(`n'/2) != `n'/2 display "nein"

loc n = 5
dis mod(`n',2) //2, "Rest 1"
dis mod(`n',3) //1, "Rest 2"



forvalues n = 1/20 {
	if  mod(`n',2)  == 0 dis "`n' ist gerade"
	if  mod(`n',2)  != 0 dis "`n' ist ungerade"
}

forvalues n = 1/10 {
	if  mod(`n',2)  == 0 {
		dis "`n' ist gerade"
	}
	else if mod(`n',2)  == 1 {
		dis "`n' ist ungerade"
	} 
	else {
		display as error "hier ging was schief"
		exit 
	}
}


help mod

mod(x,y) = x - y*floor(x/y)


* wild cards
* inlist / inrange
* capture

* ------------------------------- *
glo x1 = 2
glo x2 "das ist x2"
glo x 291
global allglo:  all globals "_x*"
mac l allglo







* ------------------------------- *
* r() und e()

clear all
cd "D:\Datenspeicher\BIBB_BAuA" // wo liegt der Datensatz?
use "BIBBBAuA_2018_suf1.0.dta", clear

su zpalter 
return list // Scalars
* mit diesen können wir rechnen
* Variationskoeffizient:
dis r(mean)/r(Var)

* aus scalars können wir auch macros machen:
glo mean_age = r(mean)

macro list mean_age
tab zpalter if inrange(zpalter,${mean_age} - .5,${mean_age} + .5)
tab S1 if inrange(zpalter,${mean_age} - .5,${mean_age} + .5)


*! Achtung - die r() enthalten nur die Werte für die letzte Variable:
su zpalter F518_SUF
return list
dis r(mean)/r(Var)

foreach v1 of varlist zpalter F518_SUF {
    su `v1'
	glo mean_`v1' = r(mean)
}






mat x = 2,2
mat l x

reg  F518_SUF zpalter
return list
ereturn list
mat list r(table)
mat list e(b)

mat x2 = e(b), e(cmdline)
mat l x2

mat x3 =  e(cmdline)
mat l x3

mat x2b = e(b) \ e(V)
mat l x2b




	foreach i of varlist * {
	local longlabel: var label `i'
	local shortlabel = substr("`longlabel'",1,32)
	label var `i' "`shortlabel'"
}

* ------------------------------- *
* matrix 
* regression und dann coefficient extrahieren und speichern

mat dir
mat SR = SR1625\SR1630\SR1635\SR1640\SR1645
mat list SR
svmat SR, names(col)
mat Y = J(`r(nmodels)',3,.)
mat X = $x
mat Y[`i',1] = X
matrix SR = r(coefs)'			// store proper info: SRs 
					
mat colname Y = year region_res language	// assign column name to Y(from loop above)
mat SR = SR,Y					// c-bind SR and Y

*create matrix containing info about age bandwidth and c-bind it to SR
mat R1 = J(rowsof(SR),1,`up')	
mat R2 = J(rowsof(SR),1,`down')
mat R = R1, R2
mat colname R = up down
mat SR = SR, R



* ------------------------------- *
* Variableneigenschaften

       type varname
       format varname
       value label varname
       variable label varname
       data label
       sortedby
       label { valuelabelname | (varname) } { maxlength | # [#_2] } [, strict ]
       constraint { dir | # }
       char { varname[] | varname[charname] }
       char { _dta[] | _dta[charname] }


* ------------------------------- *
* frame: mehrere Datensätze
* frame https://www.stata.com/features/overview/multiple-datasets-in-memory/
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

frame dir

clear all
frame create results t p 
forvalues i=1(1)1000 {
           quietly set obs 100
           quietly generate x = rnormal()
           quietly ttest x=0
           frame post results (r(t)) (r(p))
           drop _all
   }

frame dir   
frame change results   
list
frame results: count if p<=0.05
  43




* ------------------------------- *
* Dateien
cd "W:/ASR/data/temp"
	global fileslist: dir . files "SR*.dta" //get list of all temporary data sets with SR info in temp folder
	dis "SR files:"			
	mac list fileslist						
	
	loc usefile `: word 1 of ${fileslist}' 	// extract first entry from data set list
	use `usefile', clear					// load data set that was first created (i.e. with the lowest w)
	dis "`usefile' opened"
	
	loc n_datasets : list sizeof global(fileslist)		//append the other temporary data sets
	foreach i of numlist 2(1)`n_datasets' {
		loc appendfile `: word `i' of ${fileslist}'		// extract name of i_th data set from list
		append using `appendfile'						// append it!
		dis "`appendfile' appended"						// show it worked
	}


* erase

/* pmacro hilfe
local list : dir . files "*" makes a list of all regular files in the current directory.  Inlistmight be returned"subjects.dta" "step1.do" "step2.do" "reest.ado".

local list : dir . files "s*", respectcasein  Windows  makes  a  list  of  all  regular  filesin  the  current  directory  that  begin  with  a  lowercase  “s”.  The  case  of  characters  in  the  filenamesis preserved.  In Windows, without therespectcaseoption, all filenames would be converted tolowercase before being compared withpatternand possibly returned

.local list : dir . dirs "*"makes a list of all subdirectories of the current directory.  Inlistmight be returned"notes" "subpanel"

.local list : dir . other "*"makes  a  list  of  all  things  that  are  neither  regular  files  nordirectories.  These files rarely occur and might be, for instance, Unix device drivers

.local list : dir "\mydir\data" files "*"makes  a  list  of  all  regular  files  that  are  to  befound in\mydir\data.  Returned might be"example.dta" "make.do" "analyze.do".It is the names of the files that are returned, not their full path names

.local list : dir "subdir" files "*"makes a list of all regular files that are to be found insubdirof the current directory
*/

* ------------------------------- *
* Labels
* --> val label loop.do

* ------------------------------- *
* DoFiles mit Parametern/Argumenten starten



* ------------------------------- *
* set trace on