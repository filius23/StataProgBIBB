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



/* help macro


    Macro functions for parsing

        word count string
            returns the number of words in string.  A token is a word (characters separated by spaces) or set of words enclosed in quotes.  Do not enclose string in double quotes because word count
            will return 1.

        word # of string
            returns the #th token of string.  Do not enclose string in double quotes.

        piece #_1 #_2 of [`]"string"['] [, nobreak ]
            returns a piece of string.  This macro function provides a smart method of breaking a string into pieces of roughly the specified display columns.  #_1 specifies which piece to obtain.
            #_2 specifies the maximum number of display columns of each piece.  Each piece is built trying to fill to the maximum number of display columns without breaking in the middle of a word.
            However, when a word takes more display columns than #_2, the word will be split unless nobreak is specified.  nobreak specifies that words not be broken, even if that would result in a
            string being displayed in more than #_2 columns.

            Compound double quotes may be used around string and must be used when string itself might contain double quotes.

        strlen { local | global } mname
            returns the length of the contents of mname in bytes.  If mname is undefined, 0 is returned. For instance,

                . constraint 1 price = weight

                . local myname : constraint 1

                . macro list _myname
                _myname          price = weight

                . local lmyname : strlen local myname

                . macro list _lmyname
                _lmyname:        14

        ustrlen { local | global } mname
            returns the length of the contents of mname in Unicode characters.  If mname is undefined, 0 is returned.

        udstrlen { local | global } mname
            returns the length of the contents of mname in display columns.  If mname is undefined, 0 is returned.

        subinstr local mname "from" "to"
            returns the contents of mname, with the first occurrence of "from" changed to "to".

        subinstr local mname "from" "to", all
            does the same thing but changes all occurrences of "from" to "to".

        subinstr local mname "from" "to", word
            returns the contents of mname, with the first occurrence of the word "from" changed to "to".  A word is defined as a space-separated token or a token at the beginning or end of the
            string.

        subinstr local mname "from" "to", all word
            does the same thing but changes all occurrences of the word "from" to "to".

        subinstr global mname ...
            is the same as the above but obtains the original string from the global macro $mname rather than from the local macro mname.

        subinstr ... global mname ..., ...  count( { global | local } mname2)
            in addition to the usual, places a count of the number of substitutions in the specified global or in local macro mname2.
