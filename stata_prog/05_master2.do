* Master DoFile
clear all
mac list
set trace off
cap log close
clear matrix
clear mata
set more off,perm
set scrollbufsize 500000
set maxvar 32000, perm
set matsize 11000, perm
set linesize 250
set varabbrev off
estimates clear

cap log close _all
glo beginnzeit=c(current_time)
prog drop _allado
set seed 123456789
set more off
set varabbrev off

glo datapath	"C:\Users\Besucher\Desktop\PAIRFAM_DATA\Data\newData2"		// wo liegen die gemergten Datensaetze aus dem R Script?
glo log			"C:\Users\Besucher\Desktop\Mitnehmen_aktuell\log"			// Ordner fuer log Files
glo results		"C:\Users\Besucher\Desktop\Mitnehmen_aktuell\results"		// Ergebnisse -> Tabellen mit Koeffizienten, ORs usw.
glo graph		"C:\Users\Besucher\Desktop\Mitnehmen_aktuell\results"		// Graphiken
glo prog		"C:\Users\Besucher\Desktop\ANALYSES\onsite_final10"				// wo liegen die doFiles?
glo p_path 		"" // original pairfam daten -> wichtig für merge um sat3 und sin6i3 zu bekommen
 
which mdesc				

					*erstelle doFile fuer macros -> kurzes doFile um Pfade in Schleifen richtig zu setzen, wird dann in Schleifen immer aufgerufen
					file open macros using ${prog}\macrodofile.do, write replace
					file write macros "glo datapath		$datapath" 	_n
					file write macros "glo log			$log"		_n
					file write macros "glo results		$results"	_n
					file write macros "glo graph		$graph"		_n
					file write macros "glo prog			$prog"		_n
					file write macros "glo p_path		$p_path"	_n
					file close macros 
								
di "$S_DATE $S_TIME"



* ------------------------------ *																
* ICC für SRs
* ------------------------------ *
cd $prog			
					file open  loopdofile_icc3 using ${prog}\loop_ICCd_new.do, write replace
					file write loopdofile_icc3 "glo d `" "1" "'									"	_n
					file write loopdofile_icc3 "mac list										"	_n
					file write loopdofile_icc3 "if ($""{d}<3)	glo wids 1 2 3 4 5				"	_n
					file write loopdofile_icc3 "if ($""{d}==3)	glo wids 1 						"	_n
					file write loopdofile_icc3 "foreach wid of global wids {					"	_n 
					file write loopdofile_icc3 "cd $prog										"	_n 
					file write loopdofile_icc3 "do 06d_ICC_new.do $" "d " "`" "wid'				"	_n
					file write loopdofile_icc3 " }												"	_n
					file write loopdofile_icc3 "cd $prog										"	_n
					file write loopdofile_icc3 "esttab M* using ${results}\ICC_M_SR$" "{d}.csv, stats(icc icc_se icc_cl icc_cu ,fmt(a3)) noconstant label replace  mti noeqlines compress nolines brack nonumbers scsv nonotes" 	_n
					file write loopdofile_icc3 "esttab F* using ${results}\ICC_F_SR$" "{d}.csv, stats(icc icc_se icc_cl icc_cu ,fmt(a3)) noconstant label replace  mti noeqlines compress nolines brack nonumbers scsv nonotes" 	_n
					file write loopdofile_icc3 "clear											" 	_n
					file write loopdofile_icc3 "exit,STATA	clear								"	_n
					file close loopdofile_icc3	
					
forvalues d = 0(1)3 { // 3 -> ASR
			cd $prog
			winexec `c(sysdir_stata)'StataSE-64.exe do loop_ICCd_new.do `d'
		}
*																		
																		
cap log close master
clear
exit, STATA clear


