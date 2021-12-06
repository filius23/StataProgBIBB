
help regexs

	mat m1[1,1] = r(miss)
	mat m1["zpalter",1] = 2
	
	help
	
	frame create loc
	frame change loc
	clear
	set obs 1
	gen x = ""
	replace x = "zpalter F518_SUF F200" in 1	
	gen t0 = ustrregexs(0) 	if ustrregexm(x, "F518")  // first word
	list
	frame change default
	
	
	help f_ustrregexm
	clear
	set obs 1
	gen x = ""
	replace x = "abcdefghiJKLMN 11123 asdas" in 1	
	gen t1 = ustrregexs(0) if ustrregexm(x, "\w+")  // first word
	gen t1a = ustrregexs(1) if ustrregexm(`x', "\w+")  // first word

	dis ustrregexm(`x', "\w+")  // first word
	dis ustrregexm(`x', "\w+")  // first word
	
	loc x = "zpalter F518_SUF F200"
	dis ustrregexm("`x'",  "F518")
	loc x2 = ustrregexs(0) 
	mac list 
	
	loc x = "zpalter F518_SUF F200"
	foreach v of local x {
		mdesc `v'
		}

		loc  v F200
		loc x = "zpalter F518_SUF F200"
		loc x2: list posof "zpalter" in x
		mac list
		loc x2: list posof `'"`v'"' in x
		
		loc x = "zpalter F518_SUF F200"
		local wc: word count `x'
		mac list

		
		dis strpos("zpalter F518_SUF F200","F200")
		dis ustrword("zpalter F518_SUF F200","F200")
		dis ustrwordcount("zpalter F518_SUF F200","F200")
		
		dis ustrpos("zpalter F518_SUF F200","F200")
			dis ustrcompare("zpalter F518_SUF F200","F200")
		dis subinword()
		dis word("zpalter F518_SUF F200",1)
		  
		  
		loc x = "zpalter F518_SUF F200"
		dis ustrwordcount("`x'","F518")
		
		help ustrword
		
		loc x = "zpalter F518_SUF F200"
		word 2 of `x'
		
		dis  subinstr("NEW YORK NEWARK","NEW YORK","NY", .)
		help subinstr
		
		 tokenize "some more words"
  di "1=|`1'|, 2=|`2'|, 3=|`3'|, 4=|`4'|"


  	loc x = "zpalter F518_SUF F200"
	forval v = 1/3 {
		mdesc `x'[`v']
	}
		
	
  
  
local str "cat+dog mouse++horse"
gettoken left : str
display `"`left'"'
