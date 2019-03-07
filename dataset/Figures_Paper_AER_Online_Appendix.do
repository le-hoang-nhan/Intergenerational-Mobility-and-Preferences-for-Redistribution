

/*

INTERGENERATIONAL MOBILITY AND PREFERENCES FOR REDISTRIBUTION
ALESINA, STANTCHEVA, TESO 
AER

THIS DO FILE GENERATES ALL FIGURES FOR ONLINE APPENDIX

*/

***************************************************************************************
***************************************************************************************
*** 		FIGURE OA6: HETEROGENEITY OF PERCEPTIONS CONDITIONAL ON EFFORT 		    ***
***************************************************************************************
***************************************************************************************

set more off

* Open September 2016 wave
use "Data_Experiment_Waves_BC.dta", clear

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Only control group
keep if Treated==0 

*** Generate dummies of interest ***

* Income
gen rich=0
foreach x in US UK France Italy Sweden {
su household_income if `x'==1, d
replace rich=1 if household_income>r(p75) & `x'==1
}
replace rich=. if household_income==.

* Left and right
gen left=(ideology_economic ==1 | ideology_economic ==2)
replace left=. if ideology_economic==.
gen right=(ideology_economic ==4 | ideology_economic ==5)
replace right=. if ideology_economic==.
gen center=(ideology_economic==3)
replace center=. if ideology_economic==.

* Young
gen young=(age<45)

* Unequal opportunity is a problem
gen unequal_opportunities_pr=(unequal_opportunities_problem>=2)
replace unequal_opportunities_pr=. if unequal_opportunities_problem==.

* Moved up with respect to father
gen moved_up=(job_prestige_father>3)
replace moved_up=. if job_prestige_father==.

* Immigrant
gen immigrant=(parents_born_in_country==0)
replace immigrant=. if parents_born_in_country==.	

* Black
gen black=(ethnicity ==2)
replace black=. if ethnicity==.
	
	
*** Label variables
label var male "Male"
label var young "Young"
label var children_dummy "Has Children" 
label var rich "Rich"
label var university_degree "College"
label var left "Left-wing"
label var right "Right-wing"
label var moved_up "Moved up ladder"
label var immigrant "Immigrant"
label var effort_reason_poor "Effort Poor"
label var effort_reason_rich "Effort Rich"
label var econ_system_fair "Econ. System Fair"
label var unequal_opportunities_pr "Unequal Opp. Problem"
label var black "African-American"
label var q1_to_q1_effort "Q1 to Q1"

rename left var_1
rename unequal_opportunities_pr var_2
rename econ_system_fair  var_3
rename effort_reason_poor  var_4
rename effort_reason_rich  var_5
rename rich  var_6
rename university_degree  var_7
rename moved_up  var_8
rename immigrant  var_9
rename black var_10
rename young  var_11
rename children_dummy  var_12
rename male var_13


*** GRAPH Q1 to Q1 ***

forvalues q=2(1)13 {
ci means q1_to_q1_effort if var_`q'==1, level(90)
local bY_`q' = r(mean)
local ub_bY_`q' = r(ub)
local lb_bY_`q' = r(lb)
}
forvalues q=2(1)13 {
ci means q1_to_q1_effort if var_`q'==0, level(90)
local bN_`q' = r(mean)
local ub_bN_`q' = r(ub)
local lb_bN_`q' = r(lb)
}
ci means q1_to_q1_effort if var_1==1 & ideology_economic!=3, level(90)
local bY_1 = r(mean)
local ub_bY_1 = r(ub)
local lb_bY_1 = r(lb)
ci means q1_to_q1_effort if var_1==0 & ideology_economic!=3 , level(90)
local bN_1 = r(mean)
local ub_bN_1 = r(ub)
local lb_bN_1 = r(lb)

preserve
        clear
        set obs 66
        egen t = seq()
		label define quintile 1 "Left-Wing" 2 "Unequal opp. problem" 3 "Econ system fair" 4 "Lack of effort reason poor" 5 "Effort reason rich" 6 "Rich" 7 "College" 8 "Moved up" 9 "Immigrant" 10 "African-American" 11 "Young" 12 "Children" 13 "Male" 
		label values t quintile
		replace t=t/5
				
        gen bY = .
        gen ub_bY = .
        gen lb_bY = .
		gen bN = .
        gen ub_bN = .
        gen lb_bN = .
		
		gen n=_n
	    forvalues q=1(1)13 {	
		replace bY=`bY_`q'' if n== (`q'*5-1)
		replace ub_bY=`ub_bY_`q'' if n==(`q'*5-1)
		replace lb_bY=`lb_bY_`q'' if n==(`q'*5-1)
		replace bN=`bN_`q'' if n==(`q'*5+1)
		replace ub_bN=`ub_bN_`q'' if n==(`q'*5+1)
		replace lb_bN=`lb_bN_`q'' if n==(`q'*5+1)
		}

	twoway 	(rspike lb_bY ub_bY t, hor lcolor(midblue*.2) lpattern(solid) lwidth(vthick)) ///
			(scatter t bY, mcolor(blue) lcolor(blue) lpattern(solid) msymbol(S)) ///
			(rspike lb_bN ub_bN t, hor lcolor(red*.2) lpattern(solid) lwidth(vthick)) ///
			(scatter t bN, mcolor(red) lcolor(red) lpattern(solid) msymbol(D)), ///
            ytitle("") ylabel(1 2 3 4 5 6 7 8 9 10 11 12 13, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
            xtitle("Pessimism: % staying in bottom quintile") ///
			legend(order(2 4) label(2 "Yes") label(4 "No")) ///
			yline(12.5, lcolor(gs14) lpattern("-")) yline(11.5, lcolor(gs14) lpattern("-")) ///
		    yline(10.5, lcolor(gs14) lpattern("-")) yline(9.5, lcolor(gs14) lpattern("-")) ///
		    yline(8.5, lcolor(gs14) lpattern("-")) yline(7.5, lcolor(gs14) lpattern("-")) ///
			yline(6.5, lcolor(gs14) lpattern("-")) yline(5.5, lcolor(gs14) lpattern("-")) ///
			yline(4.5, lcolor(gs14) lpattern("-")) yline(3.5, lcolor(gs14) lpattern("-")) ///
			yline(2.5, lcolor(gs14) lpattern("-")) yline(1.5, lcolor(gs14) lpattern("-")) ///
            graphregion(color(white)) plotregion(color(white))
			graph export "Figure_heterogeneity_Q1_effort.pdf", as(pdf) replace			
restore		
		
		

*** GRAPH Q1 to Q5 ***

forvalues q=2(1)13 {
ci means q1_to_q5_effort if var_`q'==1, level(90)
local bY_`q' = r(mean)
local ub_bY_`q' = r(ub)
local lb_bY_`q' = r(lb)
}
forvalues q=2(1)13 {
ci means q1_to_q5_effort if var_`q'==0, level(90)
local bN_`q' = r(mean)
local ub_bN_`q' = r(ub)
local lb_bN_`q' = r(lb)
}
ci means q1_to_q5_effort if var_1==1 & ideology_economic!=3, level(90)
local bY_1 = r(mean)
local ub_bY_1 = r(ub)
local lb_bY_1 = r(lb)
ci means q1_to_q5_effort if var_1==0 & ideology_economic!=3 , level(90)
local bN_1 = r(mean)
local ub_bN_1 = r(ub)
local lb_bN_1 = r(lb)

preserve
        clear
        set obs 66
        egen t = seq()
		label define quintile 1 "" 2 "" 3 "" 4 "" 5 "" 6 "" 7 "" 8 "" 9 "" 10 "" 11 "" 12 "" 13 "" 
		label values t quintile
		replace t=t/5
				
        gen bY = .
        gen ub_bY = .
        gen lb_bY = .
		gen bN = .
        gen ub_bN = .
        gen lb_bN = .
		
		gen n=_n
	    forvalues q=1(1)13 {	
		replace bY=`bY_`q'' if n== (`q'*5-1)
		replace ub_bY=`ub_bY_`q'' if n==(`q'*5-1)
		replace lb_bY=`lb_bY_`q'' if n==(`q'*5-1)
		replace bN=`bN_`q'' if n==(`q'*5+1)
		replace ub_bN=`ub_bN_`q'' if n==(`q'*5+1)
		replace lb_bN=`lb_bN_`q'' if n==(`q'*5+1)
		}

	twoway 	(rspike lb_bY ub_bY t, hor lcolor(midblue*.2) lpattern(solid) lwidth(vthick)) ///
			(scatter t bY, mcolor(blue) lcolor(blue) lpattern(solid) msymbol(S)) ///
			(rspike lb_bN ub_bN t, hor lcolor(red*.2) lpattern(solid) lwidth(vthick)) ///
			(scatter t bN, mcolor(red) lcolor(red) lpattern(solid) msymbol(D)), ///
            ytitle("") ylabel(1 2 3 4 5 6 7 8 9 10 11 12 13, value labsize(zero) angle(0) glcolor(gs16) noticks)  ///
            xtitle("Optimism: % reaching top quintile") ///
			legend(order(2 4) label(2 "Yes") label(4 "No")) ///
			yline(12.5, lcolor(gs14) lpattern("-")) yline(11.5, lcolor(gs14) lpattern("-")) ///
		    yline(10.5, lcolor(gs14) lpattern("-")) yline(9.5, lcolor(gs14) lpattern("-")) ///
		    yline(8.5, lcolor(gs14) lpattern("-")) yline(7.5, lcolor(gs14) lpattern("-")) ///
			yline(6.5, lcolor(gs14) lpattern("-")) yline(5.5, lcolor(gs14) lpattern("-")) ///
			yline(4.5, lcolor(gs14) lpattern("-")) yline(3.5, lcolor(gs14) lpattern("-")) ///
			yline(2.5, lcolor(gs14) lpattern("-")) yline(1.5, lcolor(gs14) lpattern("-")) ///
            graphregion(color(white)) plotregion(color(white))
			graph export "Figure_heterogeneity_Q5_effort.pdf", as(pdf) replace			
restore	



******************************************************************************
******************************************************************************
*** 		FIGURES OA7-0A11: HETEROGENEITY OF PERCEPTIONS BY COUNTRY      ***
******************************************************************************
******************************************************************************

set more off

* Open September 2016 wave
use "Data_Experiment_Waves_BC.dta", clear

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Only control group
keep if Treated==0 

*** Generate dummies of interest ***

* Income
gen rich=0
foreach x in US UK France Italy Sweden {
su household_income if `x'==1, d
replace rich=1 if household_income>r(p75) & `x'==1
}
replace rich=. if household_income==.

* Left and right
gen left=(ideology_economic ==1 | ideology_economic ==2)
replace left=. if ideology_economic==.
gen right=(ideology_economic ==4 | ideology_economic ==5)
replace right=. if ideology_economic==.
gen center=(ideology_economic==3)
replace center=. if ideology_economic==.

* Young
gen young=(age<45)

* Unequal opportunity is a problem
gen unequal_opportunities_pr=(unequal_opportunities_problem>=2)
replace unequal_opportunities_pr=. if unequal_opportunities_problem==.

* Moved up with respect to father
gen moved_up=(job_prestige_father>3)
replace moved_up=. if job_prestige_father==.

* Immigrant
gen immigrant=(parents_born_in_country==0)
replace immigrant=. if parents_born_in_country==.	

	
*** Label variables
label var male "Male"
label var young "Young"
label var children_dummy "Has Children" 
label var rich "Rich"
label var university_degree "College"
label var left "Left-wing"
label var right "Right-wing"
label var moved_up "Moved up ladder"
label var immigrant "Immigrant"
label var effort_reason_poor "Effort Poor"
label var effort_reason_rich "Effort Rich"
label var econ_system_fair "Econ. System Fair"
label var unequal_opportunities_pr "Unequal Opp. Problem"
label var q1_to_q1 "Q1 to Q1"

rename left var_1
rename unequal_opportunities_pr var_2
rename econ_system_fair  var_3
rename effort_reason_poor  var_4
rename effort_reason_rich  var_5
rename rich  var_6
rename university_degree  var_7
rename moved_up  var_8
rename immigrant  var_9
rename young  var_10
rename children_dummy  var_11
rename male var_12


**** by country ****

save "temp.dta", replace

foreach x in US UK France Italy Sweden {

use "temp.dta", clear
keep if `x'==1


*** GRAPH Q1 to Q1 ***

forvalues q=2(1)12 {
ci means q1_to_q1 if var_`q'==1, level(90)
local bY_`q' = r(mean)
local ub_bY_`q' = r(ub)
local lb_bY_`q' = r(lb)
}
forvalues q=2(1)12 {
ci means q1_to_q1 if var_`q'==0, level(90)
local bN_`q' = r(mean)
local ub_bN_`q' = r(ub)
local lb_bN_`q' = r(lb)
}
ci means q1_to_q1 if var_1==1 & ideology_economic!=3, level(90)
local bY_1 = r(mean)
local ub_bY_1 = r(ub)
local lb_bY_1 = r(lb)
ci means q1_to_q1 if var_1==0 & ideology_economic!=3 , level(90)
local bN_1 = r(mean)
local ub_bN_1 = r(ub)
local lb_bN_1 = r(lb)

preserve
        clear
        set obs 61
        egen t = seq()
		label define quintile 1 "Left-Wing" 2 "Unequal opp. problem" 3 "Econ system fair" 4 "Lack of effort reason poor" 5 "Effort reason rich" 6 "Rich" 7 "College" 8 "Moved up" 9 "Immigrant" 10 "Young" 11 "Children" 12 "Male" 
		label values t quintile
		replace t=t/5
				
        gen bY = .
        gen ub_bY = .
        gen lb_bY = .
		gen bN = .
        gen ub_bN = .
        gen lb_bN = .
		
		gen n=_n
	    forvalues q=1(1)12 {	
		replace bY=`bY_`q'' if n== (`q'*5-1)
		replace ub_bY=`ub_bY_`q'' if n==(`q'*5-1)
		replace lb_bY=`lb_bY_`q'' if n==(`q'*5-1)
		replace bN=`bN_`q'' if n==(`q'*5+1)
		replace ub_bN=`ub_bN_`q'' if n==(`q'*5+1)
		replace lb_bN=`lb_bN_`q'' if n==(`q'*5+1)
		}

	twoway 	(rspike lb_bY ub_bY t, hor lcolor(midblue*.2) lpattern(solid) lwidth(vthick)) ///
			(scatter t bY, mcolor(blue) lcolor(blue) lpattern(solid) msymbol(S)) ///
			(rspike lb_bN ub_bN t, hor lcolor(red*.2) lpattern(solid) lwidth(vthick)) ///
			(scatter t bN, mcolor(red) lcolor(red) lpattern(solid) msymbol(D)), ///
            ytitle("") ylabel(1 2 3 4 5 6 7 8 9 10 11 12, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
            xtitle("Pessimism: % staying in bottom quintile") ///
			legend(order(2 4) label(2 "Yes") label(4 "No")) ///
			yline(11.5, lcolor(gs14) lpattern("-")) ///
		    yline(10.5, lcolor(gs14) lpattern("-")) yline(9.5, lcolor(gs14) lpattern("-")) ///
		    yline(8.5, lcolor(gs14) lpattern("-")) yline(7.5, lcolor(gs14) lpattern("-")) ///
			yline(6.5, lcolor(gs14) lpattern("-")) yline(5.5, lcolor(gs14) lpattern("-")) ///
			yline(4.5, lcolor(gs14) lpattern("-")) yline(3.5, lcolor(gs14) lpattern("-")) ///
			yline(2.5, lcolor(gs14) lpattern("-")) yline(1.5, lcolor(gs14) lpattern("-")) ///
            graphregion(color(white)) plotregion(color(white))
			graph export "Figure_heterogeneity_Q1_`x'.pdf", as(pdf) replace			
restore		
		
		

*** GRAPH Q1 to Q5 ***

forvalues q=2(1)12 {
ci means q1_to_q5 if var_`q'==1, level(90)
local bY_`q' = r(mean)
local ub_bY_`q' = r(ub)
local lb_bY_`q' = r(lb)
}
forvalues q=2(1)12 {
ci means q1_to_q5 if var_`q'==0, level(90)
local bN_`q' = r(mean)
local ub_bN_`q' = r(ub)
local lb_bN_`q' = r(lb)
}
ci means q1_to_q5 if var_1==1 & ideology_economic!=3, level(90)
local bY_1 = r(mean)
local ub_bY_1 = r(ub)
local lb_bY_1 = r(lb)
ci means q1_to_q5 if var_1==0 & ideology_economic!=3 , level(90)
local bN_1 = r(mean)
local ub_bN_1 = r(ub)
local lb_bN_1 = r(lb)

preserve
        clear
        set obs 61
        egen t = seq()
		label define quintile 1 "" 2 "" 3 "" 4 "" 5 "" 6 "" 7 "" 8 "" 9 "" 10 "" 11 "" 12 ""
		label values t quintile
		replace t=t/5
				
        gen bY = .
        gen ub_bY = .
        gen lb_bY = .
		gen bN = .
        gen ub_bN = .
        gen lb_bN = .
		
		gen n=_n
	    forvalues q=1(1)12 {	
		replace bY=`bY_`q'' if n== (`q'*5-1)
		replace ub_bY=`ub_bY_`q'' if n==(`q'*5-1)
		replace lb_bY=`lb_bY_`q'' if n==(`q'*5-1)
		replace bN=`bN_`q'' if n==(`q'*5+1)
		replace ub_bN=`ub_bN_`q'' if n==(`q'*5+1)
		replace lb_bN=`lb_bN_`q'' if n==(`q'*5+1)
		}

	twoway 	(rspike lb_bY ub_bY t, hor lcolor(midblue*.2) lpattern(solid) lwidth(vthick)) ///
			(scatter t bY, mcolor(blue) lcolor(blue) lpattern(solid) msymbol(S)) ///
			(rspike lb_bN ub_bN t, hor lcolor(red*.2) lpattern(solid) lwidth(vthick)) ///
			(scatter t bN, mcolor(red) lcolor(red) lpattern(solid) msymbol(D)), ///
            ytitle("") ylabel(1 2 3 4 5 6 7 8 9 10 11 12, value labsize(zero) angle(0) glcolor(gs16) noticks)  ///
            xtitle("Optimism: % reaching top quintile") ///
			legend(order(2 4) label(2 "Yes") label(4 "No")) ///
			yline(11.5, lcolor(gs14) lpattern("-")) ///
		    yline(10.5, lcolor(gs14) lpattern("-")) yline(9.5, lcolor(gs14) lpattern("-")) ///
		    yline(8.5, lcolor(gs14) lpattern("-")) yline(7.5, lcolor(gs14) lpattern("-")) ///
			yline(6.5, lcolor(gs14) lpattern("-")) yline(5.5, lcolor(gs14) lpattern("-")) ///
			yline(4.5, lcolor(gs14) lpattern("-")) yline(3.5, lcolor(gs14) lpattern("-")) ///
			yline(2.5, lcolor(gs14) lpattern("-")) yline(1.5, lcolor(gs14) lpattern("-")) ///
            graphregion(color(white)) plotregion(color(white))
			graph export "Figure_heterogeneity_Q5_`x'.pdf", as(pdf) replace			
restore	


}


erase "temp.dta"


				

**********************************************************************************
**********************************************************************************
***	FIGURE OA12: SCATTER PLOTS OF GEOGRAPHY OF PERCEPTIONS IN THE US	       *** 					
**********************************************************************************
**********************************************************************************	

* Open Dataset
use "Data_Descriptive_Geography_US_Waves_ABC.dta", clear

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Generate average belief on mobility in a state
forvalues i=1(1)5 {
bys state: egen prob_p1_k`i'_belief_state=mean(q1_to_q`i')
}
* number of responses by state
bys state: gen numb_responses_state=_N

duplicates drop state, force
drop  q1_to_q5 q1_to_q4 q1_to_q3 q1_to_q2 q1_to_q1

* Negative correlations for Q1, Q4, Q5
reg prob_p1_k5_belief_state prob_p1_k5_state if numb_responses_state>=10
reg prob_p1_k5_belief_state prob_p1_k5_state if numb_responses_state>=10 & state!="NC" & state!="SC" & state!="VA" & ///
state!="WV" & state!="TN" & state!="GA" & state!="KY" & state!="AL" & state!="MS" & state!="FL"
reg prob_p1_k4_belief_state prob_p1_k4_state if numb_responses_state>=10
reg prob_p1_k1_belief_state prob_p1_k1_state if numb_responses_state>=10

* Scatter plots
twoway (scatter prob_p1_k5_belief prob_p1_k5_state, mlabcolor(gray) mcolor(gray) mlabel(state)) (lfit prob_p1_k5_belief prob_p1_k5_state, lc(dkgreen) lw(thick))		///
			(function y=x, range(4 20) lpattern(-) lcolor(gs9))  if numb_responses_state>=10 , ///
			legend(off) xtitle("Actual Probability") ytitle("Perceived Probability") ///
			ylabel(4(2)20) ///
			xlabel(4(2)20) ///
			text(14 18 "-0.301" "(0.147)", fc(white) si(large)) ///
            graphregion(color(white)) plotregion(color(white))		
graph export "scatter_USstates_Q5.pdf", as(pdf) replace
twoway (scatter prob_p1_k5_belief prob_p1_k5_state, mlabcolor(gray) mcolor(gray) mlabel(state)) (lfit prob_p1_k5_belief prob_p1_k5_state, lc(dkgreen) lw(thick))		///
			(function y=x, range(4 20) lpattern(-) lcolor(gs9))  if numb_responses_state>=10 & state!="NC" & state!="SC" & state!="VA" & ///
state!="WV" & state!="TN" & state!="GA" & state!="KY" & state!="AL" & state!="MS" & state!="FL" , ///
			legend(off) xtitle("Actual Probability") ytitle("Perceived Probability") ///
			ylabel(4(2)20) ///
			xlabel(4(2)20) ///
			text(14 18 "-0.348" "(0.176)", fc(white) si(large)) ///
            graphregion(color(white)) plotregion(color(white))		
graph export "scatter_USstates_Q5_dropSouth.pdf", as(pdf) replace
twoway (scatter prob_p1_k4_belief prob_p1_k4_state, mlabcolor(gray) mcolor(gray) mlabel(state)) (lfit prob_p1_k4_belief prob_p1_k4_state, lc(dkgreen) lw(thick))		///
			(function y=x, range(5 20) lpattern(-) lcolor(gs9))  if numb_responses_state>=10 , ///
			legend(off) xtitle("Actual Probability") ytitle("Perceived Probability") ///
			ylabel(5(5)20) ///
			xlabel(5(5)20) ///
			text(18 8 "-0.290" "(0.102)", fc(white) si(large)) ///
            graphregion(color(white)) plotregion(color(white))			
graph export "scatter_USstates_Q4.pdf", as(pdf) replace
twoway (scatter prob_p1_k1_belief prob_p1_k1_state, mlabcolor(gray) mcolor(gray) mlabel(state)) (lfit prob_p1_k1_belief prob_p1_k1_state, lc(dkgreen) lw(thick))		///
			(function y=x, range(20 50) lpattern(-) lcolor(gs9))  if numb_responses_state>=10 , ///
			legend(off) xtitle("Actual Probability") ytitle("Perceived Probability") ///
			ylabel(20(5)50) ///
			xlabel(20(5)50) ///
			text(40 45 "-0.524" "(0.199)", fc(white) si(large)) ///
            graphregion(color(white)) plotregion(color(white))		
graph export "scatter_USstates_Q1.pdf", as(pdf) replace



**********************************************************************************
**********************************************************************************
***	FIGURE OA13: HISTOGRAMS FOR TREATMENT EFFECTS			     	       	   *** 					
**********************************************************************************
**********************************************************************************	


set more off

* Open dataset
use "Data_Experiment_Waves_BC.dta", clear

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Left and right
gen left=(ideology_economic ==1 | ideology_economic ==2)
replace left=. if ideology_economic==.
gen right=(ideology_economic ==4 | ideology_economic ==5)
replace right=. if ideology_economic==.
gen center=(ideology_economic==3)
replace center=. if ideology_economic==.


* Policies
gen budget_opportunities=budget_education+budget_health
rename government_intervention government_interv
gen support_estate_45=(estate_tax_support>=4)
replace support_estate_45=. if estate_tax_support==.
rename level_playing_field_policies support_eq_opp_pol
rename income_tax_bottom50 income_tax_bot50
gen unequal_opp_problem_d= (unequal_opportunities_problem==4)
replace unequal_opp_problem_d=. if unequal_opportunities_problem==.
gen tools_d=(tools_government >=2)
replace tools_d=. if tools_government==.
  
* Saw these 3 questions before ladder
gen channels_before_ladder=(randomization_group==1 |  randomization_group==2 |  randomization_group==5 |  randomization_group==6)
   
*Rich
gen rich=0
foreach x in US UK France Italy Sweden {
su household_income if `x'==1, d
replace rich=1 if household_income>r(p75) & `x'==1
}
replace rich=. if household_income==.
 
*Young
gen young=(age<45)

* Moved up with respect to father
gen moved_up=(job_prestige_father>3)
replace moved_up=. if job_prestige_father==.
 
* Immigrant
gen immigrant=(parents_born_in_country==0)
replace immigrant=. if parents_born_in_country==.

* country-survey
egen country_survey=group(country round)

* Interactions
foreach x in left center right {
gen Treated_`x'=Treated*`x'
}

local Controls "i.country_survey left right center male young children_dummy rich university_degree immigrant moved_up"


foreach var in budget_opp budget_safetynet government_interv support_eq_opp_pol income_tax_top1 income_tax_bot50 support_estate_45 {
xi: reg `var' Treated_left Treated_right Treated_center `Controls'
      * save coefficients
        foreach i in left right {
                local b`var'`i' = _b[Treated_`i']
                local se`var'`i' = _se[Treated_`i']
                local ub_b`var'`i' = _b[Treated_`i'] + 1.645*_se[Treated_`i']
                local lb_b`var'`i' = _b[Treated_`i'] - 1.645*_se[Treated_`i']
                }
}
foreach var in unequal_opp_problem_d tools_d {
xi: reg `var' Treated_left Treated_right Treated_center `Controls' if channels_before_ladder==0
      * save coefficients
        foreach i in left right {
                local b`var'`i' = _b[Treated_`i']
                local se`var'`i' = _se[Treated_`i']
                local ub_b`var'`i' = _b[Treated_`i'] + 1.645*_se[Treated_`i']
                local lb_b`var'`i' = _b[Treated_`i'] - 1.645*_se[Treated_`i']
                }
}

* Panel A

        clear
        set obs 14
        egen t = seq()
        gen b = .
        gen ub_b = .
        gen lb_b = .
		
   

				
				replace b = `bgovernment_intervleft' if t==1
                replace ub_b = `ub_bgovernment_intervleft' if t==1
                replace lb_b = `lb_bgovernment_intervleft' if t==1
				replace b = `bgovernment_intervright' if t==2
                replace ub_b = `ub_bgovernment_intervright' if t==2
                replace lb_b = `lb_bgovernment_intervright' if t==2
				
				replace b = `bsupport_eq_opp_polleft' if t==4
                replace ub_b = `ub_bsupport_eq_opp_polleft' if t==4
                replace lb_b = `lb_bsupport_eq_opp_polleft' if t==4
				replace b = `bsupport_eq_opp_polright' if t==5
                replace ub_b = `ub_bsupport_eq_opp_polright' if t==5
                replace lb_b = `lb_bsupport_eq_opp_polright' if t==5
				
				replace b = `bsupport_estate_45left' if t==7
                replace ub_b = `ub_bsupport_estate_45left' if t==7
                replace lb_b = `lb_bsupport_estate_45left' if t==7
				replace b = `bsupport_estate_45right' if t==8
                replace ub_b = `ub_bsupport_estate_45right' if t==8
                replace lb_b = `lb_bsupport_estate_45right' if t==8
	
				replace b = `bunequal_opp_problem_dleft' if t==10
                replace ub_b = `ub_bunequal_opp_problem_dleft' if t==10
                replace lb_b = `lb_bunequal_opp_problem_dleft' if t==10
				replace b = `bunequal_opp_problem_dright' if t==11
                replace ub_b = `ub_bunequal_opp_problem_dright' if t==11
                replace lb_b = `lb_bunequal_opp_problem_dright' if t==11
				
				replace b = `btools_dleft' if t==13
                replace ub_b = `ub_btools_dleft' if t==13
                replace lb_b = `lb_btools_dleft' if t==13
				replace b = `btools_dright' if t==14
                replace ub_b = `ub_btools_dright' if t==14
                replace lb_b = `lb_btools_dright' if t==14
				
	
			label define b 1 "Government Interv." 2 "" 3 "" 4 "Support Equal. Opp. Pol." 5 "" 6 "" 7 "Support Estate Tax" 8 "" 9 "" 10 "Unequal Opp. Very Serious Prob." 11 "" 12 "" 13 "Govt. Tools" 14 "" 
			label values t b

		 twoway (bar b t if (t==1 | t==4 | t==7 | t==10 | t==13),  color(blue)) ///	
				(bar b t if (t==2 | t==5 | t==8 | t==11 | t==14),  color(red)) ///
				(rcap lb_b ub_b t, lcolor(black) lpattern(solid)  msymbol(D) lwidth(medthick)),  ///
				legend(order(1 2) lab(1 "Left-Wing") lab(2 "Right-Wing")) ///
				graphregion(color(white)) plotregion(color(white)) ///
				xlabel(1(3)14,labsize(1.8) val alternate) xtitle("")
				graph export "treatment_effects_histogram_A", as(pdf) replace

				

* Panel B

        clear
        set obs 11
        egen t = seq()
        gen b = .
        gen ub_b = .
        gen lb_b = .
		
   
				
				replace b = `bbudget_oppleft' if t==1
                replace ub_b = `ub_bbudget_oppleft' if t==1
                replace lb_b = `lb_bbudget_oppleft' if t==1
				replace b = `bbudget_oppright' if t==2
                replace ub_b = `ub_bbudget_oppright' if t==2
                replace lb_b = `lb_bbudget_oppright' if t==2
				
				replace b = `bbudget_safetynetleft' if t==4
                replace ub_b = `ub_bbudget_safetynetleft' if t==4
                replace lb_b = `lb_bbudget_safetynetleft' if t==4
				replace b = `bbudget_safetynetright' if t==5
                replace ub_b = `ub_bbudget_safetynetright' if t==5
                replace lb_b = `lb_bbudget_safetynetright' if t==5
				
				replace b = `bincome_tax_top1left' if t==7
                replace ub_b = `ub_bincome_tax_top1left' if t==7
                replace lb_b = `lb_bincome_tax_top1left' if t==7
				replace b = `bincome_tax_top1right' if t==8
                replace ub_b = `ub_bincome_tax_top1right' if t==8
                replace lb_b = `lb_bincome_tax_top1right' if t==8
	
				replace b = `bincome_tax_bot50left' if t==10
                replace ub_b = `ub_bincome_tax_bot50left' if t==10
                replace lb_b = `lb_bincome_tax_bot50left' if t==10
				replace b = `bincome_tax_bot50right' if t==11
                replace ub_b = `ub_bincome_tax_bot50right' if t==11
                replace lb_b = `lb_bincome_tax_bot50right' if t==11
				
	
			label define b 1 "Budget Opp." 2 "" 3 "" 4 "Budget Safety Net" 5 "" 6 "" 7 "Tax Rate Top 1" 8 "" 9 "" 10 "Tax Rate Bottom 50" 11 "" 
			label values t b

		 twoway (bar b t if (t==1 | t==4 | t==7 | t==10),  color(blue)) ///	
				(bar b t if (t==2 | t==5 | t==8 | t==11),  color(red)) ///
				(rcap lb_b ub_b t, lcolor(black) lpattern(solid)  msymbol(D) lwidth(medthick)),  ///
				legend(order(1 2) lab(1 "Left-Wing") lab(2 "Right-Wing")) ///
				graphregion(color(white)) plotregion(color(white)) ///
				xlabel(1(3)11,labsize(2.3) val alternate) xtitle("")
				graph export "treatment_effects_histogram_B", as(pdf) replace



**********************************************************************************
**********************************************************************************
***	FIGURE OA14: SCATTER PLOTS OF PERCEPTIONS OF INEQUALITY 				   *** 					
**********************************************************************************
**********************************************************************************

set more off

use "Data_Inequality_Perceptions_US.dta", clear
		
*** Inequality


* Mean perceived beliefs
foreach x in share_income_top1 share_income_top10 share_income_bottom50 {
su `x' if share_income_top1<share_income_top10
gen per_`x' = r(mean) 
}
foreach x in share_wealth_top1 share_wealth_top10 share_wealth_bottom50 {
su `x' if share_wealth_top1<share_wealth_top10
gen per_`x' = r(mean) 
}
foreach x in share_capital_top1 share_capital_top10 share_capital_bottom50 {
su `x' if share_income_top1<share_income_top10
gen per_`x' = r(mean) 
}

* Keep mean beliefs and true probabilities
keep share_income_top1_true share_income_top10_true share_income_bottom50_true share_wealth_top1_true share_wealth_top10_true share_wealth_bottom50_true share_capital_top1_true share_capital_top10_true share_capital_bottom50_true per_share_income_top1 per_share_income_top10 per_share_income_bottom50 per_share_wealth_top1 per_share_wealth_top10 per_share_wealth_bottom50 per_share_capital_top1 per_share_capital_top10 per_share_capital_bottom50
duplicates drop

* Top 1%
twoway (scatter per_share_income_top1 share_income_top1_true, msymbol(O) mcolor(red) msize(medlarge) ) ///
	   (scatter per_share_wealth_top1 share_wealth_top1_true, msymbol(D) mcolor(blue) msize(medlarge) ) ///
	   (scatter per_share_capital_top1 share_capital_top1_true, msymbol(S) mcolor(dkgreen) mlabposition(2) msize(medlarge)) ///
	   (function y=x, range(-1 100) lpattern(-) lcolor(gs9)) , ///
        ytitle("Average Perceived Share") ylabel(0(10)100, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
		xtitle("Actual Share") xlabel(0(10)100, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
        graphregion(color(white)) plotregion(color(white)) ///
		legend(order(1 2 3) label(1 "Income") label(2 "Wealth") label(3 "Capital"))
		graph export "figure_scatter_perceptions_top1.pdf", as(pdf) replace
	
* Top 10%
twoway (scatter per_share_income_top10 share_income_top10_true, msymbol(O) mcolor(red) msize(medlarge) ) ///
	   (scatter per_share_wealth_top10 share_wealth_top10_true, msymbol(D) mcolor(blue) msize(medlarge) ) ///
	   (scatter per_share_capital_top10 share_capital_top10_true, msymbol(S) mcolor(dkgreen) mlabposition(2) msize(medlarge)) ///
	   (function y=x, range(-1 100) lpattern(-) lcolor(gs9)) , ///
        ytitle("Average Perceived Share") ylabel(0(10)100, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
		xtitle("Actual Share") xlabel(0(10)100, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
        graphregion(color(white)) plotregion(color(white)) ///
		legend(order(1 2 3) label(1 "Income") label(2 "Wealth") label(3 "Capital"))
		graph export "figure_scatter_perceptions_top10.pdf", as(pdf) replace
		
* Bottom 50%
twoway (scatter per_share_income_bottom50 share_income_bottom50_true, msymbol(O) mcolor(red) msize(medlarge) ) ///
	   (scatter per_share_wealth_bottom50 share_wealth_bottom50_true, msymbol(D) mcolor(blue) msize(medlarge) ) ///
	   (scatter per_share_capital_bottom50 share_capital_bottom50_true, msymbol(S) mcolor(dkgreen) mlabposition(2) msize(medlarge)) ///
	   (function y=x, range(-1 100) lpattern(-) lcolor(gs9)) , ///
        ytitle("Average Perceived Share") ylabel(0(10)100, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
		xtitle("Actual Share") xlabel(0(10)100, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
        graphregion(color(white)) plotregion(color(white)) ///
		legend(order(1 2 3) label(1 "Income") label(2 "Wealth") label(3 "Capital"))
		graph export "figure_scatter_perceptions_bottom50.pdf", as(pdf) replace		
	


