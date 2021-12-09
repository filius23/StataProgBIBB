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
* local sind _globals 
local   x = 2
global _x=1
dis "`x'"

glo x1 = 2
glo x2 "das ist x2"
glo x 291
global allglo:  all globals "_x*"
mac l allglo

