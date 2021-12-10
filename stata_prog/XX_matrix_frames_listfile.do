





* ------------------------------- *
* r() und e()

clear all
cd "D:\Datenspeicher\BIBB_BAuA" // wo liegt der Datensatz?
use "BIBBBAuA_2018_suf1.0.dta", clear

su zpalter 
return list // Scalars
* mit diesen können wir rechnen
* Variationskoeffizient:
dis r(mean)/r(Var)

* aus scalars können wir auch macros machen:
glo mean_age = r(mean)

macro list mean_age
tab zpalter if inrange(zpalter,${mean_age} - .5,${mean_age} + .5)
tab S1 if inrange(zpalter,${mean_age} - .5,${mean_age} + .5)


*! Achtung - die r() enthalten nur die Werte für die letzte Variable:
su zpalter F518_SUF
return list
dis r(mean)/r(Var)

foreach v1 of varlist zpalter F518_SUF {
    su `v1'
	glo mean_`v1' = r(mean)
}






mat x = 2,2
mat l x

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




	foreach i of varlist * {
	local longlabel: var label `i'
	local shortlabel = substr("`longlabel'",1,32)
	label var `i' "`shortlabel'"
}

* ------------------------------- *
* matrix 
* regression und dann coefficient extrahieren und speichern

mat dir
mat SR = SR1625\SR1630\SR1635\SR1640\SR1645
mat list SR
svmat SR, names(col)
mat Y = J(`r(nmodels)',3,.)
mat X = $x
mat Y[`i',1] = X
matrix SR = r(coefs)'			// store proper info: SRs 
					
mat colname Y = year region_res language	// assign column name to Y(from loop above)
mat SR = SR,Y					// c-bind SR and Y

*create matrix containing info about age bandwidth and c-bind it to SR
mat R1 = J(rowsof(SR),1,`up')	
mat R2 = J(rowsof(SR),1,`down')
mat R = R1, R2
mat colname R = up down
mat SR = SR, R






* ------------------------------- *
* frame: mehrere Datensätze
* frame https://www.stata.com/features/overview/multiple-datasets-in-memory/
help frame
frame put if S1 == 2, into(women)
frame put if S1 == 1, into(men)

frame dir

frame change men 
reg F518_SUF zpalter i.m1202
est store mx

frame change women 
reg F518_SUF zpalter i.m1202
est store wx

frame change default

est dir

frame dir

clear all
frame create results t p 
forvalues i=1(1)1000 {
           quietly set obs 100
           quietly generate x = rnormal()
           quietly ttest x=0
           frame post results (r(t)) (r(p))
           drop _all
   }

frame dir   
frame change results   
list
frame results: count if p<=0.05
  43




* ------------------------------- *
* Dateien
cd "W:/ASR/data/temp"
	global fileslist: dir . files "SR*.dta" //get list of all temporary data sets with SR info in temp folder
	dis "SR files:"			
	mac list fileslist						
	
	loc usefile `: word 1 of ${fileslist}' 	// extract first entry from data set list
	use `usefile', clear					// load data set that was first created (i.e. with the lowest w)
	dis "`usefile' opened"
	
	loc n_datasets : list sizeof global(fileslist)		//append the other temporary data sets
	foreach i of numlist 2(1)`n_datasets' {
		loc appendfile `: word `i' of ${fileslist}'		// extract name of i_th data set from list
		append using `appendfile'						// append it!
		dis "`appendfile' appended"						// show it worked
	}


* erase

/* pmacro hilfe
local list : dir . files "*" makes a list of all regular files in the current directory.  Inlistmight be returned"subjects.dta" "step1.do" "step2.do" "reest.ado".

local list : dir . files "s*", respectcasein  Windows  makes  a  list  of  all  regular  filesin  the  current  directory  that  begin  with  a  lowercase  “s”.  The  case  of  characters  in  the  filenamesis preserved.  In Windows, without therespectcaseoption, all filenames would be converted tolowercase before being compared withpatternand possibly returned

.local list : dir . dirs "*"makes a list of all subdirectories of the current directory.  Inlistmight be returned"notes" "subpanel"

.local list : dir . other "*"makes  a  list  of  all  things  that  are  neither  regular  files  nordirectories.  These files rarely occur and might be, for instance, Unix device drivers

.local list : dir "\mydir\data" files "*"makes  a  list  of  all  regular  files  that  are  to  befound in\mydir\data.  Returned might be"example.dta" "make.do" "analyze.do".It is the names of the files that are returned, not their full path names

.local list : dir "subdir" files "*"makes a list of all regular files that are to be found insubdirof the current directory
*/


* ------------------------------- *
* DoFiles mit Parametern/Argumenten starten



* ------------------------------- *
* set trace on