* Master DoFile
cap log close
clear all
mac list
set trace off
clear matrix
clear mata

set more off,perm
set scrollbufsize 500000
set maxvar 32000, perm
set matsize 11000, perm
set linesize 250
set varabbrev off
prog drop _allado

estimates clear

* ------------------------------ *
* Pfade setzen
if ("`c(username)'" == "Filser") {
	glo pfad 		"D:\oCloud\Home-Cloud\Lehre\BIBB\StataProg"		// Projekt/Kursordner
}
* hier statt meinem den eigenen Projektordner angeben
* glo pfad 		""		// Projekt/Kursordner

glo data		"${pfad}/data"		// wo liegen die Datensätze?
glo log			"${pfad}/log"		// log-Ordner
glo tex 		"${pfad}/results"		// results-Ordner
glo prog		"${pfad}/prog"		// wo liegen die doFiles?


* ----------------------------- *
*  Ordner erstellen wenn nicht bereits vorhanden
foreach dir1 in data word tex prog {
	capture cd 	"${`dir1'}"
	if _rc!=0  {
		mkdir ${`dir1'}
		display "${`dir1'} erstellt"
	} 
 }

cd "${pfad}"

