* --------------------------------- *
* Programmieren mit Stata
* Kapitel 2
* --------------------------------- *


* einlesen
use "${data}/BIBBBAuA_2018_suf1.0_clean.dta", clear

* --------------------------------- *
* levelsof: Schleife automatisch erstellen
tab m1202
levelsof m1202
levelsof m1202, loc(ausb)
foreach lvl  of local ausb {
	dis "m1202: " `lvl'
}

levelsof m1202, loc(ausb)
glo ausb `ausb'
mac l ausb

foreach lvl  of global ausb {
	dis "m1202: " `lvl'
}


foreach lvl  of global ausb {
	dis "m1202: " `lvl'
	tab S1 if m1202 == `lvl'
}


* --------------------------------- *
* return & ereturn
tab S1
return list
su S1
return list

reg F518_SUF zpalter
ereturn list

* e() und r() sind getrennte Welten
reg az F200
su az
ereturn list



su S1
dis "Der Mittelwert beträgt: " r(mean)
dis "Der Mittelwert beträgt: " round(r(mean),.01)


gen S01 = S1-1
foreach lvl  of global ausb {
	qui su S01 if m1202 == `lvl'
	dis "Der Frauenanteil in m1202=" `lvl' " beträgt: " round(r(mean)*100,.1) "%"
}

* rekursive Verwendung von globals
global x ""
forvalues i = 1/20 {
	global x $x `i'
}
mac list x


glo gend ""
foreach lvl  of global ausb {
	qui su S01 if m1202 == `lvl'
	glo gend: display "${gend}m1202=" `lvl' " " round(r(mean)*100,.1) "% "
}
mac l gend


* --------------------------------- *
* Ergebnisse speichern mit matrizen
matrix Y1 = 1, 3 
mat l Y1
matrix Y2 = 4\ 0
mat l Y2

matrix X2 = (1, 2, 3 \ 5 , 8 , 9)
mat l X2 
mat X3 = X2'
mat l X3

mat G0 = J(4,2,0)
mat l G0

* colname
mat colname G0 = var1 var2
mat list G0

* rowname
mat rowname G0 = year result
mat list G0

* --------------------------------- *
* ergebnisse in einer matrix sammeln
levelsof m1202, loc(ausb)
foreach lvl  of local ausb {
	qui su S01 if m1202 == `lvl'
	
	// 1. Spalte level von m1202
	//2.Spalte: Frauenanteil
	mat G`lvl' = `lvl' ,r(mean)*100 
}
mat G = GX1\GX2\GX3\GX4
mat colname G = m1202 share_w
mat l G

* --------------------------------- *
* mehrere Werte
clear matrix
mat dir

foreach lvl  of global ausb {
	qui su zpalter if m1202 == `lvl', det
	mat A`lvl' = `lvl', r(p25), r(mean), r(p50), r(p75)
}
mat A2 = A1\A2\A3\A4
mat colname A2 = m1202 p25 mean median p75
mat l A2

* ----------------------------------------------- *
* Labels behalten  
loc v m1202
local vallab1 :    label (`v') 1		 	// Value label für Wert = 1
dis "`vallab1'"     // display local "valuelab1"

mat M = c(2\"label") // Fehler: nur Zahlen in matrix ablegbar

loc lvl = 1
qui su zpalter if m1202 == `lvl', det
mat GX = `lvl', r(p25), r(mean), r(p50), r(p75)
local vallab1 :    label (m1202) `lvl' // label aufrufen
mat rowname GX =  "`vallab1'" // in Zeilenname ablegen
mat l GX

* rowname um labels zu speichern
levelsof m1202, loc(ausb)
foreach lvl  of local ausb {
	qui su zpalter if m1202 == `lvl', det
	mat GX`lvl' = `lvl', r(p25), r(mean), r(p50), r(p75)
	
	local vallab1 :    label (m1202) `lvl'
	mat rowname GX`lvl' =  "`vallab1'"
}
mat G = GX1\GX2\GX3\GX4
mat colname GX = m1202 p25 mean median p75
mat l G

* -------------------------------- *
* matrix zu Datensatz
ssc install  xsvmat

* frame 
frame dir
frame change default
xsvmat G, names(col) rownames(lab) frame(res1) // erstellt frame res1
frame dir

frame change res1 // in den res1-frame
list , noobs clean

frame change default // wieder zurück


