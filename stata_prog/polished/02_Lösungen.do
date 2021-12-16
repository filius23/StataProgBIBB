* --------------------------------- *
* Programmieren mit Stata
* Kapitel 2
* Lösungen
* --------------------------------- *


* ---------------------------------------------
* 1 Wörter in strings zählen

loc x1 "ein sehr langer satz mit vielen wörtern"
local lenx1: word count `x1'
mac list _lenx1
forvalues i = 1(1)`lenx1' {
    loc word: word `i' of `x1'
    dis "this is word number " `i' ": `word'"
}


ds *wib*
loc x2 =  r(varlist)
local lenx2: word count `x2'
mac list _lenx2
forvalues i = 1(1)`lenx2' {
    loc word: word `i' of `x2'
    dis "this is word number " `i' ": `word'"
}


* ---------------------------------------------
* 2



* ---------------------------------------------
* 3