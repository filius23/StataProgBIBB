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

	
	
	
* -------------------------------- *
* Labelfunktionen 

loc v mod2
local vartype:     type `v' 				  // Variablen "storage type" (byte etc)
local varlab:      variable label `v' // variable label
local vallabname:  value label `v' 	  // Name des value label
local vallab1 :    label (`v') 1		 	// Value label für Wert = 1

* Die so erstellten `local`s können wir dann in der bekannten Methode wieder darstellen:
dis "`vartype'"     // display local "vartype"
dis "`varlab'"      // display local "varlabel"
dis "`vallabname'"  // display local "valuelabname"
dis "`vallab1'"     // display local "valuelab1"


* Wir können die Labels und Eigenschaften von `v' auch in einem Schritt anzeigen lassen, die Syntax sieht aber etwas eigenwillig aus:
loc v mod2
dis "`: type `v''" 				   // "storage type" (byte etc) der Variable
dis "`: variable label `v''"  // variable label
dis "`: value label `v''" 		 // Name des value label
dis "`: label (`v') 1'" 		   // Value label für Wert = 1


su mod2
gen mod3 = 7-mod2
list, nol
d 
label copy mod2 mod3 // 
























local phrase `" "2 guys" "1 girl" "1 pizza place" "'
di "`:word 2 of `phrase' '"




help regexs

	mat m1[1,1] = r(miss)
	mat m1["zpalter",1] = 2
	
	help
	
	frame create loc
	frame change loc
	clear
	set obs 1
	gen x = ""
	replace x = "zpalter F518_SUF F200" in 1	
	gen t0 = ustrregexs(0) 	if ustrregexm(x, "F518")  // first word
	list
	frame change default
	
	
	help f_ustrregexm
	clear
	set obs 1
	gen x = ""
	replace x = "abcdefghiJKLMN 11123 asdas" in 1	
	gen t1 = ustrregexs(0) if ustrregexm(x, "\w+")  // first word
	gen t1a = ustrregexs(1) if ustrregexm(`x', "\w+")  // first word

	dis ustrregexm(`x', "\w+")  // first word
	dis ustrregexm(`x', "\w+")  // first word
	
	loc x = "zpalter F518_SUF F200"
	dis ustrregexm("`x'",  "F518")
	loc x2 = ustrregexs(0) 
	mac list 
	
	loc x = "zpalter F518_SUF F200"
	foreach v of local x {
		mdesc `v'
		}

		loc  v F200
		loc x = "zpalter F518_SUF F200"
		loc x2: list posof "zpalter" in x
		mac list
		loc x2: list posof `'"`v'"' in x
		
		loc x = "zpalter F518_SUF F200"
		local wc: word count `x'
		mac list _wc

		
		
		
		
		
		
		dis strpos("zpalter F518_SUF F200","F200")
		dis ustrword("zpalter F518_SUF F200","F200")
		dis ustrwordcount("zpalter F518_SUF F200","F200")
		
		dis ustrpos("zpalter F518_SUF F200","F200")
			dis ustrcompare("zpalter F518_SUF F200","F200")
		dis subinword()
		dis word("zpalter F518_SUF F200",1)
		  
		  
		loc x = "zpalter F518_SUF F200"
		dis ustrwordcount("`x'","F518")
		
		help ustrword
		
		loc x = "zpalter F518_SUF F200"
		word 2 of `x'
		
		dis  subinstr("NEW YORK NEWARK","NEW YORK","NY", .)
		help subinstr
		
		 tokenize "some more words"
  di "1=|`1'|, 2=|`2'|, 3=|`3'|, 4=|`4'|"


  	loc x = "zpalter F518_SUF F200"
	forval v = 1/3 {
		mdesc `x'[`v']
	}
		
	
  
  
local str "cat+dog mouse++horse"
gettoken left : str
display `"`left'"'
