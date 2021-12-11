* --------------------------------- *
* Programmieren mit Stata
* Kapitel 3: Regressionsergebnisse sammeln
* --------------------------------- *
clear all
macro drop _all 

* einlesen
glo data  	"D:\Datenspeicher\BIBB_BAuA/"
glo graph 	"D:\oCloud\Home-Cloud\Lehre\BIBB\StataProgBIBB\graph"
use "${data}/BIBBBAuA_2018_suf1.0.dta", clear

mvdecode zpalter, mv(9999)
mvdecode F518_SUF, mv( 99998/ 99999)
mvdecode F200, mv( 97/99)
mvdecode m1202, mv(-1)

* ------------------------------ *
* postestimates bei reg

* einfaches bivariates Modell
reg F518_SUF F200
ereturn list


mat l e(b) // koeffizienten
*schnellzugriff:
dis "Der Koeffizient für F200 ist " _b[F200]
dis "Der Standardfehler des Koeffizienten für F200 ist " _se[F200]


* vorhergesagte Werte
dis _b[_cons] + 20 *_b[F200]
margins, at(F200 = 20)

* für alle beobachtungen
gen pred_manual = _b[_cons] + F200 *_b[F200]
predict pred_auto, xb
gen diff=  pred_manual - pred_auto
su diff

* -------------------------- *
* vollständige Regressiontabelle
reg F518_SUF F200
mat l r(table) 

* abspeichern und transponieren
mat C = r(table)'
mat l C


* einfaches reg-Modell mit kat. UV
reg F518_SUF i.S1 F200
ereturn list
mat l r(table) // etwas komplizierterer Name bei kat. UVs
dis "Der Koeffizient für S1 = weiblich ist " _b[2.S1]

mat D = r(table)' // transponieren
mat l D

// nur ein Koeffizient
mat D2 = D[rownumb(D,"2.S1"),1...] // nur Koeffizient für S1 = 2
mat l D2

cap frame drop regres1
xsvmat D2,  names(col) rownames(coef) frame(regres1)
frame change regres1

list, noobs clean // keine Info zum Modell...

	frame change default
	frame drop regres1

	* infos zum Modell:
ereturn list
dis "`e(cmdline)'"

* -------------------------- *
* Mehrere Modelle

frame change default

local predictors i.S1 c.F200 c.F200#c.F200 i.m1202 zpalter c.zpalter#c.zpalter
local r = 1 // Zähler 
loc uv 		// uv rücksetzen (zur sicherheit)
foreach v of local predictors {
    local uv `uv' `v'
	qui regress F518_SUF `uv'
	mat D = r(table)'						// reg-tabelle transponieren & speichern 
	mat D2 = D[rownumb(D,"2.S1"),1...]		// Koeffizient für S1=2 behalten
	
	if (`r' == 1) mat R = D2 				// im ersten Durchlauf R erstellen
	if (`r' != 1) mat R = R\D2 				// danach: D2 an R anfügen
		
	loc ++r // Zähler + 1
}
mat l R // wie wissen wir jetzt, für was kontrolliert wurde?

// -> e(cmdline) mit aufzeichnen 
return list

local predictors i.S1 c.F200 c.F200#c.F200 i.m1202 zpalter c.zpalter#c.zpalter
local r = 1 // Zähler 
loc uv 		// uv rücksetzen (zur sicherheit)
foreach v of local predictors {
    local uv `uv' `v'
	qui regress F518_SUF `uv'
	mat D = r(table)'						// reg-tabelle transponieren & speichern 
	mat D2 = D[rownumb(D,"2.S1"),1...]		// Koeffizient für S1=2 behalten
	
	mat M = `r'
	mat colname M = mod
	
	if (`r' == 1) mat R = D2 , M			// ,r -> zähler an Koeffizientzeile anfügen
	if (`r' != 1) mat R = R\(D2 , M)
	glo cmd`r' = "`e(cmdline)'"
	loc ++r // Zähler + 1
}
mat l R 

cap frame drop rmods
xsvmat R,  names(col) rownames(coef) frame(rmods)
frame change rmods

list, noobs clean

* ---------------------------------------------- *
* labeln aus globals

mac list
global allglo:  all globals "cmd*" // alle globals mit cmd.. suchen
mac l allglo // gefundene globals
mac l cmd1 

levelsof mod, loc(mnrs)
foreach m of local mnrs {
	lab def mod_lab `m' "${cmd`m'}", modify
}
lab val mod mod_lab

list, noobs clean

/*
glo export_dir 	"D:\oCloud\Home-Cloud\Lehre\BIBB\StataProgBIBB\docs"
compress
save "${export_dir}/reg_results.dta", replace
*/

* beispielgrafik
graph twoway ///
	(rcap ll ul mod,horizontal lcolor("57 65 101") ) /// Konfidenzintervalle
	(scatter mod b,  mcolor("177 147 74") )  , /// Punktschätzer
	graphregion(fcolor(white)) /// Hintergundfarbe (außerhalb des eigentlichen Plots)
	ylabel(, valuelabel angle(0) labsize(tiny)) ///
	legend(off) ///
	xtitle("Einkommen (W) vs. Einkommen (M)") /// Achsentitel
	ytitle("") /// 
	title("Titel")  ///
	subtitle("Untertitel") ///
	caption("{it:Quelle: Erwerbstätigenbefragung 2018}", size(8pt) position(5) ring(5) )
	
graph export "${graph}/Regplot.png", replace /// speichern png-Datei
	