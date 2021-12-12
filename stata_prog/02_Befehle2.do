
local phrase `" "3 guys" "1 girl" "1 pizza place" "'
loc word2: word 2 of `phrase'
mac l _word2
di "`:word 2 of `phrase' '"

local sentence "here is a sentence of 7 words"
local len: word count `sentence'
mac list _len

local phrase1 "here is a sentence of 7 words"
local len1: word count `phrase1'

forvalues i = 1(1)`len1' {
	loc word: word `i' of `phrase1'
	dis "this is word number " `i' ": `word'"
}

local phrase2 `" "here is" "a sentence" "of 7 words" "'
local len2: word count `phrase2'

forvalues i = 1(1)`len2' {
	loc word: word `i' of `phrase2'
	dis "this is word number " `i' ": `word'"
}








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
 
 
/* help macro


    Macro functions for parsing

        word count string
            returns the number of words in string.  A token is a word (characters separated by spaces) or set of words enclosed in quotes.  Do not enclose string in double quotes because word count will return 1.

        word # of string
            returns the #th token of string.  Do not enclose string in double quotes.

        piece #_1 #_2 of [`]"string"['] [, nobreak ]
            returns a piece of string.  This macro function provides a smart method of breaking a string into pieces of roughly the specified display columns.  #_1 specifies which piece to obtain.
            #_2 specifies the maximum number of display columns of each piece.  Each piece is built trying to fill to the maximum number of display columns without breaking in the middle of a word.
            However, when a word takes more display columns than #_2, the word will be split unless nobreak is specified.  nobreak specifies that words not be broken, even if that would result in a string being displayed in more than #_2 columns.
            Compound double quotes may be used around string and must be used when string itself might contain double quotes.

        strlen { local | global } mname
            returns the length of the contents of mname in bytes.  If mname is undefined, 0 is returned. 
        ustrlen { local | global } mname
            returns the length of the contents of mname in Unicode characters.  If mname is undefined, 0 is returned.
        udstrlen { local | global } mname
            returns the length of the contents of mname in display columns.  If mname is undefined, 0 is returned.
        subinstr local mname "from" "to"
            returns the contents of mname, with the first occurrence of "from" changed to "to".
        subinstr local mname "from" "to", all
            does the same thing but changes all occurrences of "from" to "to".
        subinstr local mname "from" "to", word
            returns the contents of mname, with the first occurrence of the word "from" changed to "to".  A word is defined as a space-separated token or a token at the beginning or end of the string.
        subinstr local mname "from" "to", all word
            does the same thing but changes all occurrences of the word "from" to "to".
        subinstr global mname ...
            is the same as the above but obtains the original string from the global macro $mname rather than from the local macro mname.
        subinstr ... global mname ..., ...  count( { global | local } mname2)
            in addition to the usual, places a count of the number of substitutions in the specified global or in local macro mname2.

	
	