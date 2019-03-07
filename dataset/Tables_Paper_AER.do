

/*

INTERGENERATIONAL MOBILITY AND PREFERENCES FOR REDISTRIBUTION
ALESINA, STANTCHEVA, TESO 
AER

THIS DO FILE GENERATES ALL TABLES IN THE MAIN PART OF THE PAPER

*/

set more off

* set path here

**********************************************************************************
**********************************************************************************
***	TABLE 1:  SUMMARY STATISTICS OF THE SAMPLE					       	       *** 					
**********************************************************************************
**********************************************************************************	

* Open dataset
use "Data_Descriptive_Waves_ABC.dta", clear	

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* University dummy
gen university=0
replace university=1 if education>=6  & US==1
replace university=1 if education>=6 & UK==1
replace university=1 if education>=5 & Italy==1
replace university=1 if education>=7 & France==1
replace university=1 if education>=5 & Sweden==1 & wave=="September"
replace university=1 if education>=6 & Sweden==1 & wave=="February"
replace university=. if education==.

* Married dummy (=0 if "other")
replace married=0 if married==2

* Age brackets
gen age_1=(age>=18 & age<=29)
gen age_2=(age>=30 & age<=39)
gen age_3=(age>=40 & age<=49)
gen age_4=(age>=50 & age<=59)
gen age_5=(age>=60)

cap mata drop A

* Gender
foreach x in US UK France Italy Sweden {
su male if `x'==1
local male`x' : display %5.2f `r(mean)'
}
matrix A=(`maleUS', 0.48,`maleUK', 0.49,`maleFrance', 0.48,`maleItaly', 0.48,`maleSweden', 0.50)

* Age
foreach x in US UK France Italy Sweden {
su age_1 if `x'==1
local age_1`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`age_1US', 0.27,`age_1UK', 0.24,`age_1France', 0.21,`age_1Italy', 0.19,`age_1Sweden', 0.24)
matrix A=A\B
foreach x in US UK France Italy Sweden {
su age_2 if `x'==1
local age_2`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`age_2US', 0.19,`age_2UK', 0.20,`age_2France', 0.19,`age_2Italy', 0.21,`age_2Sweden', 0.19)
matrix A=A\B
foreach x in US UK France Italy Sweden {
su age_3 if `x'==1
local age_3`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`age_3US', 0.21,`age_3UK', 0.21,`age_3France', 0.20,`age_3Italy', 0.24,`age_3Sweden', 0.21)
matrix A=A\B
foreach x in US UK France Italy Sweden {
su age_4 if `x'==1
local age_4`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`age_4US', 0.20,`age_4UK', 0.20,`age_4France', 0.20,`age_4Italy', 0.20,`age_4Sweden', 0.18)
matrix A=A\B
foreach x in US UK France Italy Sweden {
su age_5 if `x'==1
local age_5`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`age_5US', 0.14,`age_5UK', 0.16,`age_5France', 0.19,`age_5Italy', 0.17,`age_5Sweden', 0.18)
matrix A=A\B

* Income
foreach x in US UK France Italy Sweden {
su inc_bracket_1 if `x'==1
local inc_bracket_1`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`inc_bracket_1US', 0.18,`inc_bracket_1UK', 0.31,`inc_bracket_1France', 0.32,`inc_bracket_1Italy', 0.27,`inc_bracket_1Sweden', 0.33)
matrix A=A\B
foreach x in US UK France Italy Sweden {
su inc_bracket_2 if `x'==1
local inc_bracket_2`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`inc_bracket_2US', 0.20,`inc_bracket_2UK', 0.35,`inc_bracket_2France', 0.30,`inc_bracket_2Italy', 0.28,`inc_bracket_2Sweden', 0.29)
matrix A=A\B
foreach x in US UK France Italy Sweden {
su inc_bracket_3 if `x'==1
local inc_bracket_3`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`inc_bracket_3US', 0.22,`inc_bracket_3UK', 0.11,`inc_bracket_3France', 0.14,`inc_bracket_3Italy', 0.19,`inc_bracket_3Sweden', 0.22)
matrix A=A\B
foreach x in US UK France Italy Sweden {
su inc_bracket_4 if `x'==1
local inc_bracket_4`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`inc_bracket_4US', 0.39,`inc_bracket_4UK', 0.23,`inc_bracket_4France', 0.24,`inc_bracket_4Italy', 0.26,`inc_bracket_4Sweden', 0.17)
matrix A=A\B


* Married
foreach x in US UK France Italy Sweden {
su married if `x'==1
local married`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`marriedUS', 0.49,`marriedUK', 0.41,`marriedFrance', 0.46,`marriedItaly', 0.46,`marriedSweden', 0.33)
matrix A=A\B

* Native
foreach x in US UK France Italy Sweden {
su born_in_country if `x'==1
local born_in_country`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`born_in_countryUS', 0.85,`born_in_countryUK', 0.87,`born_in_countryFrance', 0.85,`born_in_countryItaly', 0.92,`born_in_countrySweden', 0.82)
matrix A=A\B

* Employed
foreach x in US UK France Italy Sweden {
su employed if `x'==1
local employed`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`employedUS', 0.58,`employedUK', 0.61,`employedFrance', 0.47,`employedItaly', 0.45,`employedSweden', 0.67)
matrix A=A\B

* Unemployed
foreach x in US UK France Italy Sweden {
su unemployed if `x'==1
local unemployed`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`unemployedUS', 0.08,`unemployedUK', 0.03,`unemployedFrance', 0.05,`unemployedItaly', 0.06,`unemployedSweden', 0.05)
matrix A=A\B

* University degree
foreach x in US UK France Italy Sweden {
su university if `x'==1
local university`x' : display %5.2f `r(mean)'
}
cap mata drop B
matrix B=(`universityUS', 0.28,`universityUK', 0.42,`universityFrance', 0.25,`universityItaly', 0.15,`universitySweden', 0.36)
matrix A=A\B


mat rownames A=male age_1 age_2 age_3 age_4 age_5 inc_bracket_1 inc_bracket_2 inc_bracket_3 inc_bracket_4 married born_in_country employed unemployed university
frmttable using summary_stats_sample_by_country, statmat(A) tex fragment replace  center ///
		ctitle("",US,"", UK,"", France,"", Italy,"", Sweden,""\"", Sample, Pop, Sample, Pop,Sample, Pop,Sample, Pop,Sample, Pop\"", "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)", "(8)", "(9)", "(10)") ///
		rtitle(Male\ 18-29 y.o.\30-39 y.o.\40-49 y.o.\50-59 y.o.\60-69 y.o.\Income Bracket 1 \Income Bracket 2 \Income Bracket 3 \Income Bracket 4\ Married\ Native\ Employed\ Unemployed\ College) ///
		multicol(1,2,2;1,4,2;1,6,2;1,8,2;1,10,2) hlines(1101000000000000001)
	


**********************************************************************************
**********************************************************************************
***	TABLE 2:  REAL AND PERCEIVED TRANSITION PROBABILITIES					   *** 					
**********************************************************************************
**********************************************************************************	

set more off

* Open dataset
use "Data_Descriptive_Waves_ABC.dta", clear	

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Only control group
keep if Treated==0

* Table Panel A
file open holder using table_mobility_summ.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lccccccccccccccccc} " _n
file write holder " & \multicolumn{2}{c}{\textbf{US}} & & \multicolumn{2}{c}{\textbf{UK}} & & \multicolumn{2}{c}{\textbf{France}} & & \multicolumn{2}{c}{\textbf{Italy}} & & \multicolumn{2}{c}{\textbf{Sweden}} & & \multicolumn{2}{c}{\textbf{US vs EU}} \\" _n
file write holder " \cline{2-3} \cline{5-6} \cline{8-9} \cline{11-12} \cline{14-15} \cline{17-18} " _n
file write holder " & Actual & Perceived & & Actual & Perceived & & Actual & Perceived & & Actual & Perceived & & Actual & Perceived & & Perceived US & Perceived EU \\ " _n
file write holder "& (1) & (2) & & (3) & (4) & & (5) & (6) & & (7) & (8) & & (9) & (10) & & (11) & (12) \\" _n
file close holder

forvalues q=1(1)5 {
label var q1_to_q`q' "Q1 to Q`q'"
}

* Panel A

cap mata drop A
cap mata drop C

su q1_to_q5 if US==1
local q5_US : display %5.2f `r(mean)'
su q1_to_q5 if US!=1
local q5_EU : display %5.2f `r(mean)'
su q1_to_q5 if UK==1
local q5_UK : display %5.2f `r(mean)'
su q1_to_q5 if France==1
local q5_France : display %5.2f `r(mean)'
su q1_to_q5 if Italy==1
local q5_Italy : display %5.2f `r(mean)'
su q1_to_q5 if Sweden==1
local q5_Sweden : display %5.2f `r(mean)'

su true_q1_to_q5 if US==1
local q5_US_true : display %5.2f `r(mean)'
su true_q1_to_q5 if UK==1
local q5_UK_true : display %5.2f `r(mean)'
su true_q1_to_q5 if France==1
local q5_France_true : display %5.2f `r(mean)'
su true_q1_to_q5 if Italy==1
local q5_Italy_true : display %5.2f `r(mean)'
su true_q1_to_q5 if Sweden==1
local q5_Sweden_true : display %5.2f `r(mean)'

ttest q1_to_q5== `q5_US_true' if US==1
local p_US: display %5.4f `r(p)'
ttest q1_to_q5== `q5_UK_true' if UK==1
local p_UK: display %5.4f `r(p)'
ttest q1_to_q5== `q5_France_true' if France==1
local p_France: display %5.4f `r(p)'
ttest q1_to_q5== `q5_Italy_true' if Italy==1
local p_Italy: display %5.4f `r(p)'
ttest q1_to_q5== `q5_Sweden_true' if Sweden==1
local p_Sweden: display %5.4f `r(p)'
ttest q1_to_q5 , by(US)
local p_USvEU: display %5.4f `r(p)'

cap mata drop A
matrix A=(`q5_US_true',`q5_US',.,`q5_UK_true',`q5_UK',.,`q5_France_true',`q5_France',.,`q5_Italy_true',`q5_Italy',.,`q5_Sweden_true',`q5_Sweden',.,`q5_US',`q5_EU')
cap mata drop B
matrix B=(.,`p_US',.,.,`p_UK',.,.,`p_France',.,.,`p_Italy',.,.,`p_Sweden',.,.,`p_USvEU')
matrix A=A\B 

foreach i in 4 3 2 1 {

su q1_to_q`i' if US==1
local q`i'_US : display %5.2f `r(mean)'
su q1_to_q`i' if US!=1
local q`i'_EU : display %5.2f `r(mean)'
su q1_to_q`i' if UK==1
local q`i'_UK : display %5.2f `r(mean)'
su q1_to_q`i' if France==1
local q`i'_France : display %5.2f `r(mean)'
su q1_to_q`i' if Italy==1
local q`i'_Italy : display %5.2f `r(mean)'
su q1_to_q`i' if Sweden==1
local q`i'_Sweden : display %5.2f `r(mean)'

su true_q1_to_q`i' if US==1
local q`i'_US_true : display %5.2f `r(mean)'
su true_q1_to_q`i' if UK==1
local q`i'_UK_true : display %5.2f `r(mean)'
su true_q1_to_q`i' if France==1
local q`i'_France_true : display %5.2f `r(mean)'
su true_q1_to_q`i' if Italy==1
local q`i'_Italy_true : display %5.2f `r(mean)'
su true_q1_to_q`i' if Sweden==1
local q`i'_Sweden_true : display %5.2f `r(mean)'

ttest q1_to_q`i'== `q`i'_US_true' if US==1
local p_US`i': display %5.4f `r(p)'
ttest q1_to_q`i'== `q`i'_UK_true' if UK==1
local p_UK`i': display %5.4f `r(p)'
ttest q1_to_q`i'== `q`i'_France_true' if France==1
local p_France`i': display %5.4f `r(p)'
ttest q1_to_q`i'== `q`i'_Italy_true' if Italy==1
local p_Italy`i': display %5.4f `r(p)'
ttest q1_to_q`i'== `q`i'_Sweden_true' if Sweden==1
local p_Sweden`i': display %5.4f `r(p)'
ttest q1_to_q`i' , by(US)
local p_USvEU`i': display %5.4f `r(p)'

cap mata drop A`i'
matrix A`i'=(`q`i'_US_true',`q`i'_US',.,`q`i'_UK_true',`q`i'_UK',.,`q`i'_France_true',`q`i'_France',.,`q`i'_Italy_true',`q`i'_Italy',.,`q`i'_Sweden_true',`q`i'_Sweden',.,`q`i'_US',`q`i'_EU')
matrix A=A\A`i'
cap mata drop B`i'
matrix B`i'=(.,`p_US`i'',.,.,`p_UK`i'',.,.,`p_France`i'',.,.,`p_Italy`i'',.,.,`p_Sweden`i'',.,.,`p_USvEU`i'')
matrix A=A\B`i' 
}

su q1_to_q5 if US==1
local obs_US : display %5.0f `r(N)'
su q1_to_q5 if UK==1
local obs_UK : display %5.0f `r(N)'
su q1_to_q5 if France==1
local obs_France : display %5.0f `r(N)'
su q1_to_q5 if Italy==1
local obs_Italy : display %5.0f `r(N)'
su q1_to_q5 if Sweden==1
local obs_Sweden : display %5.0f `r(N)'
su q1_to_q5 if US==0
local obs_EU : display %5.0f `r(N)'
cap mata drop C
matrix C=(.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.)
matrix A=A\C
cap mata drop C
matrix C=(.,int(`obs_US'),.,., int(`obs_UK'),.,., int(`obs_France'),.,., int(`obs_Italy'),.,., int(`obs_Sweden'),.,int(`obs_US'),int(`obs_EU'))
matrix A=A\C

* P-value from Joint Test for perceptions vs reality
matrix real_US = (33.1,27.7,18.7,12.7,7.8)
matrix real_UK = (30.63,25.09,19.93,12.92,11.44)
matrix real_France = (29.2,23.8,23,12.8,11.2)
matrix real_Italy = (27.27,25.78,21,15.55,10.42)
matrix real_Sweden = (26.7,23.8,21,17.3,11.1)
foreach x in US UK France Italy Sweden {
 mvtest means q1_to_q1 q1_to_q2 q1_to_q3 q1_to_q4 q1_to_q5 if `x'==1, equals(real_`x')
 local p_real_`x' = r(p_F) 
}

* P-value from Joint Test for US vs Europe
replace q1_to_q1=-q1_to_q1 /* turn sign so that higher numbers means optimism */
forvalues q=1(1)5 {
reg q1_to_q`q' US
estimates store Var`q'
qui su q1_to_q`q' if US==1
local sd`q' = r(sd)
}
#delimit ;
		suest Var1 Var2 Var3 Var4 Var5;		
		lincom ((
		[Var1_mean]US/`sd1' + [Var2_mean]US/`sd2' + 
		[Var3_mean]US/`sd3' + [Var4_mean]US/`sd4' + 
		[Var5_mean]US/`sd5')/ 5);
#delimit cr
		
#delimit ;
		test  ((
		[Var1_mean]US/`sd1' + [Var2_mean]US/`sd2' + 
		[Var3_mean]US/`sd3' + [Var4_mean]US/`sd4' + 
		[Var5_mean]US/`sd5')/ 5)=0;
#delimit cr
		
		local p = r(p)

		
cap mata drop C
matrix C=(.,`p_real_US',.,., `p_real_UK',.,., `p_real_France',.,., `p_real_Italy',.,., `p_real_Sweden',.,.,`p')
matrix A=A\C		
		
frmttable using table_perceived_probs_panel, statmat(A) tex fragment  nocoltitl replace sdec(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2) center ///
		rtitle(Q1 to Q5\""\Q1 to Q4\""\Q1 to Q3\""\Q1 to Q2\""\Q1 to Q1\""\""\Observations\P-value from Joint Test)



**********************************************************************************
**********************************************************************************
***	TABLE 3:  PESSIMISM AND OPTIMISM CORRELATED WITH POLICIES       	       *** 					
**********************************************************************************
**********************************************************************************		
	
set more off

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
file open holder using table_correlations_mobility_policy_first_part.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lccccccccc} " _n
file write holder "&   & & Support & & Unequal Opp. & &  &  & \\" _n
file write holder "& Budget & Support & Equality & Government & Very Serious & Budget & Tax Rate & Tax Rate & Govt. \\" _n
file write holder "& Opp. & Estate Tax & Opp. Policies & Interv. & Problem & Safety Net & Top 1 & Bottom 50 & Tools \\" _n
file write holder "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) \\ \hline" _n
file close holder
file open holder using table_correlations_mobility_policy_second_part.tex, write replace text
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

appendfile temp_q1_header.tex table_correlations_mobility_policy_first_part.tex
appendfile temp_all_Q1_PanelA.tex table_correlations_mobility_policy_first_part.tex
appendfile temp_all_Q5_PanelA.tex table_correlations_mobility_policy_first_part.tex
appendfile temp_q1_header_leftright.tex table_correlations_mobility_policy_first_part.tex
appendfile temp_all_Q1_PanelB.tex table_correlations_mobility_policy_first_part.tex
appendfile temp_q5_header_leftright.tex table_correlations_mobility_policy_first_part.tex
appendfile temp_all_Q5_PanelB.tex table_correlations_mobility_policy_first_part.tex
appendfile temp_end.tex table_correlations_mobility_policy_first_part.tex

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

appendfile temp_q1_effort_header.tex table_correlations_mobility_policy_second_part.tex
appendfile temp_all_Q1_effort_PanelC.tex table_correlations_mobility_policy_second_part.tex
appendfile temp_all_Q5_effort_PanelC.tex table_correlations_mobility_policy_second_part.tex
appendfile temp_q1_effort_header_leftright.tex table_correlations_mobility_policy_second_part.tex
appendfile temp_all_Q1_effort_PanelD.tex table_correlations_mobility_policy_second_part.tex
appendfile temp_q5_effort_header_leftright.tex table_correlations_mobility_policy_second_part.tex
appendfile temp_all_Q5_effort_PanelD.tex table_correlations_mobility_policy_second_part.tex
appendfile temp_effort_end.tex table_correlations_mobility_policy_second_part.tex

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



**********************************************************************************
**********************************************************************************
***	TABLE 4: FIRST STAGE OF THE TREATMENT								       *** 					
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

gen american_dream_alive=(american_dream>=4)
replace american_dream_alive=. if american_dream==.
   
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

* Label variables
label var Treated_left "Treated $\times$ Left-Wing"
label var Treated_right "Treated $\times$ Right-Wing"
label var Treated "Treated"
label var left "Left-Wing" 
label var right "Right-Wing"


* Table start
file open holder using table_firststage.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lcccccccc} " _n
file write holder "& Q1 to & Q1 to & Q1 to & Q1 to & Q1 to & Q1 to & Q1 to & American Dream \\" _n
file write holder "& Q1 & Q2 & Q3 & Q4 & Q5 & Q4 (Qual.) & Q5 (Qual.) & Alive \\" _n
file write holder "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) \\ \hline" _n
file close holder
* Table end
file open holder using temp_end.tex, write replace text
file write holder "\hline \end{tabular}\end{center}" _n
file close holder

local Controls "i.country_survey left right male young children_dummy rich university_degree immigrant moved_up"

* Panel A: Unconditional beliefs

eststo clear
	
foreach var in q1_to_q1 q1_to_q2 q1_to_q3 q1_to_q4 q1_to_q5 low_to_middle_prob low_to_high_prob american_dream_alive {
eststo: xi: reg `var' Treated `Controls'
}
esttab using temp_results_unc_PanelA.tex, replace fragment booktabs keep(Treated) label /// 
nostar se nonumbers nomtitles nolines compress noobs b(3)

* Panel B: Unconditional beliefs left vs right-wing

eststo clear
	
foreach var in q1_to_q1 q1_to_q2 q1_to_q3 q1_to_q4 q1_to_q5 low_to_middle_prob low_to_high_prob american_dream_alive {
eststo: xi: reg `var' Treated_left Treated_right Treated_center `Controls'
test Treated_left= Treated_right
local `var'_t: display %5.3f `r(p)'
su Treated_left if e(sample)==1
local `var'_o : display %5.0f `r(N)'
}
esttab using temp_results_unc_PanelB.tex, replace fragment booktabs keep(Treated_left Treated_right left right) label /// 
nostar se nonumbers nomtitles nolines compress noobs b(3)

* Panel C: conditional on effort

eststo clear
	
foreach var in q1_to_q1_effort q1_to_q2_effort q1_to_q3_effort q1_to_q4_effort q1_to_q5_effort low_to_middle_prob_effort low_to_high_prob_effort {
eststo: xi: reg `var' Treated `Controls'
}
esttab using temp_results_cond_PanelC.tex, replace fragment booktabs keep(Treated) label /// 
nostar se nonumbers nomtitles nolines compress noobs b(3)
			
* Panel D: conditional on effort left vs right-wing

eststo clear
	
foreach var in q1_to_q1_effort q1_to_q2_effort q1_to_q3_effort q1_to_q4_effort q1_to_q5_effort low_to_middle_prob_effort low_to_high_prob_effort {
eststo: xi: reg `var' Treated_left Treated_right Treated_center `Controls'
test Treated_left= Treated_right
local `var'_t: display %5.3f `r(p)'
su Treated_left if e(sample)==1
local `var'_o : display %5.0f `r(N)'
}
esttab using temp_results_cond_PanelD.tex, replace fragment booktabs keep(Treated_left Treated_right left right) label /// 
nostar se nonumbers nomtitles nolines compress noobs b(3)
		
		
* Table headers
file open holder using temp_unc_header_PanelA.tex, write replace text
file write holder "\multicolumn{5}{l}{\textbf{\textit{A. Unconditional Beliefs}}} \\" _n
file close holder
file open holder using temp_unc_header_PanelB.tex, write replace text
file write holder " & & & & & & & &  \\" _n
file write holder "\multicolumn{5}{l}{\textbf{\textit{B. Unconditional Beliefs for Left and Right Wing}}} \\" _n
file close holder
file open holder using temp_cond_header_PanelC.tex, write replace text
file write holder " & & & & & & & &  \\" _n
file write holder "p-value diff. & `q1_to_q1_t' & `q1_to_q2_t' & `q1_to_q3_t' & `q1_to_q4_t' & `q1_to_q5_t' & `low_to_middle_prob_t' & `low_to_high_prob_t' & `american_dream_alive_t' \\" _n
file write holder "Observations & `q1_to_q1_o' & `q1_to_q2_o' & `q1_to_q3_o' & `q1_to_q4_o' & `q1_to_q5_o' & `low_to_middle_prob_o' & `low_to_high_prob_o' & `american_dream_alive_o' \\" _n
file write holder " & & & & & & & &  \\" _n
file write holder " & & & & & & & &  \\" _n
file write holder "\multicolumn{5}{l}{\textbf{\textit{C. Beliefs Conditional On Effort}}} \\" _n
file close holder
file open holder using temp_cond_header_PanelD.tex, write replace text
file write holder " & & & & & & & &  \\" _n
file write holder "\multicolumn{5}{l}{\textbf{\textit{D. Beliefs Conditional On Effort for Left and Right Wing}}} \\" _n
file close holder
file open holder using temp_end.tex, write replace text
file write holder " & & & & & & & &  \\" _n
file write holder "p-value diff. & `q1_to_q1_effort_t' & `q1_to_q2_effort_t' & `q1_to_q3_effort_t' & `q1_to_q4_effort_t' & `q1_to_q5_effort_t' & `low_to_middle_prob_effort_t' & `low_to_high_prob_effort_t' &  \\" _n
file write holder "Observations & `q1_to_q1_effort_o' & `q1_to_q2_effort_o' & `q1_to_q3_effort_o' & `q1_to_q4_effort_o' & `q1_to_q5_effort_o' & `low_to_middle_prob_effort_o' & `low_to_high_prob_effort_o' &  \\" _n
file write holder "\hline \end{tabular}\end{center}" _n
file close holder	

appendfile temp_unc_header_PanelA.tex table_firststage.tex
appendfile temp_results_unc_PanelA.tex table_firststage.tex
appendfile temp_unc_header_PanelB.tex table_firststage.tex
appendfile temp_results_unc_PanelB.tex table_firststage.tex
appendfile temp_cond_header_PanelC.tex table_firststage.tex
appendfile temp_results_cond_PanelC.tex table_firststage.tex
appendfile temp_cond_header_PanelD.tex table_firststage.tex
appendfile temp_results_cond_PanelD.tex table_firststage.tex
appendfile temp_end.tex table_firststage.tex

erase temp_end.tex
erase temp_unc_header_PanelA.tex
erase temp_results_unc_PanelA.tex
erase temp_unc_header_PanelB.tex
erase temp_results_unc_PanelB.tex
erase temp_cond_header_PanelC.tex
erase temp_results_cond_PanelC.tex
erase temp_cond_header_PanelD.tex
erase temp_results_cond_PanelD.tex

**********************************************************************************
**********************************************************************************
***	TABLE 5: PERSISTENCE OF FIRST STAGE EFFECTS	      						   *** 					
**********************************************************************************
**********************************************************************************		
		
set more off

* In case it is not installed already
ssc install appendfile

* Open dataset
use "Data_Experiment_Waves_BC.dta", clear

* Keep US
keep if US==1

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0


* Left and right
gen left=(ideology_economic ==1 | ideology_economic ==2)
replace left=. if ideology_economic==.
gen right=(ideology_economic ==4 | ideology_economic ==5)
replace right=. if ideology_economic==.
gen center=(ideology_economic==3)
replace center=. if ideology_economic==.

* for consistency drop cases of 100 in quintile other than Q1 in the follow-up (results not affected)
replace complete_fu=0 if flag_fu==1
   
*Rich
gen rich=0
foreach x in US {
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

******** TABLE ALL RESPONDENTS ********


local Controls "i.round left right center male young children_dummy rich university_degree immigrant moved_up"

foreach var in q1_to_q1 q1_to_q2 q1_to_q3 q1_to_q4 q1_to_q5 low_to_middle_prob  {

eststo clear

preserve
keep if flag_1==0 & flag_2==0 
eststo: xi: reg `var' Treated `Controls'
su `var' if Treated==0 & e(sample)==1
estadd scalar m`var' = `r(mean)'
restore

preserve
keep if flag_1==0 & flag_2==0 
eststo: xi: reg `var' Treated `Controls' if complete_fu==1
su `var' if Treated==0 & e(sample)==1
estadd scalar m`var' = `r(mean)'
restore

preserve
keep if flag_1==0 & flag_2==0 
eststo: xi: reg `var'_fu Treated `Controls' if complete_fu==1
su `var' if Treated==0 & e(sample)==1
estadd scalar m`var' = `r(mean)'
restore

esttab using temp_`var'.tex, replace fragment booktabs keep(Treated) label /// 
nostar se nonumbers nomtitles nolines noobs compress b(3)

}

eststo clear

preserve
keep if flag_1==0 & flag_2==0 
eststo: xi: reg low_to_high_prob Treated `Controls'
su low_to_high_prob if Treated==0 & e(sample)==1 
estadd scalar mlow_to_high_prob = `r(mean)'
restore

preserve
keep if flag_1==0 & flag_2==0 
eststo: xi: reg low_to_high_prob Treated `Controls' if complete_fu==1
su low_to_high_prob if Treated==0 & e(sample)==1
estadd scalar mlow_to_high_prob = `r(mean)'
restore

preserve
keep if flag_1==0 & flag_2==0 
eststo: xi: reg low_to_high_prob_fu Treated `Controls' if complete_fu==1
su low_to_high_prob_fu if Treated==0 & e(sample)==1
estadd scalar mlow_to_high_prob = `r(mean)'
restore

esttab using temp_low_to_high_prob.tex, replace fragment booktabs keep(Treated) label /// 
nostar se nonumbers nomtitles nolines compress stats(N, label("Obs.") fmt(0)) b(3)


* Table start
file open holder using table_firststage_follow_up.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lccc} " _n
file write holder "& First Survey & First Survey & Follow up \\" _n
file write holder "& All Respondents & Who Took Follow Up & Respondents  \\" _n
file write holder "& (1) & (2) & (3)  \\ \hline" _n
file close holder
* Table end
file open holder using temp_end.tex, write replace text
file write holder "\hline \end{tabular}\end{center} " _n
file close holder
* Headers
file open holder using temp_header_q1_to_q1.tex, write replace text
file write holder "\addlinespace \multicolumn{3}{l}{\textbf{\textit{Q1 to Q1}}} \\" _n
file close holder
file open holder using temp_header_q1_to_q2.tex, write replace text
file write holder "\addlinespace \multicolumn{3}{l}{\textbf{\textit{Q1 to Q2}}} \\" _n
file close holder
file open holder using temp_header_q1_to_q3.tex, write replace text
file write holder "\addlinespace \multicolumn{3}{l}{\textbf{\textit{Q1 to Q3}}} \\" _n
file close holder
file open holder using temp_header_q1_to_q4.tex, write replace text
file write holder "\addlinespace \multicolumn{3}{l}{\textbf{\textit{Q1 to Q4}}} \\" _n
file close holder
file open holder using temp_header_q1_to_q5.tex, write replace text
file write holder "\addlinespace \multicolumn{3}{l}{\textbf{\textit{Q1 to Q5}}} \\" _n
file close holder
file open holder using temp_header_low_to_middle_prob.tex, write replace text
file write holder "\addlinespace \multicolumn{3}{l}{\textbf{\textit{Q1 to Q4 (Qual.)}}} \\" _n
file close holder
file open holder using temp_header_low_to_high_prob.tex, write replace text
file write holder "\addlinespace \multicolumn{3}{l}{\textbf{\textit{Q1 to Q5 (Qual.)}}} \\" _n
file close holder


foreach var in q1_to_q1 q1_to_q2 q1_to_q3 q1_to_q4 q1_to_q5 low_to_middle_prob low_to_high_prob {
appendfile temp_header_`var'.tex table_firststage_follow_up.tex
appendfile temp_`var'.tex table_firststage_follow_up.tex
}
appendfile temp_end.tex table_firststage_follow_up.tex

erase temp_end.tex
foreach var in q1_to_q1 q1_to_q2 q1_to_q3 q1_to_q4 q1_to_q5 low_to_middle_prob low_to_high_prob {
erase temp_`var'.tex
erase temp_header_`var'.tex
}

**********************************************************************************
**********************************************************************************
***	TABLE 6:  TREATMENT EFFECTS ON POLICY PREFERENCES			       	       *** 					
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
gen q1_to_q1_`x'=q1_to_q1*`x'
}

* Generate redistribution index
/*
The index is an equally weighted sum of the 9 outcomes, after having changed the sign
of income tax to bottom 50, so that higher values means less taxes to the bottom 50%
and so more redistribution.
If a respondent has a valid response to at least one outcome that goes into the index,
then any missing values for other outcomes are imputed at the control group mean
for respondents in the control group, and at the treated group mean for respondents in
the treatment group. 
*/
gen income_tax_bot50_alt=-income_tax_bot50
replace income_tax_bot50_alt=. if income_tax_bot50==.
local Controls "i.country_survey left right male young children_dummy rich university_degree immigrant moved_up"
foreach var in budget_opportunities support_estate_45 support_eq_opp_pol government_intervention budget_safetynet income_tax_top1 income_tax_bot50_alt {
xi: reg `var' Treated `Controls'
su `var' if e(sample)==1 & Treated==0
local `var'mc: display %5.3f `r(mean)'
su `var' if e(sample)==1 & Treated==0
local `var'sdc: display %5.3f `r(sd)'
su `var' if e(sample)==1 & Treated==1
local `var'mt: display %5.3f `r(mean)'
gen `var'_ind=(`var'-``var'mc')/``var'sdc'
replace `var'_ind=(``var'mc'-``var'mc')/``var'sdc' if `var'==. & Treated==0
replace `var'_ind=(``var'mt'-``var'mc')/``var'sdc' if `var'==. & Treated==1
}
local Controls "i.country_survey left right male young children_dummy rich university_degree immigrant moved_up"
foreach var in unequal_opp_problem_d tools_d {
xi: reg `var' Treated `Controls' if channels_before_ladder==0
su `var' if e(sample)==1 & Treated==0
local `var'mc: display %5.3f `r(mean)'
su `var' if e(sample)==1 & Treated==0
local `var'sdc: display %5.3f `r(sd)'
su `var' if e(sample)==1 & Treated==1
local `var'mt: display %5.3f `r(mean)'
gen `var'_ind=(`var'-``var'mc')/``var'sdc'
replace `var'_ind=(``var'mc'-``var'mc')/``var'sdc' if `var'==. & Treated==0
replace `var'_ind=(``var'mc'-``var'mc')/``var'sdc' if channels_before_ladder==1 & Treated==0
replace `var'_ind=(``var'mt'-``var'mc')/``var'sdc' if `var'==. & Treated==1
replace `var'_ind=(``var'mt'-``var'mc')/``var'sdc' if channels_before_ladder==1 & Treated==1
}
gen index_redistribution=(budget_opportunities_ind + support_estate_45_ind + support_eq_opp_pol_ind + ///
							government_intervention_ind + budget_safetynet_ind + income_tax_top1_ind + ///
							income_tax_bot50_alt_ind + unequal_opp_problem_d_ind + tools_d_ind)/9
				
drop income_tax_bot50_alt budget_opportunities_ind support_estate_45_ind support_eq_opp_pol_ind government_intervention_ind budget_safetynet_ind income_tax_top1_ind income_tax_bot50_alt_ind unequal_opp_problem_d_ind tools_d_ind

* Label variables
label var Treated_left "Treated X Left-Wing"
label var Treated_right "Treated X Right-Wing"
label var Treated "Treated"
label var q1_to_q1_left "Q1 to Q1 X Left-Wing"
label var q1_to_q1_right "Q1 to Q1 X Right-Wing"
label var q1_to_q1 "Q1 to Q1"
label var left "Left-Wing" 
label var right "Right-Wing"

* Table start
file open holder using table_treatment_effects.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lcccccccccc} " _n
file write holder "&   & & Support & & Unequal Opp. & &  &  & & \\" _n
file write holder "& Budget & Support & Equality & Government & Very Serious & Budget & Tax Rate & Tax Rate & Govt. & Redistribution \\" _n
file write holder "& Opp. & Estate Tax & Opp. Policies & Interv. & Problem & Safety Net & Top 1 & Bottom 50 & Tools & Index \\" _n
file write holder "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) & (10) \\ \hline" _n
file close holder

local Controls "i.country_survey left right male young children_dummy rich university_degree immigrant moved_up"

*** Panel A: Reduced Form

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention {
eststo: xi: reg `var' Treated `Controls'
}
 
eststo: xi: reg unequal_opp_problem_d Treated `Controls' if channels_before_ladder==0

foreach var in budget_safetynet income_tax_top1 income_tax_bot50 {
eststo: xi: reg `var' Treated `Controls'
}

eststo: xi: reg tools_d Treated `Controls' if channels_before_ladder==0

eststo: xi: reg index_redistribution Treated `Controls'

esttab using temp_reduced_PanelA.tex, replace fragment booktabs keep(Treated) label /// 
nostar se nonumbers nomtitles nolines compress noobs b(3)

*** Panel B: Reduced Form Left vs Right

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention {
eststo: xi: reg `var' Treated_left Treated_right Treated_center `Controls'
test Treated_left= Treated_right
local `var'_te: display %5.3f `r(p)'
su Treated_left if e(sample)==1
local `var'_ote : display %5.0f `r(N)'
}
 
eststo: xi: reg unequal_opp_problem_d Treated_left Treated_right Treated_center `Controls' if channels_before_ladder==0
test Treated_left= Treated_right
local unequal_opp_problem_d_te: display %5.3f `r(p)'
su Treated_left if e(sample)==1
local unequal_opp_problem_d_ote : display %5.0f `r(N)'

foreach var in budget_safetynet income_tax_top1 income_tax_bot50 {
eststo: xi: reg `var' Treated_left Treated_right Treated_center `Controls'
test Treated_left= Treated_right
local `var'_te: display %5.3f `r(p)'
su Treated_left if e(sample)==1
local `var'_ote : display %5.0f `r(N)'
}

eststo: xi: reg tools_d Treated_left Treated_right Treated_center `Controls' if channels_before_ladder==0
test Treated_left= Treated_right
local tools_d_te: display %5.3f `r(p)'
su Treated_left if e(sample)==1
local tools_d_ote : display %5.0f `r(N)'

eststo: xi: reg index_redistribution Treated_left Treated_right Treated_center `Controls'
test Treated_left= Treated_right
local index_redistribution_te: display %5.3f `r(p)'
su Treated_left if e(sample)==1
local index_redistribution_ote : display %5.0f `r(N)'

esttab using temp_reduced_PanelB.tex, replace fragment booktabs keep(Treated_left Treated_right left right) label /// 
nostar se nonumbers nomtitles nolines compress noobs b(3)


*** Panel C: IV

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention {
eststo: xi: ivreg `var' (q1_to_q1 = Treated) `Controls'
}

eststo: xi: ivreg unequal_opp_problem_d (q1_to_q1 = Treated) `Controls' if channels_before_ladder==0

foreach var in budget_safetynet income_tax_top1 income_tax_bot50 {
eststo: xi: ivreg `var' (q1_to_q1 = Treated) `Controls'
}

eststo: xi: ivreg tools_d (q1_to_q1 = Treated) `Controls' if channels_before_ladder==0

eststo: xi: ivreg index_redistribution (q1_to_q1 = Treated) `Controls'


esttab using temp_IV_PanelC.tex, replace fragment booktabs keep(q1_to_q1) label /// 
nostar se nonumbers nomtitles nolines compress noobs b(3)


*** Panel D: IV Left vs Right

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention {
eststo: xi: ivreg `var' (q1_to_q1_left q1_to_q1_right q1_to_q1_center = Treated_left Treated_right Treated_center) `Controls'
test q1_to_q1_left= q1_to_q1_right
local `var'_iv: display %5.3f `r(p)'
su Treated_left if e(sample)==1
local `var'_oiv : display %5.0f `r(N)'
}

eststo: xi: ivreg unequal_opp_problem_d (q1_to_q1_left q1_to_q1_right q1_to_q1_center = Treated_left Treated_right Treated_center) `Controls' if channels_before_ladder==0
test q1_to_q1_left= q1_to_q1_right
local unequal_opp_problem_d_iv: display %5.3f `r(p)'
su Treated_left if e(sample)==1
local unequal_opp_problem_d_oiv : display %5.0f `r(N)'

foreach var in budget_safetynet income_tax_top1 income_tax_bot50 {
eststo: xi: ivreg `var' (q1_to_q1_left q1_to_q1_right q1_to_q1_center = Treated_left Treated_right Treated_center) `Controls'
test q1_to_q1_left= q1_to_q1_right
local `var'_iv: display %5.3f `r(p)'
su Treated_left if e(sample)==1
local `var'_oiv : display %5.0f `r(N)'
}

eststo: xi: ivreg tools_d (q1_to_q1_left q1_to_q1_right q1_to_q1_center = Treated_left Treated_right Treated_center) `Controls' if channels_before_ladder==0
test q1_to_q1_left= q1_to_q1_right
local tools_d_iv: display %5.3f `r(p)'
su Treated_left if e(sample)==1
local tools_d_oiv : display %5.0f `r(N)'

eststo: xi: ivreg index_redistribution (q1_to_q1_left q1_to_q1_right q1_to_q1_center = Treated_left Treated_right Treated_center) `Controls'
test q1_to_q1_left= q1_to_q1_right
local index_redistribution_iv: display %5.3f `r(p)'
su Treated_left if e(sample)==1
local index_redistribution_oiv : display %5.0f `r(N)'

esttab using temp_IV_PanelD.tex, replace fragment booktabs keep(q1_to_q1_left q1_to_q1_right left right) label /// 
nostar se nonumbers nomtitles nolines compress noobs b(3)


* Table headers
file open holder using temp_reduced_header_panelA.tex, write replace text
file write holder "\multicolumn{5}{l}{\textbf{\textit{A. Treatment Effects}}} \\" _n
file close holder
file open holder using temp_reduced_header_panelB.tex, write replace text
file write holder " & & & & & & & & & &  \\" _n
file write holder "\multicolumn{5}{l}{\textbf{\textit{B. Treatment Effects for Left and Right Wing}}} \\" _n
file close holder
file open holder using temp_IV_header_panelC.tex, write replace text
file write holder " & & & & & & & & & &  \\" _n
file write holder "p-value diff. & `budget_opp_te' & `support_estate_45_te' & `support_eq_opp_pol_te' & `government_intervention_te' & `unequal_opp_problem_d_te' & `budget_safetynet_te' & `income_tax_top1_te' & `income_tax_bot50_te' & `tools_d_te' & `index_redistribution_te' \\" _n
file write holder " & & & & & & & & & &  \\" _n
file write holder " & & & & & & & & & &  \\" _n
file write holder "\multicolumn{5}{l}{\textbf{\textit{C. IV Estimates}}} \\" _n
file close holder
file open holder using temp_IV_header_panelD.tex, write replace text
file write holder " & & & & & & & & & &  \\" _n
file write holder "\multicolumn{5}{l}{\textbf{\textit{D. IV Estimates for Left and Right Wing}}} \\" _n
file close holder
file open holder using temp_end.tex, write replace text
file write holder " & & & & & & & & & &  \\" _n
file write holder "p-value diff. & `budget_opp_iv' & `support_estate_45_iv' & `support_eq_opp_pol_iv' & `government_intervention_iv' & `unequal_opp_problem_d_iv' & `budget_safetynet_iv' & `income_tax_top1_iv' & `income_tax_bot50_iv' & `tools_d_iv' & `index_redistribution_iv' \\" _n
file write holder "Observations & `budget_opp_oiv' & `support_estate_45_oiv' & `support_eq_opp_pol_oiv' & `government_intervention_oiv' & `unequal_opp_problem_d_oiv' & `budget_safetynet_oiv' & `income_tax_top1_oiv' & `income_tax_bot50_oiv' & `tools_d_oiv' & `index_redistribution_oiv' \\" _n
file write holder "\hline \end{tabular}\end{center}" _n
file close holder

appendfile temp_reduced_header_panelA.tex table_treatment_effects.tex
appendfile temp_reduced_PanelA.tex table_treatment_effects.tex
appendfile temp_reduced_header_panelB.tex table_treatment_effects.tex
appendfile temp_reduced_PanelB.tex table_treatment_effects.tex
appendfile temp_IV_header_panelC.tex table_treatment_effects.tex
appendfile temp_IV_PanelC.tex table_treatment_effects.tex
appendfile temp_IV_header_panelD.tex table_treatment_effects.tex
appendfile temp_IV_PanelD.tex table_treatment_effects.tex
appendfile temp_end.tex table_treatment_effects.tex	

erase temp_reduced_header_panelA.tex
erase temp_reduced_PanelA.tex
erase temp_reduced_header_panelB.tex
erase temp_reduced_PanelB.tex
erase temp_IV_header_panelC.tex
erase temp_IV_PanelC.tex
erase temp_IV_header_panelD.tex
erase temp_IV_PanelD.tex
erase temp_end.tex


