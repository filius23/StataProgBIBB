* --------------------------------- *
* Programmieren mit Stata
* Kapitel 4: regex - ein (kurzer) Überblick
* --------------------------------- *


* Beispieldaten (inspiriert von UCLA)
clear all
input str60 add
"4905 Lakeway Drive, College Station, Texas 77845 USA"
"673 Jasmine Street, Los Angeles, CA 90024"
"2376 First street, San Diego, CA 90126"
"6 West Central St, Tempe AZ 80068"
"1234 Main St. Cambridge, MA 01238-1234"
"Robert-Schuman-Platz 3, 53175 Bonn GERMANY"
"Regensburger Straße 100, 90478 Nürnberg Germany"
"  Ammerländer Heerstraße 114-118, 26129 Oldenburg GERMANY  "
end


* --------------------------- *
* Stringfunktionen

gen x1 = substr(add,5,10) 	//  substring von add -> Zeichen 5-10
gen x2 = wordcount(add) 	// Worte zählen
gen x3 = word(add,5) 		// 5. Wort
gen x4 = upper(add)			// alles groß
*gen x5 = lower(add)
list
drop x*
gen x6 = proper(add) // nur erster Buchstabe groß
gen x7 = trim(add) // Leerzeichen am Ende und Beginn raus
gen x8 = strlen(add) // Leerzeichen am Ende und Beginn raus


list

// ustrupper() and ustrlower() bei Umlauten -> siehe Hilfe
display ustrupper("Regensburger Straße 100, 90478 Nürnberg Germany")
display upper("Regensburger Straße 100, 90478 Nürnberg Germany")

drop x*
list


* --------------------------- *
* split
split add, parse(" ") gen(t) // hier wenig hilfreich eher etwas für 
list

drop t*

* --------------------------- *
* regex
list
* ustrregexm -> 0/1, 1 wenn Treffer
gen d = ustrregexm(add, "GERMANY") 
list
gen d2 = ustrregexm(add, "GERMANY|Germany") // ODER
list
* ustrregexs --> extrahieren
gen d3 = ustrregexs(0) if ustrregexm(add, "GERMANY|Germany")
gen d4 = ustrregexs(0) if ustrregexm(add, "G(ERMANY|ermany)")  // entspricht d3
gen d5 = ustrregexs(0) if ustrregexm(add, "G(ERMANY|ermany)|USA")
list
drop d*

* ustrregexra --> ersetzen
gen s1 = ustrregexra(add, "street", "!")
gen s2 = ustrregexra(add, "[street]", "!")
list
drop s*
list

* ersetzen mit regex-Regelausdrücken
cap drop z*
gen z1 =  ustrregexra(add, "\w", "") // alle alphanumeric raus
gen z2 = ustrregexra(add, "\W", "") // alle nicht-alphanumeric raus
gen z3 =  ustrregexra(add, "\d", "") // alle Zahlen raus 
gen z4 = ustrregexra(add, "\D", "") // alle nicht-Zahlen raus 
list

cap drop z*
gen z5 = ustrregexra(add, ".+,", "") // alles vor dem Komma raus
gen z6 = ustrregexra(add, ",.+", "") // alles nach dem Komma raus
list


* regex-Regeln
* Zahlen suchen
cap drop r* 
gen r1 = ustrregexs(0) if ustrregexm(add, "\d")	 // Zahl
gen r2 = ustrregexs(0) if ustrregexm(add, "\d+") // Zahlenfolge
gen r3 = ustrregexs(0) if ustrregexm(add, "(\d{5})") // 5-stellige Zahl
gen r4 = ustrregexs(0) if ustrregexm(add, "^(\d+)") // Zahlenfolge am Anfang
gen r5 = ustrregexs(0) if ustrregexm(add, "(\d+).*(\d+)") // Zahlenfolgen und alles was dazwischen kommt 
gen r6 = ustrregexs(0) if ustrregexm(r5, "(\d+)$") // Zahlenfolge am Ende -> aus r5!
list


* -------------------------------- *
* Regressionstabelle weiter bearbeiten

clear all
macro drop _all 
use b ll ul mod using "https://github.com/filius23/StataProgBIBB/raw/main/docs/reg_results.dta", clear

list
list, nol
// aus gelabelter numeric eine string variable machen
decode mod , generate(mstr)
list, nol

replace mstr = ustrregexra(mstr,"regress F518_SUF i.S1","")
replace mstr = ustrregexra(mstr,"c\.|i\.","")
replace mstr = ustrregexra(mstr,"F200","Stunden/Woche")
replace mstr = ustrregexra(mstr,"Stunden/Woche#Stunden/Woche","Stunden/Woche²")
replace mstr = ustrregexra(mstr,"zpalter","Alter")
replace mstr = ustrregexra(mstr,"Alter#Alter","Alter²")
replace mstr = ustrregexra(mstr,"m1202","Ausbildung")
replace mstr = trim(mstr)
replace mstr = ustrregexra(mstr," ",", ")
replace mstr = "bivariat" if mstr == ""
list

// zurück zu numerisch mit labeln
encode mstr, gen(mod2)
label var mod2 "gelabelte Modellbezeichnung"
* beispielgrafik
graph twoway ///
	(rcap ll ul mod2,horizontal lcolor("57 65 101") ) /// Konfidenzintervalle
	(scatter mod2 b,  mcolor("177 147 74") )  , /// Punktschätzer
	graphregion(fcolor(white)) /// Hintergundfarbe (außerhalb des eigentlichen Plots)
	ylabel(, valuelabel angle(0) labsize(small)) ///
	legend(off) ///
	xtitle("Einkommen (W) vs. Einkommen (M)") /// Achsentitel
	ytitle("") /// 
	title("Titel")  ///
	subtitle("Untertitel") ///
	caption("{it:Quelle: Erwerbstätigenbefragung 2018}", size(8pt) position(5) ring(5) )

	
	
	

local phrase `" "2 guys" "1 girl" "1 pizza place" "'
di "`:word 2 of `phrase' '"

local sentence "here is a sentence 7"
local w2: word 4 of `sentence'
mac list _w2

local len: word count `sentence'
mac list _len


