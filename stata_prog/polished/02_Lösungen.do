* --------------------------------- *
* Programmieren mit Stata
* Kapitel 2
* Lösungen
* --------------------------------- *
* einlesen
use "${data}/BIBBBAuA_2018_suf1.0_clean.dta", clear

* ---------------------------------------------
* 1 Wörter in strings zählen

loc x1 "ein sehr langer satz mit vielen wörtern"
local lenx1: word count `x1'
mac list _lenx1
forvalues i = 1(1)`lenx1' {
    loc word: word `i' of `x1'
    dis "this is word number " `i' ": `word'"
}


loc x1 "ein sehr langer satz mit vielen wörtern"
local lenx1: word count `x1'
mac list _lenx1
forvalues i = 1(1)`lenx1' {
	loc y = `i' +1
    loc word: word `i' of `x1'
	loc word2: word `y' of `x1'
    dis "this is word number " `i' ": `word' & number " `y' ": `word2'"
}


ds *wib*
loc x2 =  r(varlist)
local lenx2: word count `x2'
mac list _lenx2
forvalues i = 1(1)`lenx2' {
    loc word: word `i' of `x2'
    dis "this is word number " `i' ": `word'"
}

foreach v of varlist *wib* {
    dis "Variable  `v'"
}


glo x1 erstes zweites drittes
glo x2 erstes zweites drittes

forvalues i = 1/3 {
	loc w1: word `i' of ${x1}
	loc w2: word `i' of ${x2}
    dis "x1 = `w1' & x2 = `w2'"
	
}


* ---------------------------------------------
* 2
* Erstellen Sie eine Schleife, welche jeweils das Maximaleinkommen (basierend auf `F518_SUF`) für die Gemeindegrößenklassen (`gkpol`) anzeigt.
  * Wie kommen Sie an den Maximalwert für `F518_SUF`? Verwenden Sie bspw. `su` oder `tabstat` zusammen mit `return list`.
  su F518_SUF
  return list
  * Erstellen Sie mit `display` eine aussagekräftige Ausgabe
 dis "Das Maximale Einkommen beträgt: " round(r(max),.01)
 
  * Testen Sie Ihre Schleifenlogik mit einem `local`, um anschließend die Schleife "außen herumzubauen"
  loc lvl  = 3
  su F518_SUF if gkpol == `lvl'
  dis "Das Maximale Einkommen in gkpol=" `lvl' " beträgt: " round(r(max),.01)
  
  * Welche Ausprägungen hat `gkpol` - wie können Sie diese automatisch in eine Schleife überführen?
use "${data}/BIBBBAuA_2018_suf1.0_clean.dta", clear
     
levelsof gkpol, loc(gk)
foreach lvl  of local gk {
    dis "gkpol: " `lvl'
    qui su F518_SUF if gkpol == `lvl'
    dis "Das Maximale Einkommen in gkpol=" `lvl' " beträgt: " round(r(max),.01)
}

* *Optional* Passen Sie Ihre Schleife an, sodass für jeden Durchlauf ein `global gkX` erstellt wird, wobei `X` für die Ausprägung von `gkpol` steht und den entsprechenden Maximalwert von `F518_SUF` für die entsprechende Größenklasse enthält.

cap mac drop max
levelsof gkpol, loc(gk)
foreach lvl  of local gk {
    dis "gkpol: " `lvl'
    qui su F518_SUF if gkpol == `lvl'
	glo max: display "${max} gkpol=" `lvl' " " round(r(max)*100,.1) "EUR "
    }
mac l max


* ---------------------------------------------
* 3

su F518_SUF, detail
return list

levelsof gkpol, loc(gk)
foreach lvl  of local gk {
    dis "gkpol: " `lvl'
    qui su F518_SUF if gkpol == `lvl', detail
    mat GX`lvl' = `lvl', r(p25), r(mean), r(p50), r(p75) 
}
mat G = GX1\GX2\GX3\GX4\GX5\GX6\GX7
mat colname G = gkpol p25 mean median p75 
mat l G

* zusammenbinden in schleife
clear matrix
levelsof gkpol, loc(gk)
foreach lvl  of local gk {
    dis "gkpol: " `lvl'
    qui su F518_SUF if gkpol == `lvl', detail
    mat GX`lvl' = `lvl', r(p25), r(mean), r(p50), r(p75) 
	mat colname GX`lvl' = gkpol p25 mean median p75 
		
	if `lvl' == 1 mat G = GX1
	if `lvl' > 1  mat G = G\GX`lvl'
	mat drop GX`lvl'
}
mat l G
mat dir

* ---------------------------- *
* 4

levelsof gkpol, loc(gk)
foreach lvl  of local gk {
    dis "gkpol: " `lvl'
    qui su F518_SUF if gkpol == `lvl', detail
    mat GX`lvl' = `lvl', r(p25), r(mean), r(p50), r(p75) 
    
    local vallab1 :    label (gkpol) `lvl'
    mat rowname GX`lvl' =  "`vallab1'"
}
mat G = GX1\GX2\GX3\GX4\GX5\GX6\GX7
mat colname G`lvl' = gkpol p25 mean median p75 
mat l G

ssc install xsvmat
xsvmat G, names(col) frame(res2) rownames(lab)
frame change res2
list, noobs clean

frame change default






