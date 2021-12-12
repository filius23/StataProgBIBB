*authors:	
*project: 	Krankenkassen
*purpose:	Master Do-File für Preprocessing von Krankenkassen-Jahresscheiben
*date:		
*changes:	

cap log close _all
glo beginnzeit=c(current_time)
prog drop _allado
set seed 123456789
set more off
set varabbrev off

*--- Globals -------------------------------------

glo project kraka
glo step	00master
glo FILE ${project}_${step}

glo YEAR `1'

*-------------------------------------------------
* SET SOURCES 
*-------------------------------------------------
*Datenquelle
glo INPATH "D:\GRLC\Arbeitsmittel\Adressen\orig"
*Arbeitsverzeichnis -> Projektordner
glo WHERE "//iab.baintern.de\dfs\017\Ablagen\D01700-IAB-Projekte\D01700-Krankenkassen\Preprocessing"


*-------------------------------------------------
* ADOPATH SETTINGS
*-------------------------------------------------
glo ADO_P "//iab.baintern.de\dfs\017\Ablagen\D01700-IAB-Projekte\D01700-Krankenkassen\Preprocessing\prog\r3"

*-------------------------------------------------
* DIRECTORY GLOBALS
*-------------------------------------------------
glo prog "prog"
glo log  "log"
glo data "data"
glo ORIG ${INPATH}

*-------------------------------------------------
* DO-FILES
*-------------------------------------------------
glo MASTER   	"00master"
glo PREA     	"01preA"

*-------------------------------------------------
* SPECIFY SUBSTEPS
*-------------------------------------------------
*step1:	Variablenumbenennung & -erstellung		j
*step2:	Betriebsstraße							n
*step3:	Betriebs-PLZ							evt
*step4:	Betriebsort								evt
*step5:	-
*step6:	Betriebsname							
*step7:	Rechtsform								
*step8:	eigentliches Namenspreprocessing

gl STEP1	0
gl STEP2	0
gl STEP3	0
gl STEP4	0
gl STEP6 	0
gl STEP7	0
gl STEP8	1		




*-------------------------------------------------
* FILES
*-------------------------------------------------
glo PROJECT       	D01700-Krankenkassen
glo FILE            ${PROJECT}_adrbetriebe_${year}
glo TEST		  	0
if ("$TEST" =="1" )	glo FILE "TEST"_${year}

glo LIEFERUNG1 a012723_betriebe_adr_ano
glo LIEFERUNG2 a012569_betriebe_adr_ano
glo LIEFERUNG3 a012949_adressen


cd $WHERE
display "`c(pwd)'"

*-------------------------------------------------
* SAMPLE?
*-------------------------------------------------


*-------------------------------------------------
* Automatisches Schreiben der Globals in ein Dofile, das später eingelesen wird
*-------------------------------------------------
file open macrodofile using prog\Global_DoFiles\krkbetriebe_globals.do, write replace
file write macrodofile "cd `c(pwd)'" _n
file write macrodofile "glo FILE $FILE" _n
file write macrodofile "glo ORIG $ORIG" _n
file write macrodofile "glo prog $prog" _n
file write macrodofile "glo SAMPLE $SAMPLE" _n
file write macrodofile "glo LIEFERUNG1 $LIEFERUNG1" _n
file write macrodofile "glo QUIETLY $QUIETLY" _n
file write macrodofile "adopath + ${ADO_P}" _n
file close macrodofile

type prog\Global_DoFiles\krkbetriebe_globals.do


foreach y of global YEAR {
	winexec `c(sysdir_stata)'StataMP-64.exe do ""`c(pwd)'"/prog/D01700-Krankenkassen_01preA.do" `y'
	*Wartezeit in ms -> 3600000 * Stunden
	glo hour = 3600000*0
	sleep $hour
	}
*

*

cap log close master

clear
exit, STATA clear
