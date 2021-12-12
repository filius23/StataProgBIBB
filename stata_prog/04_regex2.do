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
split add, parse(" ") gen(t) // hier wenig hilfreich
list

drop t*

* --------------------------- *
* regex

list
gen d = ustrregexm(add, "GERMANY")
list

// Wie erwischen wir jetzt Zeile 7?
drop d
gen d = ustrregexm(add, "GERMANY|Germany")
list

* ustrregexs 
gen d2 = ustrregexs(0) if ustrregexm(add, "GERMANY|Germany")
list
gen d3 = ustrregexs(0) if ustrregexm(add, "G(ERMANY|ermany)")
list
gen d4 = ustrregexs(0) if ustrregexm(add, "G(ERMANY|ermany)|USA")

drop d*
list
* ustrregex
gen s1 = ustrregexra(add, "street", "!")
gen s2 = ustrregexra(add, "[street]", "!")
list

drop s*
list


* regex-Regeln

* Zahlen suchen
cap drop r* 
gen r1 = ustrregexs(0) if ustrregexm(add, "\d")	 // Zahl
gen r2 = ustrregexs(0) if ustrregexm(add, "\d+") // Zahlenfolge
gen r3 = ustrregexs(0) if ustrregexm(add, "([0-9]{5})") // 5-stellige Zahl
gen r4 = ustrregexs(1) if ustrregexm(add, "(\d+).*(\d+)") // Zahlenfolge
gen r5 = ustrregexs(2) if ustrregexm(add, "(\d+)[_|\-|\.|,\s]?(\d+)") // Zahlenfolge
list

gen r3 = ustrregexs(1) if ustrregexm(add, "([0-9]{5})[\-]*[0-9]*[ a-zA-Z]*$")

help ustrregexs