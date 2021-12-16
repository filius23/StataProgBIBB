* --------------------------------- *
* Programmieren mit Stata
* Kapitel 3: regressionsergebnisse weiterverarbeiten
* Lösungen
* --------------------------------- *

use "${data}/BIBBBAuA_2018_suf1.0_clean.dta", replace 


* --------------------------------- *
* 1 Erstellen Sie folgendes Regressionsmodell:

reg az i.mig01 zpalter
ereturn list

* Erstellen Sie jeweils einen `display`-Befehl, der den Koeffizienten und Standardfehler für `S1` und `zpalter` mit einer Aussagekräftigen Nachricht ausgibt
dis "Der Koeffizient für mig01=1 ist " _b[S1]
dis "Der Standardfehler des Koeffizienten für F200 ist " _se[F200]
dis "Der Koeffizient für F200 ist " _b[F200]
dis "Der Standardfehler des Koeffizienten für F200 ist " _se[F200]

* Wie würde das als Schleife aussehen?

* Extrahieren Sie die Regressionstabelle als `matrix` und legen sie diese als `frame` ab.
* Erstellen Sie zusätzlich eine Spalte mit dem Regressionsbefehl.

### Übung {#reg2}

Bauen Sie folgendes Modell Schritt für Schritt auf und lassen Sie sich die Tabelle mit `esttab` ausgeben:
```{stata, eval = F}
reg az i.S1 zpalter c.zpalter#c.zpalter i.gkpol i.F1604 i.F1604##i.S1
```
