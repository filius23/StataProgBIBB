clear all

glo pfad ""
glo data "D:\Datenspeicher\BIBB_BAuA" // wo liegt der Datensatz?

use "${data}/BIBBBAuA_2018_suf1.0.dta", clear

mvdecode zpalter, mv(9999)
mvdecode F518_SUF, mv( 99998/ 99999)
mvdecode F200, mv( 97/99)
mvdecode m1202, mv(-1)



* ------------------------------- *
* Schleifen aus globals / locals

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



* ------------------------------- *
* Informationen behalten
tab S1
return list
su S1
return list


gen S01 = S1 - 1 
tab S01 S1
help su // Liste unter Stored results

su S1
dis "Mittelwert beträgt: " r(mean)


foreach lvl  of global ausb {
	dis "m1202: " `lvl'
	su S01 if m1202 == `lvl'
	dis r(mean)
}

foreach lvl  of global ausb {
	qui su S01 if m1202 == `lvl'
	dis "Der Frauenanteil in m1202=" `lvl' " beträgt: " round(r(mean)*100,.1) "%"
}


foreach lvl  of global ausb {
	qui su S01 if m1202 == `lvl'
	glo gend`lvl': display "Der Frauenanteil in m1202=" `lvl' " beträgt: " round(r(mean)*100,.1) "%"
}

glo gend ""
foreach lvl  of global ausb {
	qui su S01 if m1202 == `lvl'
	glo gend: display "${gend}m1202=" `lvl' " " round(r(mean)*100,.1) "% "
}
mac l gend


* ------------------------------- *
* matrix
* https://thedatamonkey.blogspot.com/2011/01/stata-matrices.html

* Matrizen helfen uns, die ergebnisse in handhabarer Form zu speichern:
* help matrix
matrix Y1 = 1,3
mat l Y1
matrix Y2 = 4\ 0
mat l Y2

matrix Y = (2, 1.5 \ 2.5, 3)
mat l Y

// wir können auch Rechnungen einfügen
matrix X = (1+1, 2*3/4 \ 5/2, 3)
mat l X 




* mit J(Zeilen,Spalten,Inhalt) können wir eine Matrix mit gleichen Werten besetzen
mat G = J(4,2,00)
mat l G
// mit . in allen Zellen:
mat G = J(4,2,.)
mat l G
// das nutzen wir jetzt um unsere Ergebnisse zu speichern:

levelsof m1202, loc(ausb)
glo ausb `ausb'

mat G = J(4,2,.) // leere Matrix 
mat l G
mat colname G = m1202 share_w
mat l G

foreach lvl  of global ausb {
	qui su S01 if m1202 == `lvl'
	mat G[`lvl',2] = r(mean)*100
	mat G[`lvl',1] = `lvl'
}

mat l G

* ---------------------- *
* Teilmatrizen

mat X1 = (1,2,3,4,5 \ 6,7,8,9,10 \ 0,-1,-2,-3,-5 \ -6,-7,-8,-9,-10)
mat l X1

mat Z1 = X[1..2,1]
mat l X
mat l Z1

mat Z2 = X[1,1..2]
mat l X
mat l Z2

mat Z2[1,2] = 9
mat l Z2


* ---------------------- *
* mehrere Kennzahlen

su zpalter, detail
return list
mat GX = J(1,5,.) // leere Matrix 
mat GX[1,1] = -99
mat l GX

* mat GX[1,2...] = r(p25), r(mean), r(p50), r(p75) // :-(

mat GX[1,1] = 0,r(p25), r(mean), r(p50), r(p75) // workaround
mat l GX


mat G2 = J(4,5,.) // leere Matrix 
mat l G2
mat colname G2 = m1202 p25 mean median p75 
mat l G2

foreach lvl  of global ausb {
	qui su zpalter if m1202 == `lvl', det
	mat GX = `lvl', r(p25), r(mean), r(p50), r(p75) 
	mat G2[`lvl',1] = GX
}
mat l G2

matrix A = J(3,4,.) 
mat li A
mat A1 = (1, 4, 2, 1) 
mat li A1

mat A[1,1]  =A1
mat li A

* ---------------------- *
* regressionsergebnisse

qui use "${data}/BIBBBAuA_2018_suf1.0.dta", clear
quietly{
  mvdecode zpalter, mv(9999)
mvdecode F518_SUF, mv( 99998/ 99999)
mvdecode F200, mv( 97/99)
mvdecode m1202, mv(-1)
}
reg F518_SUF F200
dis "Der Koeffizient für F200 ist " _b[F200]
dis "Der Standardfehler des Koeffizienten für F200 ist " _se[F200]

* vorhergesagte Werte
dis _b[_cons] + 20 *_b[F200]
margins, at(F200 = 20)

*
gen pred_manual = _b[_cons] + F200 *_b[F200]
predict pred_auto, xb
gen diff=  pred_manual - pred_auto
su diff



reg F518_SUF i.S1 c.F200##c.F200 i.m1202 c.zpalter##c.zpalter




mat l e(b)
mat C = e(b)



use "D:\Datenspeicher\BIBB_BAuA/BIBBBAuA_2018_suf1.0_clean.dta", replace
keep if F200 > 0 & F518_SUF<99998 & m1202 > 0
statsby _b _se, by(gkpol) noisily: ///
	regress F518_SUF c.F200##c.F200 i.m1202 i.S1





local colnms: coln cut
matrix mt_bl_estd_colreg1 = mt_bl_estd[1..., colnumb(mt_bl_estd, "reg1")]


dis colnumb(X,"r1")
the column number of M associated with column name s; missing if the column cannot be found

matrix x = 99
matrix list x
mac list x // macros, locals und matrizen sind getrennte Welten






local naus : word count $ausb
mac l _naus


local x = matrix X[1,]



* find minimum + N anzeigen


help matrix functions



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



tab m1202 S1 



