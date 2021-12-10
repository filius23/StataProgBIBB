dis "Start: $S_DATE um $S_TIME"
sleep 6000
dis "Start: $S_DATE um $S_TIME"





local wanted : di "{dup 10:99 }"




* ---------------------------- *
glo pfad "D:\oCloud\Home-Cloud\Lehre\BIBB\StataProgBIBB"
cd "${pfad}/stata_prog/"
dyndoc programm.md


* ---------------------------- *
clear all
glo pfad "D:\Datenspeicher\BIBB_BAuA" // wo liegt der Datensatz?
use "${pfad}/BIBBBAuA_2018_suf1.0.dta", clear
mvdecode zpalter, mv(9999)
mvdecode F518_SUF, mv( 99998/ 99999)
mvdecode F200, mv( 97/99)
mvdecode m1202, mv(-1)