* --------------------------------- *
* Programmieren mit Stata
* Kapitel 4: string Funktionen und Variablen bearbeiten
* Lösung
* --------------------------------- *

* --------------------------------- *
* 1  Verwenden Sie mit `input` die Adressdaten von oben

clear
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


* Wie kommen Sie jeweils an das vorletztes Wort aus der Adressliste?
list
gen nword = wordcount(add) 	  // Worte zählen
gen vorletz = word(add,nword-1) 	  // vorletztes Wort
gen vorletz2 = word(add,wordcount(add)-1) 	  // vorletztes Wort
list

* Wie kommen Sie jeweils an das 10.letzte bis 3.letzte Zeichen in der Adressliste?
replace add = trim(add)
gen len = strlen(add)
gen zehn = strlen(add)-10
gen zehndreiletzt = substr(add, zehn , 7)
list
gen zehndreiletzt2 = substr(add, strlen(add)-10, 7)
list

help substr


4.6.2 Übung

    Laden Sie den regex.dta:
    use "https://github.com/filius23/StataProgBIBB/raw/main/docs/regex1.dta", clear und teilen Sie die Informationen aus address in 4 Variablen auf: Hausnummer (erste Zahl), Straße, PLZ, Region
        Wandeln Sie alle Einträge in Großbuchstaben um
        Verwenden Sie split, um zwischen Adresse und PLZ & Ort zu trennen
        Wie können Sie jetzt die Zahlen vom Text trennen?
        Löschen Sie ggf. Leerzeichen zu Beginn und am Ende der Variablen

4.6.3 Übung

    Laden Sie der Erwerbstätigenbefragung

    Kürzen die die variable labels für alle Variablen mit “wissensintensiver Beruf” im Label (d *wib*)
        Ersetzen Sie “wissensintensiver Beruf” in den variable labels mit “wib.”
        Spielen Sie die Routine erst für eine Variable durch: welche Label-Befehle brauchen Sie?
        Denken Sie an foreach ... of varlist und die Möglichkeit, wildcards zu verwenden. Alternativ hilft evtl. auch ds mit Wildcards

    Bearbeiten Sie das value label für nuts2 - nutzen Sie dafür die regex und string-Funktionen von oben
        Löschen Sie “Statistische” aus den den value labels und ersetzen Sie “Direktionsbezirk” durch “Bezirk”

    Kehren Sie die Codierung vom m1202 um: gen m1202_n = 10 - m1202 und passen Sie die value labels entsprechend an die neue Codierung an.
        Tipp: auch die value labels müssen dann jeweils 10 - x genommen werden.

Für alle, die schon fertig sind:

    Wie könnten Sie automatisiert den Variable label für die Muttersprachenvariablen kürzen, sodass statt “Muttersprache:” nur noch “MSpr” im label steht?

4.6.4 Übung

    In welchen Variablen aus der Erwerbstätigenbefragung kommt der der Wert -9 vor?
    Füttern Sie diese Information in mvdecode, um die Missings zu überschreiben.
        Sammeln Sie die Information, welche Variablen -9 enthalten (Stichwort rekursive macro-Definition)
        Erstellen Sie einen mvdecode-Befehle, welcher die Information aufnimmt und in allen gefundenen Variablen -9 durch . ersetzt.

