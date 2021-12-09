/*****************************************************************************************\
|    Authors:        Dana Mueller, Katharina Strauch, Andreas Filser, Corinna Frodermann  |					
|    Date:           November 2021                                 						  | 
|    SIAB-version:   7519 v1                                       						  | 
|    Aim:            Identification of mothers and expected date   						  |
|		    		 of delivery		       											  | 
|    DO-version:     v1                                            						  | 
\*****************************************************************************************/


/*-----------------------------------------------------------------------------------------------------*\
  GENERATE five variables: 
  1) age of mother at child birth
  2) dummy for women with expected date of delivery but without return to labour market due to end of observation, 
  3) expected date of delivery, 
  4) number of children,
  5) dummy if mother or not 
\*-----------------------------------------------------------------------------------------------------*/


cap log close
log using ${log}/01_${logname}.log, replace

* LOAD SIAB DATA
use ${orig}/${dataname}.dta, clear									


*************************************************************
*0. Only women are kept in the dataset
*************************************************************
keep if frau==1

***************************************************************************
*1. Generate a new variable for income with single payments set to 0.
* Single payments can occur before mothers return to the labour market,
* for example the payment of Christmas bonuses.
***************************************************************************
gen tentgelt_neu=tentgelt
replace tentgelt_neu=0 if grund==154

***************************************************************************************************************
*2. Mark the begin of maternity protection
* grund 151 = BeH: wage compensation from a statutory health insurance
* grund 1114 = LeH: maternity benefit
* grund 502 = LHG: maternity benefit
* grund 310 = XASU: maternity leave
* Notifications of grund=152 'childcare leave' are not taken included because employers file this notification 
* when mothers take the last year of the parental leave later (possible until child's 8th birthday)
*************************************************************************************************************** 

tab quelle grund 	if inlist(grund,151,1114,502,310)
gen start=0 		if inlist(grund,151,1114,502,310)

*********************************************************************************************
*3. Generating the age with a limitation of childbearing age
*Comparisons with official birth statistics lead to a restriction at age 40
*********************************************************************************************
gen jahr_endorig=year(endorig)
gen age = jahr_endorig-gebjahr
replace start = . if age > 40 		
			
/*Some data versions include the month of birth as a sensitive variable that requires a special data application.
gen help_endorigm=month(endorig)
gen help_endorigy=year(endorig)

gen helpenorigmy = ym(help_endorigy, help_endorigm)
drop help_endorigm help_endorigy
	
gen gebdat = ym(gebjahr,gebmon) 
	
gen age = trunc((helpenorigmy-gebdat)/12)
*/

******************************************************
*4. Generating an "observation counter" per episode 
******************************************************
bysort persnr begepi (spell): gen byte level1 = _n-1

************************************************************************
*5. Computing the maternity protection
************************************************************************

*Generating a variable "help_start" with the start dates of maternity protection
cap drop help_start help_startm
sort persnr level1 start begepi
gen help_start=begepi if start==0 & level1==0 
format %td help_start 

*The variable "counter" counts the rows of start dates of maternity protection
sort persnr level1 start begepi
bysort persnr: gen counter=_n if start==0 & level1==0 
tab counter

*Restricting the first episode of maternity protection to employees prior to 38th birthday
gen help_gr=1 if age>38 & counter==1 & quelle==1  
bysort persnr: egen help_grm=max(help_gr)
count if help_grm==1 & persnr~=persnr[_n+1]
replace start=. if help_grm==1

* If several subsequent episodes are deregistered with the reason "maternity leave", the last episode is considered the start date
sort persnr level1 start begepi  
replace help_start=. if start==0 & start[_n+1]==0 & persnr[_n+1]==persnr & level1==0 & begepi[_n+1]-1<=endepi+7 & quelle[_n+1]==1
replace help_start=. if start==0 & start[_n+1]==0 & persnr[_n+1]==persnr & level1==0 & begepi[_n+1]-1<=endepi+91 & quelle~=1 & quelle[_n+1]~=1
bysort persnr: egen help_startm=min(help_start) //first notification of paid maternity protection
format %td help_startm 

* the variable "counter" must be generated again, because some episodes with start==0 have been set to missing above
replace start=. if help_start==.
cap drop counter
sort persnr level1 start begepi
bysort persnr: gen counter=_n if start==0 & level1==0

*Marking the return to the labour market 
sort persnr level1 begepi
by persnr: replace start=1 if begepi>endepi[_n-1] & (tentgelt_neu!=0 & tentgelt_neu<=. ) & start~=0 & level1==0 & quelle==1 
* variable "start" is set to missing for all employment periods prior to the first birth
by persnr: replace start=. if endepi<help_startm


*************************************************************
*6. Generating the employment interruption
* The period between two episodes is only considered if start==0 (potential pregnancy)
* If women have a deregistration but do not return to the labour market before 31-12-2014 a gap is generated 
* Furthermore a new variable is generated which marks women who do not re-enter the labour market for other reasons
* e.g. civil service, self employment, housewifes  
**************************************************************

* the variable "help" takes the value of the "counter" until a new gap begins
cap drop help
cap drop help_start_n
gen help_start_n=1 if start==0 | start==1
sort persnr quelle help_start_n level1 begepi
gen help=counter 
bysort persnr quelle help_start_n level1: replace help=help[_n-1] if help==. & help[_n+1]!=help[_n-1] & level1==level1[_n-1] 

*Generating start dates for each following maternity protection
sort persnr quelle help level1 begepi
cap drop help_startm
bysort persnr quelle help level1: egen help_startm=min(help_start)
format %td help_startm

*Generation the duration between re-entering the labour market and maternity protection 
cap drop gap
gen gap=(begepi[_n+1]-(endepi)) if start~=. & start[_n+1]~=. & start~=start[_n+1] & start==0 & persnr==persnr[_n+1] & help==help[_n+1]

* Mark women who do not re-enter the labour market 
sort quelle persnr begepi
gen end_obs = 2 if start == 0 & persnr ~= persnr[_n+1]
		
		qui su endepi
		glo end_max : dis %tdD_m_CY `r(max)' // end of observation period
		dis "End of observation period: ${end_max}"

replace gap = d(${end_max}) - endorig if end_obs == 2 
sum gap if end_obs == 2, d
gen jahr_end = year(endorig)
tab jahr_end if end_obs == 2


***************************************************************************
*7. Checking whether the interruption of work is due to illness or maternity protection
* A gap of 98 days is maternity protection
* Employment during the first 6 weeks is not considered
***************************************************************************
count if gap<98 
replace start=. if gap<98 & start==0

*********************************
*8. Generating the variable of expected date of delivery
* Exit + 6 weeks (42 days) in case of employment
* Exit + 6 weeks in case of maternity payment by the Federal Employment Agency
*********************************
*It is necessary to use endorig because overlapping periods of employment or non-employment have different durations
gen help_diff=endepi-endorig if start==0 & level1==0
sum help_diff, d

gen child_birth=endorig+42 if start==0 & level1==0
format %td child_birth

*****************************************************************************************************************************************
*9. Checking the gap between the expected dates of delivery
* Checking if the gap between siblings is less than 281 respectively 224 days 
* 281 days (40 weeks of pregnancy) would be a hard limitation because the expected date of delivery is correct for only 4% of all child births  
* 224 days (32 weeks of pregnancy) would be a realistic measure 
* The measurement of gaps is made in order of the children
*****************************************************************************************************************************************
sort persnr child_birth
cap drop gap_child
tab counter

qui su counter
foreach num of numlist 2/`r(max)' {
	cap drop counter 
	cap drop gap_child
	bysort persnr (child_birth): gen counter=_n if child_birth~=.
	gen gap_child=child_birth-child_birth[_n-1] if child_birth~=. & persnr==persnr[_n-1] 
	replace child_birth=. if gap_child<224 & counter==`num'
	}
tab gap_child if gap_child <224  
	

******************************************************************************************************************
* Number of children
* The number of children is underestimated because it can only be observed in case of employment liable to social security or benefit receipt
******************************************************************************************************************
sort persnr child_birth
bysort persnr: gen num_child=_n if child_birth~=. 
tab num_child

sum age if child_birth~=. 

bysort persnr: egen child_max=max(num_child)

drop tentgelt_neu start age counter help_start help_startm help gap gap_child help_gr help_grm

tab child_max if persnr~=persnr[_n+1], m 
gen mother=1 if child_max~=.
replace mother=0 if mother==.
tab mother if persnr~=persnr[_n+1]

tab gebjahr mother if persnr~=persnr[_n+1], row

log close