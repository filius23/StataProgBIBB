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

use "${pfad}/BIBBBAuA_2018_suf1.0.dta", clear // laden des Datensatzes 


* voreingestellte Macros
dis "$S_DATE $S_TIME"











loc t1 = "erster Text"
loc t2 	 "zweiter Text"
mac l _t1 _t2
local i = 1
local ++i
dis `i'

* macro kann auch ein Programm sein 
loc t tab
`t' S1

// daher werden locals auch befehl verstanden -> wenn wir das um gehen wollen, dann müssen wir sie in Anführungszeichen setzen
loc t tab
dis `t'
loc t tab
dis "`t'"




local n 200
su F`n'


loc a: all globals "x*"
mac l _a


global allglo:  all globals ["x"]
mac l 

allglo


help unab
unab rhsvars : "mean"
mac l
mac list mean_age
mac list mean_*
mac list
macro list meanx
unab myvars : *
unab TX : *TX*
unab twenty : *200
help mac list



* {local | global} macname :  all {globals|scalars|matrices} ["pattern"]

* wild cards
* inlist / inrange
* capture


* ------------------------------- *
* Schleifen basics
* numlist
foreach n of numlist 8/10 15 to 30 32 to 36 {
    dis "`n'"
}
foreach n of numlist 8 6 : -8  {
    dis "`n'"
}

* Die foreach-Schleife mit einer Nummernliste funktioniert nicht mit einer beliebig hohen Anzahl von Ziffern. 
* In der forvalues-Schleife gibt es diese Einschränkung nicht. Zudem ist die forvalues-Schleife schneller im Abarbeiten von Nummernlisten.

forvalues nm =  8 6 : -8  {
    dis "`nm'"
}


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



* ------------------------------- *
* Labels
* --> val label loop.do

* ------------------------------- *
* DoFiles mit Parametern/Argumenten starten



* ------------------------------- *
* set trace on