***********************************
* (Project 7_Mobility)
*
* (Hoang Nhan Le and Zhengxiao Qin)
* 
* (May 10th,2018)
***********************************


cd "$path"
cd logs
log using "logfig7_test_country", text replace

cd "$path"
cd dataset



**********FIGURE 7 BY COUNTRY PART**********


* Open dataset
use "Data_Experiment_Waves_BC.dta", clear

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0
* Only control group
keep if Treated==0 

* Left and right
gen left=(ideology_economic ==1 | ideology_economic ==2)
replace left=. if ideology_economic==.
gen right=(ideology_economic ==4 | ideology_economic ==5)
replace right=. if ideology_economic==.

* Unequal opportunity is a problem
gen unequal_opp_problem_ser=(unequal_opportunities_problem>=2) 
replace unequal_opp_problem_ser=. if unequal_opportunities_problem==.

* Trust government dummy
gen trust_government_some=(trust_government>=1) /* at least sometimes  */
replace trust_government_some=. if trust_government==.

* Tools government
gen tools_government_some=(tools_government>=2) /* some or a lot */
replace tools_government_some=. if tools_government==.

* Government intervention high (5 or more in a scale 1-7)
gen govt_intervention_d=(government_intervention>=5)
replace govt_intervention_d=. if government_intervention==.

* Little trust in government
gen no_trust_government=(trust_government<1)
replace no_trust_government=. if trust_government==.

* Government cannot do much
gen limited_tools_government=(tools_government<=1)
replace limited_tools_government=. if tools_government==.

* Government should not do much (less than 5 in a scale 1-7)
gen limited_role_government=(government_intervention<5)
replace limited_role_government=. if government_intervention==.

* Taxes should be reduced
gen small_government=lowering_taxes_better

* Dummy if respondent is against government intervention in at least one of the above vars
gen against_government_1=(no_trust_government==1 | limited_tools_government==1 | limited_role_government==1 | small_government==1 )
replace against_government_1=. if (no_trust_government==. & limited_tools_government==. & limited_role_government==. & small_government==.)

* American dream alive
gen american_dream_alive=(american_dream>=4) /* agree or strongly agree */
replace american_dream_alive=. if american_dream==.


********** BY COUNTRY **********

******Below are the code of running the test******
foreach x in US UK Italy France Sweden {	
foreach y in econ_system_fair american_dream_alive effort_reason_poor /// 
effort_reason_rich trust_government_some tools_government_some govt_intervention_d ///
lowering_taxes_better against_government_1 unequal_opp_problem_ser {
su `y' if `x'==1&male==0
local mf`y'`x' = r(mean)
su `y' if `x'==1&male==1
local mm`y'`x' = r(mean)
local d`y'`x' = `mf`y'`x'' - `mm`y'`x''
ttest `y' if `x' == 1, by(male)
local t`y'`x' : dis %4.3f r(p)
}
}

macro dir

foreach x in US UK Italy France Sweden {	
foreach y in econ_system_fair american_dream_alive effort_reason_poor /// 
effort_reason_rich trust_government_some tools_government_some govt_intervention_d ///
lowering_taxes_better against_government_1 unequal_opp_problem_ser {
gen d`y'`x' = `d`y'`x''
replace d`y'`x' = . if `x' == 0
gen t`y'`x' = `t`y'`x''
replace t`y'`x' = . if `x' == 0
}
}





foreach x in US UK Italy France Sweden {	
foreach y in econ_system_fair american_dream_alive effort_reason_poor /// 
effort_reason_rich trust_government_some tools_government_some govt_intervention_d ///
lowering_taxes_better against_government_1 unequal_opp_problem_ser {

duplicates drop d`y'`x' if `x' == 1, force
duplicates drop t`y'`x' if `x' == 1, force


}
}






cap drop mat A
cap drop mat B

********Store the test result******


tabstat d*US, s(mean) save
tabstatmat A
mat2txt, matrix(A) saving(Table_for_US) replace ///
title("Table : statistics of the difference between male and female in US")


tabstat t*US, s(mean) save
tabstatmat B
mat2txt, matrix(B) saving(Table_for_US) append ///  * first to store it in txt 
title("Table : statistics of significant p-value to US")



dataout using Table_for_US.txt, excel replace  //change it to excel table


tabstat d*UK, s(mean) save
tabstatmat A
mat2txt, matrix(A) saving(Table_for_UK) replace ///
title("Table : statistics of the difference between male and female in UK")


tabstat t*UK, s(mean) save
tabstatmat B
mat2txt, matrix(B) saving(Table_for_UK) append ///
title("Table : statistics of significant p-value to UK")

dataout using Table_for_UK.txt, excel replace




tabstat d*France, s(mean) save
tabstatmat A
mat2txt, matrix(A) saving(Table_for_France) replace ///
title("Table : statistics of the difference between male and female in France")


tabstat t*France, s(mean) save
tabstatmat B
mat2txt, matrix(B) saving(Table_for_France) append ///
title("Table : statistics of significant p-value to France")

dataout using Table_for_France.txt, excel replace


tabstat d*Italy, s(mean) save
tabstatmat A
mat2txt, matrix(A) saving(Table_for_Italy) replace ///
title("Table : statistics of the difference between male and female in Italy")


tabstat t*Italy, s(mean) save
tabstatmat B
mat2txt, matrix(B) saving(Table_for_Italy) append ///
title("Table : statistics of significant p-value to Italy")

dataout using Table_for_Italy.txt, excel replace



tabstat d*Sweden, s(mean) save
tabstatmat A
mat2txt, matrix(A) saving(Table_for_Sweden) replace ///
title("Table : statistics of the difference between male and female in Sweden")


tabstat t*Sweden, s(mean) save
tabstatmat B
mat2txt, matrix(B) saving(Table_for_Sweden) append ///
title("Table : statistics of significant p-value to Sweden")

dataout using Table_for_Sweden.txt, excel replace


*****after this we merge all the results into one excel file*****


log close

