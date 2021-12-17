* --------------------------------- *
* Programmieren mit Stata
* Kapitel 3: regressionsergebnisse weiterverarbeiten
* --------------------------------- *


use "${data}/BIBBBAuA_2018_suf1.0_clean.dta", replace 



* ------------------------------ *
* postestimates bei reg

* einfaches bivariates Modell
reg F518_SUF F200
ereturn list

dis e(N)
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

* rownumb hilft, einen Koeffizienten zu suchen
mat C1 = C[rownumb(C,"F200"),1...]
mat l C1

* einfaches reg-Modell mit kat. UV
reg F518_SUF i.S1 F200
ereturn list
mat l r(table) // etwas komplizierterer Name bei kat. UVs
dis "Der Koeffizient für S1 = weiblich ist " _b[2.S1]

mat D = r(table)' // transponieren
mat l D

cap frame drop regres1
xsvmat D,  names(col) rownames(coef) frame(regres1)
frame change regres1
list, noobs clean 

ereturn list
dis "`e(cmdline)'"

gen mo = "`e(cmdline)'"
list, noobs clean 

frame change default
* ----------------------------------------------------------------------------
* e(sample)

reg F518_SUF i.S1 F200
gen smpl = e(sample)
tab smpl

*ssc install mdesc
mdesc  F518_SUF S1 F200 if smpl == 0


* --------------------------------------
* reg schrittweise aufbauen 

glo mod1 i.S1 az i.m1202 zpalter i.Mig
qui regress F518_SUF ${mod1}
gen smpl2 = e(sample)

local len2: word count ${mod1}
forvalues i = 1(1)`len2' {
    loc word: word `i' of ${mod1}
    dis "Modell Nr" `i' ": mit `word'"
	loc x `x' `word'
	qui reg F518_SUF `x' if smpl2 == 1
	est store m`i'
}

est dir
esttab m*



help statsby

statsby _b _se , by(Bula) noisily  clear: ///
	regress F518_SUF c.F200##c.F200 i.m1202 i.S1