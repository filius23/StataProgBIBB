*Advanced Stata course do-files

*Exercise 1
use https://people.bath.ac.uk/klp33/advanced_stata_data.dta, clear

gen totcrimerate=totcrime/population*100000
gen imprisrate=impris/population*100000
gen execrate=exec/population*100000
gen unemplrate=unempl/lf*100
gen youthperc=youthpop/population*100
gen year2=year^2

reg totcrimerate inc unemplrate imprisrate execrate youthperc year year2
ereturn list

gen trend=_b[year]*year+_b[year2]*year2

scatter trend year

save "Crime data", replace

*Exercise 2
use "Crime data", clear

matrix accum Z = totcrimerate inc unemplrate imprisrate execrate youthperc year year2
matrix list Z

matrix XX = Z[2...,2...]
matrix Xy = Z[2...,1]
matrix b = inv(XX)*Xy

matrix list b

reg totcrimerate inc unemplrate imprisrate execrate youthperc year year2

*Exercise 3
use "Crime data", clear

foreach var of varlist violent property murder rape robbery assault burglary larceny motorv {
  gen `var'rate = `var'/population*100000
}

save "Crime data", replace

forvalues i = 50(50)250 {
  reg totcrimerate inc unemplrate execrate youthperc year year2 if imprisrate>=`i'-50 & imprisrate<`i'
}

*Exercise 4
use "Crime data", clear

program myreg
  args depvar

  matrix accum Z = `depvar' inc unemplrate imprisrate execrate youthperc year year2

  matrix XX = Z[2...,2...]
  matrix Xy = Z[2...,1]
  matrix b = inv(XX)*Xy

  matrix list b
end

*The following runs through all the categories of crime and compares myreg and regress
foreach var of varlist totcrime violent property murder rape robbery assault burglary larceny motorv {
  myreg `var'
  regress `var' inc unemplrate imprisrate execrate youthperc year year2
}
