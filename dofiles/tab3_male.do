***********************************
* (Project 7_Mobility)
*
* (Hoang Nhan Le and Zhengxiao Qin)
* 
* (May 10th,2018)
***********************************



cd "$path"
cd logs
log using "logtab3_male", text replace

cd "$path"
cd dataset
**********************************************************************************
***	TABLE 3:  PESSIMISM AND OPTIMISM CORRELATED WITH POLICIES       	       *** 					
**********************************************************************************
**********************************************************************************		


* Open dataset
use "Data_Experiment_Waves_BC.dta", clear

drop if male==0


* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0
* Only control group
keep if Treated==0 

* Left and right
gen left=(ideology_economic ==1 | ideology_economic ==2)
replace left=. if ideology_economic==.
gen right=(ideology_economic ==4 | ideology_economic ==5)
replace right=. if ideology_economic==.
gen center=(ideology_economic==3)
replace center=. if ideology_economic==.

* Policies
gen budget_opportunities=budget_education+budget_health
gen support_estate_45=(estate_tax_support>=4)
replace support_estate_45=. if estate_tax_support==.
rename level_playing_field_policies support_eq_opp_pol
rename income_tax_bottom50 income_tax_bot50
gen unequal_opp_problem_d= (unequal_opportunities_problem==4)
replace unequal_opp_problem_d=. if unequal_opportunities_problem==.
gen tools_d=(tools_government >=2)
replace tools_d=. if tools_government==.

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
gen q1_to_q1_`x'=q1_to_q1*`x'
gen q1_to_q5_`x'=q1_to_q5*`x'
gen q1_to_q1_effort_`x'=q1_to_q1_effort*`x'
gen q1_to_q5_effort_`x'=q1_to_q5_effort*`x'
}


* Label variables
label var q1_to_q1_left "Q1 to Q1 $\times$ Left-Wing"
label var q1_to_q5_left "Q1 to Q5 $\times$  Left-Wing"
label var q1_to_q1_effort_left "Q1 to Q1 $\times$ Left-Wing"
label var q1_to_q5_effort_left "Q1 to Q5 $\times$ Left-Wing"
label var q1_to_q1_right "Q1 to Q1 $\times$ Right-Wing"
label var q1_to_q5_right "Q1 to Q5 $\times$ Right-Wing"
label var q1_to_q1_effort_right "Q1 to Q1 $\times$ Right-Wing"
label var q1_to_q5_effort_right "Q1 to Q5 $\times$ Right-Wing"
label var q1_to_q1 "Q1 to Q1"
label var q1_to_q5 "Q1 to Q5"
label var q1_to_q1_effort "Q1 to Q1"
label var q1_to_q5_effort "Q1 to Q5"
label var left "Left-Wing"
label var right "Right-Wing"


* Tables start
file open holder using tab3_correlations_mobility_policy_first_part_male.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lccccccccc} " _n
file write holder "&   & & Support & & Unequal Opp. & &  &  & \\" _n
file write holder "& Budget & Support & Equality & Government & Very Serious & Budget & Tax Rate & Tax Rate & Govt. \\" _n
file write holder "& Opp. & Estate Tax & Opp. Policies & Interv. & Problem & Safety Net & Top 1 & Bottom 50 & Tools \\" _n
file write holder "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) \\ \hline" _n
file close holder
file open holder using tab3_correlations_mobility_policy_second_part_male.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lccccccccc} " _n
file write holder "&   & & Support & & Unequal Opp. & &  &  & \\" _n
file write holder "& Budget & Support & Equality & Government & Very Serious & Budget & Tax Rate & Tax Rate & Govt. \\" _n
file write holder "& Opp. & Estate Tax & Opp. Policies & Interv. & Problem & Safety Net & Top 1 & Bottom 50 & Tools \\" _n
file write holder "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) \\ \hline" _n
file close holder

local Controls "i.country_survey left right male young children_dummy rich university_degree immigrant moved_up"

*********** PANEL A *********** 

*** Q1 to Q1: ***

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 tools_d {
eststo: xi: reg `var'  q1_to_q1 `Controls'
}
esttab using temp_all_Q1_PanelA.tex, replace fragment booktabs keep(q1_to_q1) label /// 
nostar se nonumbers noobs nomtitles nolines compress b(3)

*** Q1 to Q5 ***

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 tools_d {
eststo: xi: reg `var'  q1_to_q5 `Controls'
}
esttab using temp_all_Q5_PanelA.tex, replace fragment booktabs keep(q1_to_q5) label /// 
nostar se nonumbers noobs nomtitles nolines compress b(3)

*********** PANEL B *********** 

*** Q1 to Q1: ***

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 tools_d {
eststo: xi: reg `var'  q1_to_q1_left q1_to_q1_right q1_to_q1_center `Controls'
test q1_to_q1_left= q1_to_q1_right
local `var'_1: display %5.3f `r(p)'
}
esttab using temp_all_Q1_PanelB.tex, replace fragment booktabs keep(q1_to_q1_left q1_to_q1_right left right) label /// 
nostar se nonumbers noobs nomtitles nolines compress b(3)


*** Q1 to Q5 ***

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 tools_d {
eststo: xi: reg `var'  q1_to_q5_left q1_to_q5_right q1_to_q5_center `Controls'
test q1_to_q5_left= q1_to_q5_right
local `var'_5: display %5.3f `r(p)'
su q1_to_q5_left if e(sample)==1
local `var'_o : display %5.0f `r(N)'
}
esttab using temp_all_Q5_PanelB.tex, replace fragment booktabs keep(q1_to_q5_left q1_to_q5_right left right) label /// 
nostar se nonumbers noobs nomtitles nolines compress b(3)


*********** PANEL C *********** 

*** Q1 to Q1 effort ***

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 tools_d {
eststo: xi: reg `var'  q1_to_q1_effort `Controls'

}
esttab using temp_all_Q1_effort_PanelC.tex, replace fragment booktabs keep(q1_to_q1_effort) label /// 
nostar se nonumbers noobs nomtitles nolines compress b(3)

*** Q1 to Q5 effort ***

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 tools_d {
eststo: xi: reg `var'  q1_to_q5_effort `Controls'

}
esttab using temp_all_Q5_effort_PanelC.tex, replace fragment booktabs keep(q1_to_q5_effort) label /// 
nostar se nonumbers noobs nomtitles nolines compress b(3)


*********** PANEL D *********** 

*** Q1 to Q1 effort ***

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 tools_d {
eststo: xi: reg `var'  q1_to_q1_effort_left q1_to_q1_effort_right q1_to_q1_effort_center `Controls'
test q1_to_q1_effort_left= q1_to_q1_effort_right
local `var'_1e: display %5.3f `r(p)'
}
esttab using temp_all_Q1_effort_PanelD.tex, replace fragment booktabs keep(q1_to_q1_effort_left q1_to_q1_effort_right left right) label /// 
nostar se nonumbers noobs nomtitles nolines compress b(3)


*** Q1 to Q5 effort ***

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 tools_d {
eststo: xi: reg `var'  q1_to_q5_effort_left q1_to_q5_effort_right q1_to_q5_effort_center `Controls'
test q1_to_q5_effort_left= q1_to_q5_effort_right
local `var'_5e: display %5.3f `r(p)'
su q1_to_q5_effort_left if e(sample)==1
local `var'_oe : display %5.0f `r(N)'
}
esttab using temp_all_Q5_effort_PanelD.tex, replace fragment booktabs keep(q1_to_q5_effort_left q1_to_q5_effort_right left right) label /// 
nostar se nonumbers noobs nomtitles nolines compress b(3)


* Table 3: first part of the table
file open holder using temp_q1_header.tex, write replace text
file write holder " & & & & & & & & &  \\" _n
file write holder "\multicolumn{5}{l}{\textbf{\textit{A. Unconditional Beliefs}}} \\" _n
file close holder
file open holder using temp_q1_header_leftright.tex, write replace text
file write holder " & & & & & & & & &  \\" _n
file write holder "\multicolumn{5}{l}{\textbf{\textit{B. Unconditional Beliefs for Left and Right Wing}}} \\" _n
file close holder
file open holder using temp_q5_header_leftright.tex, write replace text
file write holder " & & & & & & & & & \\" _n
file write holder "p-value diff. & `budget_opp_1' & `support_estate_45_1' & `support_eq_opp_pol_1' & `government_intervention_1' & `unequal_opp_problem_d_1' &  `budget_safetynet_1' & `income_tax_top1_1' & `income_tax_bot50_1'  & `tools_d_1'  \\" _n
file write holder " & & & & & & & & & \\" _n
file close holder
file open holder using temp_end.tex, write replace text
file write holder " & & & & & & & & & \\" _n
file write holder "p-value diff. & `budget_opp_5' & `support_estate_45_5' & `support_eq_opp_pol_5' & `government_intervention_5' & `unequal_opp_problem_d_5' &  `budget_safetynet_5' & `income_tax_top1_5' & `income_tax_bot50_5'  & `tools_d_5'  \\" _n
file write holder "Observations & `budget_opp_o' & `support_estate_45_o' & `support_eq_opp_pol_o' & `government_intervention_o' & `unequal_opp_problem_d_o' &  `budget_safetynet_o' & `income_tax_top1_o' & `income_tax_bot50_o'  & `tools_d_o' \\" _n
file write holder "\hline \end{tabular}\end{center}" _n
file close holder

appendfile temp_q1_header.tex tab3_correlations_mobility_policy_first_part_male.tex
appendfile temp_all_Q1_PanelA.tex tab3_correlations_mobility_policy_first_part_male.tex
appendfile temp_all_Q5_PanelA.tex tab3_correlations_mobility_policy_first_part_male.tex
appendfile temp_q1_header_leftright.tex tab3_correlations_mobility_policy_first_part_male.tex
appendfile temp_all_Q1_PanelB.tex tab3_correlations_mobility_policy_first_part_male.tex
appendfile temp_q5_header_leftright.tex tab3_correlations_mobility_policy_first_part_male.tex
appendfile temp_all_Q5_PanelB.tex tab3_correlations_mobility_policy_first_part_male.tex
appendfile temp_end.tex tab3_correlations_mobility_policy_first_part_male.tex

* Table 3: second part of the table
file open holder using temp_q1_effort_header.tex, write replace text
file write holder " & & & & & & & & &  \\" _n
file write holder "\multicolumn{5}{l}{\textbf{\textit{C. Beliefs Conditional On Effort}}} \\" _n
file close holder
file open holder using temp_q1_effort_header_leftright.tex, write replace text
file write holder " & & & & & & & & &  \\" _n
file write holder "\multicolumn{5}{l}{\textbf{\textit{D. Beliefs Conditional On Effort for Left and Right Wing}}} \\" _n
file close holder
file open holder using temp_q5_effort_header_leftright.tex, write replace text
file write holder " & & & & & & & & & \\" _n
file write holder "p-value diff. & `budget_opp_1e' & `support_estate_45_1e' & `support_eq_opp_pol_1e' & `government_intervention_1e' & `unequal_opp_problem_d_1e' &  `budget_safetynet_1e' & `income_tax_top1_1e' & `income_tax_bot50_1e'  & `tools_d_1e'  \\" _n
file write holder " & & & & & & & & & \\" _n
file close holder
file open holder using temp_effort_end.tex, write replace text
file write holder " & & & & & & & & & \\" _n
file write holder "p-value diff. & `budget_opp_5e' & `support_estate_45_5e' & `support_eq_opp_pol_5e' & `government_intervention_5e' & `unequal_opp_problem_d_5e' &  `budget_safetynet_5e' & `income_tax_top1_5e' & `income_tax_bot50_5e'  & `tools_d_5e'  \\" _n
file write holder "Observations & `budget_opp_oe' & `support_estate_45_oe' & `support_eq_opp_pol_oe' & `government_intervention_oe' & `unequal_opp_problem_d_oe' &  `budget_safetynet_oe' & `income_tax_top1_oe' & `income_tax_bot50_oe'  & `tools_d_oe' \\" _n
file write holder "\hline \end{tabular}\end{center}" _n
file close holder

appendfile temp_q1_effort_header.tex tab3_correlations_mobility_policy_second_part_male.tex
appendfile temp_all_Q1_effort_PanelC.tex tab3_correlations_mobility_policy_second_part_male.tex
appendfile temp_all_Q5_effort_PanelC.tex tab3_correlations_mobility_policy_second_part_male.tex
appendfile temp_q1_effort_header_leftright.tex tab3_correlations_mobility_policy_second_part_male.tex
appendfile temp_all_Q1_effort_PanelD.tex tab3_correlations_mobility_policy_second_part_male.tex
appendfile temp_q5_effort_header_leftright.tex tab3_correlations_mobility_policy_second_part_male.tex
appendfile temp_all_Q5_effort_PanelD.tex tab3_correlations_mobility_policy_second_part_male.tex
appendfile temp_effort_end.tex tab3_correlations_mobility_policy_second_part_male.tex

erase temp_q1_header.tex
erase temp_all_Q1_PanelA.tex
erase temp_all_Q5_PanelA.tex
erase temp_q1_header_leftright.tex
erase temp_all_Q1_PanelB.tex
erase temp_q5_header_leftright.tex
erase temp_all_Q5_PanelB.tex
erase temp_end.tex
erase temp_q1_effort_header.tex
erase temp_all_Q1_effort_PanelC.tex
erase temp_all_Q5_effort_PanelC.tex
erase temp_q1_effort_header_leftright.tex
erase temp_all_Q1_effort_PanelD.tex
erase temp_q5_effort_header_leftright.tex
erase temp_all_Q5_effort_PanelD.tex
erase temp_effort_end.tex



* Test whether there is a significant difference between left and right across equations
/* Note: these tests use only the subset of observations common to all regressions, discarding missing */
local Controls "i.country_survey left right male young children_dummy rich university_degree immigrant moved_up"

* Q1 TO Q1
sureg (budget_opportunities  q1_to_q1_left q1_to_q1 q1_to_q1_center `Controls') ///
	  (support_estate_45  q1_to_q1_left q1_to_q1 q1_to_q1_center `Controls') ///
	  (support_eq_opp_pol  q1_to_q1_left q1_to_q1 q1_to_q1_center `Controls') ///
	  (government_intervention  q1_to_q1_left q1_to_q1 q1_to_q1_center `Controls') ///
	  (unequal_opp_problem_d  q1_to_q1_left q1_to_q1 q1_to_q1_center `Controls') ///
	  (budget_safetynet  q1_to_q1_left q1_to_q1 q1_to_q1_center `Controls') ///
	  (income_tax_top1  q1_to_q1_left q1_to_q1 q1_to_q1_center `Controls') ///
	  (income_tax_bot50  q1_to_q1_left q1_to_q1 q1_to_q1_center `Controls') ///
	  (tools_d  q1_to_q1_left q1_to_q1 q1_to_q1_center `Controls')

test [budget_opportunities]q1_to_q1_left [support_estate_45]q1_to_q1_left ///
[support_eq_opp_pol]q1_to_q1_left [government_intervention]q1_to_q1_left ///
[unequal_opp_problem_d]q1_to_q1_left [budget_safetynet]q1_to_q1_left ///
[income_tax_top1]q1_to_q1_left [income_tax_bot50]q1_to_q1_left ///	  
[tools_d]q1_to_q1_left
local q1_to_q1_test: display %5.3f `r(p)'

* Q1 TO Q5
sureg (budget_opportunities  q1_to_q5_left q1_to_q5 q1_to_q5_center `Controls') ///
	  (support_estate_45  q1_to_q5_left q1_to_q5 q1_to_q5_center `Controls') ///
	  (support_eq_opp_pol  q1_to_q5_left q1_to_q5 q1_to_q5_center `Controls') ///
	  (government_intervention  q1_to_q5_left q1_to_q5 q1_to_q5_center `Controls') ///
	  (unequal_opp_problem_d  q1_to_q5_left q1_to_q5 q1_to_q5_center `Controls') ///
	  (budget_safetynet  q1_to_q5_left q1_to_q5 q1_to_q5_center `Controls') ///
	  (income_tax_top1  q1_to_q5_left q1_to_q5 q1_to_q5_center `Controls') ///
	  (income_tax_bot50  q1_to_q5_left q1_to_q5 q1_to_q5_center `Controls') ///
	  (tools_d  q1_to_q5_left q1_to_q5 q1_to_q5_center `Controls')

test [budget_opportunities]q1_to_q5_left [support_estate_45]q1_to_q5_left ///
[support_eq_opp_pol]q1_to_q5_left [government_intervention]q1_to_q5_left ///
[unequal_opp_problem_d]q1_to_q5_left [budget_safetynet]q1_to_q5_left ///
[income_tax_top1]q1_to_q5_left [income_tax_bot50]q1_to_q5_left ///	  
[tools_d]q1_to_q5_left
local q1_to_q5_test: display %5.3f `r(p)'

* Q1 TO Q1 Effort
sureg (budget_opportunities  q1_to_q1_effort_left q1_to_q1_effort q1_to_q1_effort_center `Controls') ///
	  (support_estate_45  q1_to_q1_effort_left q1_to_q1_effort q1_to_q1_effort_center `Controls') ///
	  (support_eq_opp_pol  q1_to_q1_effort_left q1_to_q1_effort q1_to_q1_effort_center `Controls') ///
	  (government_intervention  q1_to_q1_effort_left q1_to_q1_effort q1_to_q1_effort_center `Controls') ///
	  (unequal_opp_problem_d  q1_to_q1_effort_left q1_to_q1_effort q1_to_q1_effort_center `Controls') ///
	  (budget_safetynet  q1_to_q1_effort_left q1_to_q1_effort q1_to_q1_effort_center `Controls') ///
	  (income_tax_top1  q1_to_q1_effort_left q1_to_q1_effort q1_to_q1_effort_center `Controls') ///
	  (income_tax_bot50  q1_to_q1_effort_left q1_to_q1_effort q1_to_q1_effort_center `Controls') ///
	  (tools_d  q1_to_q1_effort_left q1_to_q1_effort q1_to_q1_effort_center `Controls')

test [budget_opportunities]q1_to_q1_effort_left [support_estate_45]q1_to_q1_effort_left ///
[support_eq_opp_pol]q1_to_q1_effort_left [government_intervention]q1_to_q1_effort_left ///
[unequal_opp_problem_d]q1_to_q1_effort_left [budget_safetynet]q1_to_q1_effort_left ///
[income_tax_top1]q1_to_q1_effort_left [income_tax_bot50]q1_to_q1_effort_left ///	  
[tools_d]q1_to_q1_effort_left
local q1_to_q1_effort_test: display %5.3f `r(p)'

* Q1 TO Q5 Effort
sureg (budget_opportunities  q1_to_q5_effort_left q1_to_q5_effort q1_to_q5_effort_center `Controls') ///
	  (support_estate_45  q1_to_q5_effort_left q1_to_q5_effort q1_to_q5_effort_center `Controls') ///
	  (support_eq_opp_pol  q1_to_q5_effort_left q1_to_q5_effort q1_to_q5_effort_center `Controls') ///
	  (government_intervention  q1_to_q5_effort_left q1_to_q5_effort q1_to_q5_effort_center `Controls') ///
	  (unequal_opp_problem_d  q1_to_q5_effort_left q1_to_q5_effort q1_to_q5_effort_center `Controls') ///
	  (budget_safetynet  q1_to_q5_effort_left q1_to_q5_effort q1_to_q5_effort_center `Controls') ///
	  (income_tax_top1  q1_to_q5_effort_left q1_to_q5_effort q1_to_q5_effort_center `Controls') ///
	  (income_tax_bot50  q1_to_q5_effort_left q1_to_q5_effort q1_to_q5_effort_center `Controls') ///
	  (tools_d  q1_to_q5_effort_left q1_to_q5_effort q1_to_q5_effort_center `Controls')

test [budget_opportunities]q1_to_q5_effort_left [support_estate_45]q1_to_q5_effort_left ///
[support_eq_opp_pol]q1_to_q5_effort_left [government_intervention]q1_to_q5_effort_left ///
[unequal_opp_problem_d]q1_to_q5_effort_left [budget_safetynet]q1_to_q5_effort_left ///
[income_tax_top1]q1_to_q5_effort_left [income_tax_bot50]q1_to_q5_effort_left ///	  
[tools_d]q1_to_q5_effort_left
local q1_to_q5_effort_test: display %5.3f `r(p)'

disp `q1_to_q1_test'
disp `q1_to_q5_test'
disp `q1_to_q1_effort_test'
disp `q1_to_q5_effort_test'


		
		****** (rest of the do file

log close
