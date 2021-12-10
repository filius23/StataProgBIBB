* basic stata programm gimmics
* Dereferencing elements of a numlist with a secondary numlist
local list 0 2 4 6 8 10 // store numlist in local `list'

	forvalues i = 1(1)6 { // for each value of `i' = [1,6]
		di `: word `i ' of `list ' ' // display the `i'th number in `list'
	} // repeat/end loop
 
* Dereferencing elements of a string list with a secondary numlist
local list1 "eins" "ZWEI" "Drei" "N9" "abc" "Ende" // store string list in local `list'

	forvalues i = 1(1)6 { // for each value of `i' = [1,6]
		 di "`: word `i' of `list1' '" // display the `i'th word in `list'
	 } // repeat/end loop
	 
*Indexing a numlist and looping over elements with a secondary numlist
tokenize 0 2 4 6 8 10 // store elements of list in sequential locals
	forvalues i = 1(1)6 { // for each value of `i' = [1,6]
		di ``i ' ' // display the `i'th positional local
	} // repeat/end loop

* Indexing a string list and looping over elements with a secondary numlist
tokenize `" "eins" "ZWEI" "Drei" "N9" "abc" "Ende" "'
forvalues i = 1(1)6 { // for each value of `i' = [1,6]
	di "``i' '" // display the `i'th positional local
 } // repeat/end loop
 
 
 
 
* 1. Determine joint-non-missingness using nested foreach loops
local varl1 language age female race marital pregnant
dis "`varl1'"


 foreach var1 of varlist `varlist ' {
	 foreach var2 of varlist `varlist ' {
	 qui count if !missing(`var1 ',`var2 ')
	 local nonmis = round(`r(N) '/_N*100)
	 di "{res}`nonmis'% {txt} of observations are " ///
	 "non-missing for both `var1' & `var2'"
	 }
}