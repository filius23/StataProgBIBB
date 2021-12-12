********************************************************************************
********************************************************************************

* =======================================
* Folder setup for data analysis project
* =======================================


****************************************

/* 
Change to root directory in which project folder should be generated
*/

cd "C:\" 		  
		  
****************************************

global project	"GESIS-SA"			// short name of project
global data		"pairfam_v10-0"		// name of used data (with version number)  

****************************************

mkdir		"${project}"
cd			"${project}"

mkdir 		"01_data"
	mkdir 	"01_data/01_${data}"
	mkdir 	"01_data/02_temp"
	mkdir 	"01_data/03_posted"

mkdir 		"02_data-documentation"
mkdir 		"03_do-files"
mkdir 		"04_r-scripts"
mkdir 		"05_log-files"
mkdir 		"06_tables"
mkdir 		"07_graphs"

mkdir 		"11_research-log"
mkdir 		"12_notes"

mkdir 		"21_readings"

mkdir 		"31_abstracts"
mkdir 		"32_presentations"
mkdir 		"33_manuscript"

********************************************************************************
********************************************************************************	

* =======================================
* Generate corresponding master Do-File
* =======================================

file open myfile using "03_do-files/00_master.do", write replace

file write myfile ///
`"********************************************************************************"' _n ///
`"********************************************************************************"' _n(2) ///
`"* ==============="' _n ///
`"* Master do-file"' _n ///
`"* 00_master.do"' _n ///
`"* ==============="' _n(2) ///
`"********************************************************************************"' _n ///
`"********************************************************************************"' _n(2) ///
`"* =============="' _n ///
`"* General setup"' _n ///
`"* =============="' _n(2) ///
`"version `c(version)'"' _n ///
`"set more off "' _n ///
`"clear all // clear memory"' _n(2) ///
`"capture log close // close open log files if need be"' _n(2) ///
`"********************************************************************************"' _n ///
`"********************************************************************************"' _n(2) ///
`"* ======================================================="' _n ///
`"* Specify random-number seed to ensure identical results"' _n ///
`"* ======================================================="' _n(2) ///
`"set seed 123454321"' _n(2) ///
`"********************************************************************************"' _n ///
`"********************************************************************************"' _n(3) ///
`"* ========================"' _n ///
`"* define macros for paths"' _n ///
`"* ========================"' _n(3) ///
`"// Working directory for the project"' _n ///
`"global workingDir 	"`c(pwd)'""' _n(2) ///
`"// Folders for the datasets"' _n ///
`"global data			"$"' `"{workingDir}/01_data""' _n(2) ///
`"	// Original pairfam data --> never change these files"' _n ///
`"	global pairfam		"$"' `"{data}/01_${data}""' _n(2) ///
`"	// temporary data files (usually to be deleted at the end of each do-file) "' _n ///
`"	global temp 		"$"' `"{data}/02_temp""' _n(2) ///
`"	// generated datasets ready to use in further do-files"' _n ///
`"	global posted		"$"' `"{data}/03_posted" "' _n(3) ///
`"// do-files"' _n ///
`"global dofiles 		"$"' `"{workingDir}/03_do-files"	"' _n(2) ///
`"// r-scripts"' _n ///
`"global rscripts		"$"' `"{workingDir}/04_r-scripts""' _n(2) ///
`"// log-files"' _n ///
`"global log 			"$"' `"{workingDir}/05_log-files""' _n(2) ///
`"// tables"' _n ///
`"global tables 		"$"' `"{workingDir}/06_tables""' _n(2) ///
`"// graphs"' _n ///
`"global graphs 		"$"' `"{workingDir}/07_graphs""' _n(2) ///
`"********************************************************************************"' _n ///
`"********************************************************************************"' _n(2) ///
`"* ============================================================"' _n ///
`"/*"' _n ///
`"Here you can also define other global macros you consider"' _n ///
`"useful for your data preperation "' _n ///
`"*/ "' _n ///
`"* ============================================================"' _n(2) ///
`"********************************************************************************"' _n ///
`"********************************************************************************"'				  

file close myfile
