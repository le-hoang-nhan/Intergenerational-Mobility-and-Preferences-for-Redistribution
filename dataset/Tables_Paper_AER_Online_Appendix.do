	
/*

INTERGENERATIONAL MOBILITY AND PREFERENCES FOR REDISTRIBUTION
ALESINA, STANTCHEVA, TESO 
AER

THIS DO FILE GENERATES ALL TABLES FOR ONLINE APPENDIX

*/
	
	

***********************************************************************************
***********************************************************************************
***	TABLE OA3: Share of respondents with Strange patterns in “ladder” question  ***									  					     	     			   					
***********************************************************************************
***********************************************************************************

 set more off

* Open dataset
use "Data_Descriptive_Waves_ABC.dta", clear	

* dummies
gen mob_100_anywhere=(q1_to_q1 == 100 | q1_to_q2 == 100 | q1_to_q3 == 100 | q1_to_q4 == 100 | q1_to_q5 == 100)
gen mob_100_notbottom=(q1_to_q2 == 100 | q1_to_q3 == 100 | q1_to_q4 == 100 | q1_to_q5 == 100)
gen mob_0_bottom=(q1_to_q1 == 0 | q1_to_q2 == 0 | q1_to_q3 == 0)
gen mob_20=(q1_to_q1 == 20 & q1_to_q2 == 20 & q1_to_q3 == 20 & q1_to_q4 == 20 & q1_to_q5 == 20)

foreach x in February September {
su mob_100_anywhere if wave=="`x'"
local mob_100_any`x' : display %5.2f `r(mean)'
}
cap drop matrix A
matrix A=(`mob_100_anyFebruary',`mob_100_anySeptember')

foreach y in mob_100_notbottom mob_0_bottom mob_20 {
foreach x in February September {
su `y' if wave=="`x'"
local `y'`x' : display %5.2f `r(mean)'
}
cap drop matrix B
matrix B=(``y'February',``y'September')
matrix A=A\B
}

frmttable using tabulation_weird_entries, statmat(A) tex fragment replace  center ///
		ctitle("", "Waves A","Waves B and C") ///
		rtitle(100 in any quintile\100 in quintile Q2/Q3/Q4/Q5\0 in quintile Q1/Q2/Q3\20 in each quintile)
	


******************************************************************
******************************************************************
***	TABLE OA4: COVARIATES BALANCE AMONG RANDOMIZATION GROUPS   ***									  					     	     			   					
******************************************************************
******************************************************************

set more off

* Open dataset
use "Data_Experiment_Waves_BC.dta", clear

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Country-survey fixed effects
egen country_survey=group(country round)

* Saw channels before ladder
gen channels_before_ladder=(randomization_group==1 |  randomization_group==2 |  randomization_group==5 |  randomization_group==6)

* Talent versus effort
gen effort=(q1_to_q1_effort!=.)
replace effort=. if US==1 & round==2

* Married dummy (=0 if "other")
replace married=0 if married==2

* Not in the labor force
gen not_labor_force=(employment_status==6)
replace not_labor_force=. if employment_status==.

* Left-wing
gen left=(ideology_economic<=2)
replace left=. if ideology_economic==.


cap mata drop A

xi: reg Treated male i.country_survey
local pval_male=2*ttail(e(df_r), abs(_b[male]/_se[male]))
local pval_male: display %5.3f `pval_male'
xi: reg channels_before_ladder male i.country_survey
local pval_male2=2*ttail(e(df_r), abs(_b[male]/_se[male]))
local pval_male2: display %5.3f `pval_male2'
xi: reg effort male i.country_survey
local pval_male3=2*ttail(e(df_r), abs(_b[male]/_se[male]))
local pval_male3: display %5.3f `pval_male3'
matrix A=(`pval_male', `pval_male2', `pval_male3')

foreach i in age married children_dummy born_in_country employed unemployed not_labor_force university_degree left {
xi: reg Treated `i' i.country_survey
local pval_`i'=2*ttail(e(df_r), abs(_b[`i']/_se[`i']))
local pval_`i': display %5.3f `pval_`i''
xi: reg channels_before_ladder `i' i.country_survey
local pval_`i'2=2*ttail(e(df_r), abs(_b[`i']/_se[`i']))
local pval_`i'2: display %5.3f `pval_`i'2'
xi: reg effort `i' i.country_survey
local pval_`i'3=2*ttail(e(df_r), abs(_b[`i']/_se[`i']))
local pval_`i'3: display %5.3f `pval_`i'3'
cap mata drop B`i'
matrix B`i'=(`pval_`i'',`pval_`i'2',`pval_`i'3')
matrix A=A\B`i' 
}

frmttable using balance_randomization, statmat(A) tex fragment replace  center ///
		ctitle("","" , Government, Effort \"" ,Treated , Questions, Questions\ "", "(1)", "(2)", "(3)") ///
		rtitle(Male\ Age\ Married\ Has children\ Native\ Employed\ Unemployed\ Not in labor force\ Has university degree\ Left-wing)
	
		
*****************************************************************
*****************************************************************
***	TABLE OA5:  PERCEPTIONS FOR ALL COUNTRIES - LEFT VS RIGHT ***
*****************************************************************
*****************************************************************
		

set more off

* Open dataset
use "Data_Descriptive_Waves_ABC.dta", clear	

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Only control group
keep if Treated==0

gen All=1
			
* Generate dummies for mobility
gen low_to_middle_prob_d=(low_to_middle_prob>2)
replace low_to_middle_prob_d=. if low_to_middle_prob==.
drop low_to_middle_prob
rename low_to_middle_prob_d low_to_middle_prob

gen low_to_high_prob_d=(low_to_high_prob>2)
replace low_to_high_prob_d=. if low_to_high_prob==.
drop low_to_high_prob
rename low_to_high_prob_d low_to_high_prob 


foreach x in All US UK Italy France Sweden {	
foreach y in q1_to_q1 q1_to_q2 q1_to_q3 q1_to_q4 q1_to_q5 low_to_middle_prob low_to_high_prob {
su `y' if `x'==1
local `x'`y' : display %5.2f `r(mean)'
local obs_`x' : display %5.0f `r(N)'
}
cap mata drop A`x'
matrix A`x'=(``x'q1_to_q1', ``x'q1_to_q2', ``x'q1_to_q3', ``x'q1_to_q4', ``x'q1_to_q5', ``x'low_to_middle_prob', ``x'low_to_high_prob', `obs_`x'')
}

foreach x in All US UK Italy France Sweden {	
foreach y in q1_to_q1 q1_to_q2 q1_to_q3 q1_to_q4 q1_to_q5 low_to_middle_prob low_to_high_prob {
su `y' if `x'==1 & left==1
local `x'`y'l : display %5.2f `r(mean)'
local obs_`x'l : display %5.0f `r(N)'
}
cap mata drop A`x'l
matrix A`x'l=(``x'q1_to_q1l', ``x'q1_to_q2l', ``x'q1_to_q3l', ``x'q1_to_q4l', ``x'q1_to_q5l', ``x'low_to_middle_probl', ``x'low_to_high_probl', `obs_`x'l')
}

foreach x in All US UK Italy France Sweden {	
foreach y in q1_to_q1 q1_to_q2 q1_to_q3 q1_to_q4 q1_to_q5 low_to_middle_prob low_to_high_prob {
su `y' if `x'==1 & right==1
local `x'`y'r : display %5.2f `r(mean)'
local obs_`x'r : display %5.0f `r(N)'
}
cap mata drop A`x'r
matrix A`x'r=(``x'q1_to_q1r', ``x'q1_to_q2r', ``x'q1_to_q3r', ``x'q1_to_q4r', ``x'q1_to_q5r', ``x'low_to_middle_probr', ``x'low_to_high_probr', `obs_`x'r')
}

matrix S=(., ., ., ., ., ., .,.)

matrix B=S
matrix B=B\AAll
matrix B=B\AAlll
matrix B=B\AAllr 
matrix B=B\S 
matrix B=B\AUS 
matrix B=B\AUSl 
matrix B=B\AUSr 
matrix B=B\S 
matrix B=B\AUK 
matrix B=B\AUKl 
matrix B=B\AUKr 
matrix B=B\S 
matrix B=B\AFrance 
matrix B=B\AFrancel 
matrix B=B\AFrancer 
matrix B=B\S 
matrix B=B\AItaly 
matrix B=B\AItalyl 
matrix B=B\AItalyr 
matrix B=B\S 
matrix B=B\ASweden
matrix B=B\ASwedenl
matrix B=B\ASwedenr

mat rownames B= All Mean Mean-Left Mean-Right US Mean Mean-Left Mean-Right UK Mean Mean-Left Mean-Right France Mean Mean-Left Mean-Right Italy Mean Mean-Left Mean-Right Sweden Mean Mean-Left Mean-Right
frmttable using summ_stats_mobility, statmat(B) tex fragment replace  center ///
		rtitle("\textbf{All Countries}"\All\Left\Right\"\textbf{US}"\All\Left\Right\"\textbf{UK}"\All\Left\Right\"\textbf{France}"\All\Left\Right\"\textbf{Italy}"\All\Left\Right\"\textbf{Sweden}"\All\Left\Right) ///
		ctitle("", Q1 to, Q1 to, Q1 to, Q1 to, Q1 to, Q1 to Q4, Q1 to Q5, Obs.\ "", Q1, Q2, Q3, Q4, Q5, (Qual.), (Qual.), ""\ "",(1),(2),(3),(4),(5),(6),(7),(8)) ///
		rtitlfont(it \ "" \ "" \ "" \ it \ "" \ "" \ "" \ it \ "" \ "" \ "" \ it \ "" \ "" \ "" \ it \ "" \ "" \ "" \ it \ "" \ "" \ "") ///
		sdec(2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0\2,2,2,2,2,2,2,0)

		

*****************************************************************
*****************************************************************
***	TABLE OA6:  PERCEPTIONS AND ROLE OF EFFORT 				  ***
*****************************************************************
*****************************************************************


set more off

* Open dataset
use "Data_Descriptive_Waves_ABC.dta", clear	

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Only control group
keep if Treated==0

forvalues q=1(1)5 {
label var q1_to_q`q' "Q1 to Q`q'"
}
cap mata drop A
cap mata drop C

su q1_to_q5 if US==1
local q5_US : display %5.2f `r(mean)'
su q1_to_q5 if UK==1
local q5_UK : display %5.2f `r(mean)'
su q1_to_q5 if France==1
local q5_France : display %5.2f `r(mean)'
su q1_to_q5 if Italy==1
local q5_Italy : display %5.2f `r(mean)'
su q1_to_q5 if Sweden==1
local q5_Sweden : display %5.2f `r(mean)'

su q1_to_q5_effort if US==1
local q5_US_effort : display %5.2f `r(mean)'
su q1_to_q5_effort if UK==1
local q5_UK_effort : display %5.2f `r(mean)'
su q1_to_q5_effort if France==1
local q5_France_effort : display %5.2f `r(mean)'
su q1_to_q5_effort if Italy==1
local q5_Italy_effort : display %5.2f `r(mean)'
su q1_to_q5_effort if Sweden==1
local q5_Sweden_effort : display %5.2f `r(mean)'

su q1_to_q5_effort if US==1
local q5_US_effort: display %5.2f `r(mean)'
gen q5_effort_role=(`q5_US_effort'-`q5_US')/`q5_US'
su q5_effort_role
local q5_US_effort_role: display %5.2f `r(mean)'
drop q5_effort_role
su q1_to_q5_effort if UK==1
local q5_UK_effort : display %5.2f `r(mean)'
gen q5_effort_role=(`q5_UK_effort'-`q5_UK')/`q5_UK'
su q5_effort_role
local q5_UK_effort_role: display %5.2f `r(mean)'
drop q5_effort_role
su q1_to_q5_effort if France==1
local q5_France_effort : display %5.2f `r(mean)'
gen q5_effort_role=(`q5_France_effort'-`q5_France')/`q5_France'
su q5_effort_role
local q5_France_effort_role: display %5.2f `r(mean)'
drop q5_effort_role
su q1_to_q5_effort if Italy==1
local q5_Italy_effort : display %5.2f `r(mean)'
gen q5_effort_role=(`q5_Italy_effort'-`q5_Italy')/`q5_Italy'
su q5_effort_role
local q5_Italy_effort_role: display %5.2f `r(mean)'
drop q5_effort_role
su q1_to_q5_effort if Sweden==1
local q5_Sweden_effort : display %5.2f `r(mean)'
gen q5_effort_role=(`q5_Sweden_effort'-`q5_Sweden')/`q5_Sweden'
su q5_effort_role
local q5_Sweden_effort_role: display %5.2f `r(mean)'
drop q5_effort_role

ttest q1_to_q5== q1_to_q5_effort if US==1
local p_US: display %5.4f `r(p)'
ttest q1_to_q5== q1_to_q5_effort if UK==1
local p_UK: display %5.4f `r(p)'
ttest q1_to_q5== q1_to_q5_effort if France==1
local p_France: display %5.4f `r(p)'
ttest q1_to_q5== q1_to_q5_effort if Italy==1
local p_Italy: display %5.4f `r(p)'
ttest q1_to_q5== q1_to_q5_effort if Sweden==1
local p_Sweden: display %5.4f `r(p)'

matrix A=(`q5_US_effort',., `q5_UK_effort',., `q5_France_effort',., `q5_Italy_effort',., `q5_Sweden_effort',., `q5_US_effort_role', `p_US', `q5_UK_effort_role', `p_UK', `q5_France_effort_role', `p_France', `q5_Italy_effort_role', `p_Italy', `q5_Sweden_effort_role', `p_Sweden')


foreach i in 4 3 2 1 {
su q1_to_q`i' if US==1
local q`i'_US : display %5.2f `r(mean)'
su q1_to_q`i' if UK==1
local q`i'_UK : display %5.2f `r(mean)'
su q1_to_q`i' if France==1
local q`i'_France : display %5.2f `r(mean)'
su q1_to_q`i' if Italy==1
local q`i'_Italy : display %5.2f `r(mean)'
su q1_to_q`i' if Sweden==1
local q`i'_Sweden : display %5.2f `r(mean)'

su q1_to_q`i'_effort if US==1
local q`i'_US_effort : display %5.2f `r(mean)'
su q1_to_q`i'_effort if UK==1
local q`i'_UK_effort : display %5.2f `r(mean)'
su q1_to_q`i'_effort if France==1
local q`i'_France_effort : display %5.2f `r(mean)'
su q1_to_q`i'_effort if Italy==1
local q`i'_Italy_effort : display %5.2f `r(mean)'
su q1_to_q`i'_effort if Sweden==1
local q`i'_Sweden_effort : display %5.2f `r(mean)'


su q1_to_q`i'_effort if US==1
local q`i'_US_effort: display %5.2f `r(mean)'
gen q`i'_effort_role=(`q`i'_US_effort'-`q`i'_US')/`q`i'_US'
su q`i'_effort_role
local q`i'_US_effort_role: display %5.2f `r(mean)'
drop q`i'_effort_role
su q1_to_q`i'_effort if UK==1
local q`i'_UK_effort : display %5.2f `r(mean)'
gen q`i'_effort_role=(`q`i'_UK_effort'-`q`i'_UK')/`q`i'_UK'
su q`i'_effort_role
local q`i'_UK_effort_role: display %5.2f `r(mean)'
drop q`i'_effort_role
su q1_to_q`i'_effort if France==1
local q`i'_France_effort : display %5.2f `r(mean)'
gen q`i'_effort_role=(`q`i'_France_effort'-`q`i'_France')/`q`i'_France'
su q`i'_effort_role
local q`i'_France_effort_role: display %5.2f `r(mean)'
drop q`i'_effort_role
su q1_to_q`i'_effort if Italy==1
local q`i'_Italy_effort : display %5.2f `r(mean)'
gen q`i'_effort_role=(`q`i'_Italy_effort'-`q`i'_Italy')/`q`i'_Italy'
su q`i'_effort_role
local q`i'_Italy_effort_role: display %5.2f `r(mean)'
drop q`i'_effort_role
su q1_to_q`i'_effort if Sweden==1
local q`i'_Sweden_effort : display %5.2f `r(mean)'
gen q`i'_effort_role=(`q`i'_Sweden_effort'-`q`i'_Sweden')/`q`i'_Sweden'
su q`i'_effort_role
local q`i'_Sweden_effort_role: display %5.2f `r(mean)'
drop q`i'_effort_role

ttest q1_to_q`i'== q1_to_q`i'_effort if US==1
local p_US`i': display %5.4f `r(p)'
ttest q1_to_q`i'== q1_to_q`i'_effort if UK==1
local p_UK`i': display %5.4f `r(p)'
ttest q1_to_q`i'== q1_to_q`i'_effort if France==1
local p_France`i': display %5.4f `r(p)'
ttest q1_to_q`i'== q1_to_q`i'_effort if Italy==1
local p_Italy`i': display %5.4f `r(p)'
ttest q1_to_q`i'== q1_to_q`i'_effort if Sweden==1
local p_Sweden`i': display %5.4f `r(p)'

cap mata drop B`i'
matrix B`i'=(`q`i'_US_effort',., `q`i'_UK_effort',., `q`i'_France_effort',., `q`i'_Italy_effort',., `q`i'_Sweden_effort',., `q`i'_US_effort_role', `p_US`i'', `q`i'_UK_effort_role', `p_UK`i'', `q`i'_France_effort_role', `p_France`i'', `q`i'_Italy_effort_role', `p_Italy`i'', `q`i'_Sweden_effort_role', `p_Sweden`i'')
matrix A=A\B`i' 


}


su q1_to_q5_effort if US==1
local obs_US : display %5.0f `r(N)'
su q1_to_q5_effort if UK==1
local obs_UK : display %5.0f `r(N)'
su q1_to_q5_effort if France==1
local obs_France : display %5.0f `r(N)'
su q1_to_q5_effort if Italy==1
local obs_Italy : display %5.0f `r(N)'
su q1_to_q5_effort if Sweden==1
local obs_Sweden : display %5.0f `r(N)'
cap mata drop C
matrix C=(int(`obs_US'),., int(`obs_UK'),., int(`obs_France'),., int(`obs_Italy'),., int(`obs_Sweden'),., int(`obs_US'),., int(`obs_UK'),., int(`obs_France'),., int(`obs_Italy'),., int(`obs_Sweden'),.)
matrix A=A\C

mat colnames A= US UK France Italy Sweden US UK France Italy Sweden
frmttable using table_perceived_probs_role_effort, statmat(A) tex fragment replace sdec(2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\0,0,0,0,0,0,0,0,0,0) center ///
		rtitle(Q1 to Q5\""\Q1 to Q4\""\Q1 to Q3\""\Q1 to Q2\""\Q1 to Q1\""\Obs.) ///
		ctitle("","","","","","","Panel B: \% Difference Between","","","",""\"",Panel A: Perceived Transition,"","","","",Perceived Transition Probabilities,"","","",""\"",Probabilities Conditional on Effort,"","","","", Conditional and Unconditional on Effort,"","","",""\"",US,UK,France,Italy,Sweden,US,UK,France,Italy,Sweden \ "",(1),(2),(3),(4),(5),(1),(2),(3),(4),(5)) ///
		multicol(1,7,5;2,2,5;2,7,5;3,2,5;3,7,5) hlines(10010100000000011) substat(1) nobl spaceb(1001010000000001)
			
	
******************************************************************
******************************************************************
***	TABLE OA7:  HETEROGENEITY IN PERCEPTIONS - PARTIAL EFFECTS *** 					
******************************************************************
******************************************************************

set more off

* Open dataset
use "Data_Experiment_Waves_BC.dta", clear

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0
* Only control group
keep if Treated==0 

*** Generate covariates of interest ***
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
* age
gen young=(age<45)
* Moved up with respect to father
gen moved_up=(job_prestige_father>3)
replace moved_up=. if job_prestige_father==.
* Immigrant
gen immigrant=(parents_born_in_country==0)
replace immigrant=. if parents_born_in_country==.

* Sum of Q4+Q5
gen q1_to_q4q5=q1_to_q4+q1_to_q5

* Make dummies for qualitative questions
gen low_to_middle_prob_d=(low_to_middle_prob>2)
replace low_to_middle_prob_d=. if low_to_middle_prob==.
drop low_to_middle_prob
rename low_to_middle_prob_d low_to_middle_prob

gen low_to_high_prob_d=(low_to_high_prob>2)
replace low_to_high_prob_d=. if low_to_high_prob==.
drop low_to_high_prob
rename low_to_high_prob_d low_to_high_prob 

* country-survey
egen country_survey=group(country round)

* label variables
label var male "Male"
label var young "Young"
label var children_dummy "Has Children" 
label var rich "Rich"
label var university_degree "College"
label var left "Left"
label var right "Right"
label var moved_up "Moved up"
label var immigrant "Immigrant"
label var q1_to_q1 "Q1 to Q1"
label var q1_to_q4 "Q1 to Q4"
label var q1_to_q5 "Q1 to Q5"
label var q1_to_q4q5 "Q1 to Q4 or Q5"
label var low_to_middle_prob "Q1 to Q4 (Qual.)"
label var low_to_high_prob "Q1 to Q5 (Qual.)"


xi: reg q1_to_q1 male young children_dummy rich university_degree right moved_up immigrant i.country_survey
su q1_to_q1 if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions, se  keep(male young children_dummy rich university_degree right moved_up immigrant) ctitle("", Q1 to Q1 \ "", (1)) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") nocons tex fragment varlabels replace

xi: reg q1_to_q4q5 male young children_dummy rich university_degree right moved_up immigrant i.country_survey
su q1_to_q4q5 if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions, se  keep(male young children_dummy rich university_degree right moved_up immigrant) ctitle("", Q1 to Q4 or Q5 \ "", (2)) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") nocons tex fragment varlabels merge

xi: reg low_to_middle_prob male young children_dummy rich university_degree right moved_up immigrant i.country_survey
su low_to_middle_prob if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions, se  keep(male young children_dummy rich university_degree right moved_up immigrant) ctitle("", Q1 to Q4 (Qual.) \ "", (3)) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") nocons tex fragment varlabels merge

xi: reg low_to_high_prob male young children_dummy rich university_degree right moved_up immigrant i.country_survey
su low_to_high_prob if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions, se  keep(male young children_dummy rich university_degree right moved_up immigrant) ctitle("", Q1 to Q5 (Qual.) \ "", (4)) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") nocons tex fragment varlabels merge
	
			
**********************************************************************************************
**********************************************************************************************
***	TABLE OA8: PERCEPTIONS AND ROLE OF TALENT											   ***					     	     			   					
**********************************************************************************************
**********************************************************************************************	

set more off

* Open dataset
use "Data_Descriptive_Waves_ABC.dta", clear	

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0
* Only control group
keep if Treated==0 


forvalues q=1(1)5 {
label var q1_to_q`q' "Q1 to Q`q'"
}
cap mata drop A
cap mata drop C

su q1_to_q5 if US==1
local q5_US : display %5.2f `r(mean)'
su q1_to_q5 if UK==1
local q5_UK : display %5.2f `r(mean)'
su q1_to_q5 if France==1
local q5_France : display %5.2f `r(mean)'
su q1_to_q5 if Italy==1
local q5_Italy : display %5.2f `r(mean)'
su q1_to_q5 if Sweden==1
local q5_Sweden : display %5.2f `r(mean)'

su q1_to_q5_talent if US==1
local q5_US_talent : display %5.2f `r(mean)'
su q1_to_q5_talent if UK==1
local q5_UK_talent : display %5.2f `r(mean)'
su q1_to_q5_talent if France==1
local q5_France_talent : display %5.2f `r(mean)'
su q1_to_q5_talent if Italy==1
local q5_Italy_talent : display %5.2f `r(mean)'
su q1_to_q5_talent if Sweden==1
local q5_Sweden_talent : display %5.2f `r(mean)'

su q1_to_q5_talent if US==1
local q5_US_talent: display %5.2f `r(mean)'
gen q5_talent_role=(`q5_US_talent'-`q5_US')/`q5_US'
su q5_talent_role
local q5_US_talent_role: display %5.2f `r(mean)'
drop q5_talent_role
su q1_to_q5_talent if UK==1
local q5_UK_talent : display %5.2f `r(mean)'
gen q5_talent_role=(`q5_UK_talent'-`q5_UK')/`q5_UK'
su q5_talent_role
local q5_UK_talent_role: display %5.2f `r(mean)'
drop q5_talent_role
su q1_to_q5_talent if France==1
local q5_France_talent : display %5.2f `r(mean)'
gen q5_talent_role=(`q5_France_talent'-`q5_France')/`q5_France'
su q5_talent_role
local q5_France_talent_role: display %5.2f `r(mean)'
drop q5_talent_role
su q1_to_q5_talent if Italy==1
local q5_Italy_talent : display %5.2f `r(mean)'
gen q5_talent_role=(`q5_Italy_talent'-`q5_Italy')/`q5_Italy'
su q5_talent_role
local q5_Italy_talent_role: display %5.2f `r(mean)'
drop q5_talent_role
su q1_to_q5_talent if Sweden==1
local q5_Sweden_talent : display %5.2f `r(mean)'
gen q5_talent_role=(`q5_Sweden_talent'-`q5_Sweden')/`q5_Sweden'
su q5_talent_role
local q5_Sweden_talent_role: display %5.2f `r(mean)'
drop q5_talent_role

ttest q1_to_q5== q1_to_q5_talent if US==1
local p_US: display %5.4f `r(p)'
ttest q1_to_q5== q1_to_q5_talent if UK==1
local p_UK: display %5.4f `r(p)'
ttest q1_to_q5== q1_to_q5_talent if France==1
local p_France: display %5.4f `r(p)'
ttest q1_to_q5== q1_to_q5_talent if Italy==1
local p_Italy: display %5.4f `r(p)'
ttest q1_to_q5== q1_to_q5_talent if Sweden==1
local p_Sweden: display %5.4f `r(p)'

matrix A=(`q5_US_talent',., `q5_UK_talent',., `q5_France_talent',., `q5_Italy_talent',., `q5_Sweden_talent',., `q5_US_talent_role', `p_US', `q5_UK_talent_role', `p_UK', `q5_France_talent_role', `p_France', `q5_Italy_talent_role', `p_Italy', `q5_Sweden_talent_role', `p_Sweden')



foreach i in 4 3 2 1 {
su q1_to_q`i' if US==1
local q`i'_US : display %5.2f `r(mean)'
su q1_to_q`i' if UK==1
local q`i'_UK : display %5.2f `r(mean)'
su q1_to_q`i' if France==1
local q`i'_France : display %5.2f `r(mean)'
su q1_to_q`i' if Italy==1
local q`i'_Italy : display %5.2f `r(mean)'
su q1_to_q`i' if Sweden==1
local q`i'_Sweden : display %5.2f `r(mean)'

su q1_to_q`i'_talent if US==1
local q`i'_US_talent : display %5.2f `r(mean)'
su q1_to_q`i'_talent if UK==1
local q`i'_UK_talent : display %5.2f `r(mean)'
su q1_to_q`i'_talent if France==1
local q`i'_France_talent : display %5.2f `r(mean)'
su q1_to_q`i'_talent if Italy==1
local q`i'_Italy_talent : display %5.2f `r(mean)'
su q1_to_q`i'_talent if Sweden==1
local q`i'_Sweden_talent : display %5.2f `r(mean)'


su q1_to_q`i'_talent if US==1
local q`i'_US_talent: display %5.2f `r(mean)'
gen q`i'_talent_role=(`q`i'_US_talent'-`q`i'_US')/`q`i'_US'
su q`i'_talent_role
local q`i'_US_talent_role: display %5.2f `r(mean)'
drop q`i'_talent_role
su q1_to_q`i'_talent if UK==1
local q`i'_UK_talent : display %5.2f `r(mean)'
gen q`i'_talent_role=(`q`i'_UK_talent'-`q`i'_UK')/`q`i'_UK'
su q`i'_talent_role
local q`i'_UK_talent_role: display %5.2f `r(mean)'
drop q`i'_talent_role
su q1_to_q`i'_talent if France==1
local q`i'_France_talent : display %5.2f `r(mean)'
gen q`i'_talent_role=(`q`i'_France_talent'-`q`i'_France')/`q`i'_France'
su q`i'_talent_role
local q`i'_France_talent_role: display %5.2f `r(mean)'
drop q`i'_talent_role
su q1_to_q`i'_talent if Italy==1
local q`i'_Italy_talent : display %5.2f `r(mean)'
gen q`i'_talent_role=(`q`i'_Italy_talent'-`q`i'_Italy')/`q`i'_Italy'
su q`i'_talent_role
local q`i'_Italy_talent_role: display %5.2f `r(mean)'
drop q`i'_talent_role
su q1_to_q`i'_talent if Sweden==1
local q`i'_Sweden_talent : display %5.2f `r(mean)'
gen q`i'_talent_role=(`q`i'_Sweden_talent'-`q`i'_Sweden')/`q`i'_Sweden'
su q`i'_talent_role
local q`i'_Sweden_talent_role: display %5.2f `r(mean)'
drop q`i'_talent_role

ttest q1_to_q`i'== q1_to_q`i'_talent if US==1
local p_US`i': display %5.4f `r(p)'
ttest q1_to_q`i'== q1_to_q`i'_talent if UK==1
local p_UK`i': display %5.4f `r(p)'
ttest q1_to_q`i'== q1_to_q`i'_talent if France==1
local p_France`i': display %5.4f `r(p)'
ttest q1_to_q`i'== q1_to_q`i'_talent if Italy==1
local p_Italy`i': display %5.4f `r(p)'
ttest q1_to_q`i'== q1_to_q`i'_talent if Sweden==1
local p_Sweden`i': display %5.4f `r(p)'

cap mata drop B`i'
matrix B`i'=(`q`i'_US_talent',., `q`i'_UK_talent',., `q`i'_France_talent',., `q`i'_Italy_talent',., `q`i'_Sweden_talent',., `q`i'_US_talent_role',`p_US`i'', `q`i'_UK_talent_role',`p_UK`i'', `q`i'_France_talent_role',`p_France`i'', `q`i'_Italy_talent_role',`p_Italy`i'', `q`i'_Sweden_talent_role',`p_Sweden`i'')
matrix A=A\B`i' 

}


su q1_to_q5_talent if US==1
local obs_US : display %5.0f `r(N)'
su q1_to_q5_talent if UK==1
local obs_UK : display %5.0f `r(N)'
su q1_to_q5_talent if France==1
local obs_France : display %5.0f `r(N)'
su q1_to_q5_talent if Italy==1
local obs_Italy : display %5.0f `r(N)'
su q1_to_q5_talent if Sweden==1
local obs_Sweden : display %5.0f `r(N)'
cap mata drop C
matrix C=(int(`obs_US'),., int(`obs_UK'),., int(`obs_France'),., int(`obs_Italy'),., int(`obs_Sweden'),., int(`obs_US'),., int(`obs_UK'),., int(`obs_France'),., int(`obs_Italy'),., int(`obs_Sweden'),.)
matrix A=A\C

mat colnames A= US UK France Italy Sweden US UK France Italy Sweden
frmttable using table_perceived_probs_talent, statmat(A) tex fragment replace sdec(2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\2,2,2,2,2,2,2,2,2,2\0,0,0,0,0,0,0,0,0,0) center ///
		rtitle(Q1 to Q5\""\Q1 to Q4\""\Q1 to Q3\""\Q1 to Q2\""\Q1 to Q1\""\Obs.) ///
		ctitle("","","","","","","Panel B: \% Difference Between","","","",""\"",Panel A: Perceived Transition,"","","","",Perceived Transition Probabilities,"","","",""\"",Probabilities Conditional on Talent,"","","","", Conditional and Unconditional on Talent,"","","",""\"",US,UK,France,Italy,Sweden,US,UK,France,Italy,Sweden \ "",(1),(2),(3),(4),(5),(1),(2),(3),(4),(5)) ///
		multicol(1,7,5;2,2,5;2,7,5;3,2,5;3,7,5) hlines(10010100000000011) substat(1) nobl spaceb(1001010000000001)
			

					
**********************************************************************************
**********************************************************************************
***	TABLE OA9:  HETEROGENEITY IN PERCEPTIONS - GIVEN EFFORT - PARTIAL EFFECTS  *** 					
**********************************************************************************
**********************************************************************************


set more off

* Open dataset
use "Data_Experiment_Waves_BC.dta", clear

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0
* Only control group
keep if Treated==0 

*** Generate covariates of interest ***
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
gen young=(age<45)
* Unequal opportunity serious or very serious problem
gen unequal_opportunities_problem_2=(unequal_opportunities_problem>=2)
replace unequal_opportunities_problem_2=. if unequal_opportunities_problem==.
* Moved up with respect to father
gen moved_up=(job_prestige_father>3)
replace moved_up=. if job_prestige_father==.
* Immigrant
gen immigrant=(parents_born_in_country==0)
replace immigrant=. if parents_born_in_country==.

* country-survey
egen country_survey=group(country round)

* Make dummies for qualitative questions
gen low_to_middle_prob_d=(low_to_middle_prob_effort>2)
replace low_to_middle_prob_d=. if low_to_middle_prob_effort==.
drop low_to_middle_prob_effort
rename low_to_middle_prob_d low_to_middle_prob_effort

gen low_to_high_prob_d=(low_to_high_prob_effort>2)
replace low_to_high_prob_d=. if low_to_high_prob_effort==.
drop low_to_high_prob_effort
rename low_to_high_prob_d low_to_high_prob_effort

* Sum of Q4+Q5
gen q1_to_q4q5=q1_to_q4+q1_to_q5
gen q1_to_q4q5_effort=q1_to_q4_effort+q1_to_q5_effort
gen q1_to_q1_scaled_diff=(q1_to_q1_effort-q1_to_q1)
gen q1_to_q4q5_scaled_diff=(q1_to_q4q5_effort-q1_to_q4q5)

* label variables
label var q1_to_q1_effort "Q1 to Q1"
label var q1_to_q4_effort "Q1 to Q4"
label var q1_to_q5_effort "Q1 to Q5"
label var q1_to_q4q5_effort "Q1 to Q4 or Q5"
label var low_to_middle_prob_effort "Q1 to Q4 (Qual.)"
label var low_to_high_prob_effort "Q1 to Q5 (Qual.)"
label var q1_to_q1_scaled_diff "Scaled diff Q1 to Q1"
label var q1_to_q4q5_scaled_diff "Scaled diff Q1 to Q4 or Q5"
label var male "Male"
label var young "Young"
label var children_dummy "Has Children" 
label var rich "Rich"
label var university_degree "College"
label var right "Right"
label var moved_up "Moved up"
label var immigrant "Immigrant"

xi: reg q1_to_q1_effort male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ i.country_survey
su q1_to_q1_effort if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions_effort, se  keep(male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ ) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") ctitles("", "" \ "", "Q1 to Q1" \ "", "(1)") nocons tex fragment varlabels replace

xi: reg q1_to_q4q5_effort male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ i.country_survey
su q1_to_q4q5_effort if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions_effort, se  keep(male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ ) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") ctitles("", "" \ "", "Q1 to Q4 or Q5" \ "", "(2)") nocons tex fragment varlabels merge

xi: reg low_to_middle_prob_effort male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ i.country_survey
su low_to_middle_prob_effort if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions_effort, se  keep(male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ ) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") ctitles("", "" \ "", "Q1 to Q4 (Qual.)" \ "", "(3)")  nocons tex fragment varlabels merge

xi: reg low_to_high_prob_effort male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ i.country_survey
su low_to_high_prob_effort if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions_effort, se  keep(male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ ) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") ctitles("", "" \ "", "Q1 to Q5 (Qual.)" \ "", "(4)") nocons tex fragment varlabels merge

xi: reg q1_to_q1_scaled_diff male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ i.country_survey
su q1_to_q1_scaled_diff if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions_effort, se  keep(male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ ) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") ctitles("", "Diff" \ "", "Q1 to Q1" \ "", "(5)") nocons tex fragment varlabels merge

xi: reg q1_to_q4q5_scaled_diff male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ i.country_survey
su q1_to_q4q5_scaled_diff if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions_effort, se  keep(male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") ctitles("", "Diff" \ "", "Q1 to Q4 or Q5" \ "", "(6)") nocons tex fragment varlabels merge

			

**********************************************************************************************
**********************************************************************************************
***	TABLE OA10:  HETEROGENEITY IN PERCEPTIONS - GIVEN TALENT - PARTIAL EFFECTS  		   *** 					
**********************************************************************************************
**********************************************************************************************	
	
set more off

* Open dataset
use "Data_Experiment_Waves_BC.dta", clear

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0
* Only control group
keep if Treated==0 

*** Generate covariates of interest ***
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
gen young=(age<45)
* Unequal opportunity serious or very serious problem
gen unequal_opportunities_problem_2=(unequal_opportunities_problem>=2)
replace unequal_opportunities_problem_2=. if unequal_opportunities_problem==.
* Moved up with respect to father
gen moved_up=(job_prestige_father>3)
replace moved_up=. if job_prestige_father==.
* Immigrant
gen immigrant=(parents_born_in_country==0)
replace immigrant=. if parents_born_in_country==.

* country-survey
egen country_survey=group(country round)

* Make dummies for qualitative questions
gen low_to_middle_prob_d=(low_to_middle_prob_talent>2)
replace low_to_middle_prob_d=. if low_to_middle_prob_talent==.
drop low_to_middle_prob_talent
rename low_to_middle_prob_d low_to_middle_prob_talent

gen low_to_high_prob_d=(low_to_high_prob_talent>2)
replace low_to_high_prob_d=. if low_to_high_prob_talent==.
drop low_to_high_prob_talent
rename low_to_high_prob_d low_to_high_prob_talent

* Sum of Q4+Q5
gen q1_to_q4q5=q1_to_q4+q1_to_q5
gen q1_to_q4q5_talent=q1_to_q4_talent+q1_to_q5_talent
gen q1_to_q1_scaled_diff=(q1_to_q1_talent-q1_to_q1)
gen q1_to_q4q5_scaled_diff=(q1_to_q4q5_talent-q1_to_q4q5)

* label variables
label var q1_to_q1_talent "Q1 to Q1"
label var q1_to_q4_talent "Q1 to Q4"
label var q1_to_q5_talent "Q1 to Q5"
label var q1_to_q4q5_talent "Q1 to Q4 or Q5"
label var low_to_middle_prob_talent "Q1 to Q4 (Qual.)"
label var low_to_high_prob_talent "Q1 to Q5 (Qual.)"
label var q1_to_q1_scaled_diff "Scaled diff Q1 to Q1"
label var q1_to_q4q5_scaled_diff "Scaled diff Q1 to Q4 or Q5"
label var male "Male"
label var young "Young"
label var children_dummy "Has Children" 
label var rich "Rich"
label var university_degree "College"
label var right "Right"
label var moved_up "Moved up"
label var immigrant "Immigrant"

xi: reg q1_to_q1_talent male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ i.country_survey
su q1_to_q1_talent if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions_talent, se  keep(male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ ) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") ctitles("", "" \ "", "Q1 to Q1" \ "", "(1)") nocons tex fragment varlabels replace

xi: reg q1_to_q4q5_talent male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ i.country_survey
su q1_to_q4q5_talent if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions_talent, se  keep(male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ ) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") ctitles("", "" \ "", "Q1 to Q4 or Q5" \ "", "(2)") nocons tex fragment varlabels merge

xi: reg low_to_middle_prob_talent male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ i.country_survey
su low_to_middle_prob_talent if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions_talent, se  keep(male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ ) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") ctitles("", "" \ "", "Q1 to Q4 (Qual.)" \ "", "(3)")  nocons tex fragment varlabels merge

xi: reg low_to_high_prob_talent male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ i.country_survey
su low_to_high_prob_talent if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions_talent, se  keep(male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ ) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") ctitles("", "" \ "", "Q1 to Q5 (Qual.)" \ "", "(4)") nocons tex fragment varlabels merge

xi: reg q1_to_q1_scaled_diff male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ i.country_survey
su q1_to_q1_scaled_diff if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions_talent, se  keep(male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ ) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") ctitles("", "Diff" \ "", "Q1 to Q1" \ "", "(5)") nocons tex fragment varlabels merge

xi: reg q1_to_q4q5_scaled_diff male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */ i.country_survey
su q1_to_q4q5_scaled_diff if e(sample)==1
local m : display %5.2f `r(mean)'
outreg using heterogeneity_perceptions_talent, se  keep(male young children_dummy rich university_degree /* left */ right moved_up immigrant /* effort_reason_poor effort_reason_rich econ_system_fair unequal_opportunities_problem_2 */) summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) addrows("Country-wave FE", "Yes" \"Mean Dep. Var.", "`m'") ctitles("", "Diff" \ "", "Q1 to Q4 or Q5" \ "", "(6)") nocons tex fragment varlabels merge
		
	

	
	
**********************************************************************************
**********************************************************************************
***	TABLE OA11:  COMMUTING ZONE CHARACTERISTICS AND MOBILITY PERCEPTIONS	   *** 					
**********************************************************************************
**********************************************************************************

use "Data_CZ_Level_Analysis_US_Waves_BC.dta", clear

keep if Treated==0

keep if flag_1==0 & flag_2==0

*** Generate covariates of interest ***
* Income
gen rich=0
su household_income, d
replace rich=1 if household_income>r(p75)
replace rich=. if household_income==.

* Left and right
gen left=(ideology_economic ==1 | ideology_economic ==2)
replace left=. if ideology_economic==.
gen right=(ideology_economic ==4 | ideology_economic ==5)
replace right=. if ideology_economic==.
gen young=(age<45)
* Moved up with respect to father
gen moved_up=(job_prestige_father>3)
replace moved_up=. if job_prestige_father==.
* Immigrant
gen immigrant=(parents_born_in_country==0)
replace immigrant=. if parents_born_in_country==.

* Sum of Q4+Q5
gen q1_to_q4q5=q1_to_q4+q1_to_q5

* Make dummies for qualitative questions
gen low_to_middle_prob_d=(low_to_middle_prob>2)
replace low_to_middle_prob_d=. if low_to_middle_prob==.
drop low_to_middle_prob
rename low_to_middle_prob_d low_to_middle_prob

gen low_to_high_prob_d=(low_to_high_prob>2)
replace low_to_high_prob_d=. if low_to_high_prob==.
drop low_to_high_prob
rename low_to_high_prob_d low_to_high_prob 

label var cs_race_theil_2000 "Racial Segregation"
label var cs00_seg_inc "Income Segregation"
label var scap_ski90pcm "Social Capital Index"
label var gini "Gini"
label var cs_elf_ind_man "Manufacturing Share"
label var gradrate_r "College Grad Rate"

local Controls "i.round male young children_dummy rich right university_degree moved_up immigrant"

xi: reg q1_to_q1 cs_race_theil_2000 cs00_seg_inc scap_ski90pcm gini cs_elf_ind_man gradrate_r `Controls' if Treated==0, cluster(cz)
su q1_to_q1 if e(sample)
gen q1_to_q1_n = (q1_to_q1-r(mean))/r(sd) if e(sample)
foreach var in cs_race_theil_2000 cs00_seg_inc scap_ski90pcm gini cs_elf_ind_man gradrate_r {
su `var' if e(sample)
gen `var'_n = (`var'-r(mean))/r(sd) if e(sample)
}
label var cs_race_theil_2000_n "Racial Segregation"
label var cs00_seg_inc_n "Income Segregation"
label var scap_ski90pcm_n "Social Capital Index"
label var gini_n "Gini"
label var cs_elf_ind_man_n "Manufacturing Share"
label var gradrate_r_n "College Grad Rate"
reg q1_to_q1_n cs_race_theil_2000_n cs00_seg_inc_n scap_ski90pcm_n gini_n cs_elf_ind_man_n gradrate_r_n `Controls' if Treated==0, cluster(cz)
outreg using heterogeneity_perceptions_CZlevel_characteristics, se  keep(cs_race_theil_2000_n cs00_seg_inc_n scap_ski90pcm_n gini_n cs_elf_ind_man_n gradrate_r_n) ctitle("", "Q1 to Q1"\"", "(1)") summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) nocons tex fragment varlabels replace
drop q1_to_q1_n cs_race_theil_2000_n cs00_seg_inc_n scap_ski90pcm_n gini_n cs_elf_ind_man_n gradrate_r_n


xi: reg q1_to_q4q5 cs_race_theil_2000 cs00_seg_inc scap_ski90pcm gini cs_elf_ind_man gradrate_r `Controls' if Treated==0, cluster(cz)
su q1_to_q4q5 if e(sample)
gen q1_to_q4q5_n = (q1_to_q4q5-r(mean))/r(sd) if e(sample)
foreach var in cs_race_theil_2000 cs00_seg_inc scap_ski90pcm gini cs_elf_ind_man gradrate_r {
su `var' if e(sample)
gen `var'_n = (`var'-r(mean))/r(sd) if e(sample)
}
label var cs_race_theil_2000_n "Racial Segregation"
label var cs00_seg_inc_n "Income Segregation"
label var scap_ski90pcm_n "Social Capital Index"
label var gini_n "Gini"
label var cs_elf_ind_man_n "Manufacturing Share"
label var gradrate_r_n "College Grad Rate"
reg q1_to_q4q5_n cs_race_theil_2000_n cs00_seg_inc_n scap_ski90pcm_n gini_n cs_elf_ind_man_n gradrate_r_n `Controls' if Treated==0, cluster(cz)
outreg using heterogeneity_perceptions_CZlevel_characteristics, se  keep(cs_race_theil_2000_n cs00_seg_inc_n scap_ski90pcm_n gini_n cs_elf_ind_man_n gradrate_r_n) ctitle("", "Q1 to Q4 or Q5"\"", "(2)") summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) nocons tex fragment varlabels merge
drop q1_to_q4q5_n cs_race_theil_2000_n cs00_seg_inc_n scap_ski90pcm_n gini_n cs_elf_ind_man_n gradrate_r_n


xi: reg low_to_middle_prob cs_race_theil_2000 cs00_seg_inc scap_ski90pcm gini cs_elf_ind_man gradrate_r `Controls' if Treated==0, cluster(cz)
su low_to_middle_prob if e(sample)
gen low_to_middle_prob_n = (low_to_middle_prob-r(mean))/r(sd) if e(sample)
foreach var in cs_race_theil_2000 cs00_seg_inc scap_ski90pcm gini cs_elf_ind_man gradrate_r {
su `var' if e(sample)
gen `var'_n = (`var'-r(mean))/r(sd) if e(sample)
}
label var cs_race_theil_2000_n "Racial Segregation"
label var cs00_seg_inc_n "Income Segregation"
label var scap_ski90pcm_n "Social Capital Index"
label var gini_n "Gini"
label var cs_elf_ind_man_n "Manufacturing Share"
label var gradrate_r_n "College Grad Rate"
reg low_to_middle_prob_n cs_race_theil_2000_n cs00_seg_inc_n scap_ski90pcm_n gini_n cs_elf_ind_man_n gradrate_r_n `Controls' if Treated==0, cluster(cz)
outreg using heterogeneity_perceptions_CZlevel_characteristics, se  keep(cs_race_theil_2000_n cs00_seg_inc_n scap_ski90pcm_n gini_n cs_elf_ind_man_n gradrate_r_n) ctitle("", "Q1 to Q4 (Qual.)"\"", "(3)") summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) nocons tex fragment varlabels merge
drop low_to_middle_prob_n cs_race_theil_2000_n cs00_seg_inc_n scap_ski90pcm_n gini_n cs_elf_ind_man_n gradrate_r_n


xi: reg low_to_high_prob cs_race_theil_2000 cs00_seg_inc scap_ski90pcm gini cs_elf_ind_man gradrate_r `Controls' if Treated==0, cluster(cz)
su low_to_high_prob if e(sample)
gen low_to_high_prob_n = (low_to_high_prob-r(mean))/r(sd) if e(sample)
foreach var in cs_race_theil_2000 cs00_seg_inc scap_ski90pcm gini cs_elf_ind_man gradrate_r {
su `var' if e(sample)
gen `var'_n = (`var'-r(mean))/r(sd) if e(sample)
}
label var cs_race_theil_2000_n "Racial Segregation"
label var cs00_seg_inc_n "Income Segregation"
label var scap_ski90pcm_n "Social Capital Index"
label var gini_n "Gini"
label var cs_elf_ind_man_n "Manufacturing Share"
label var gradrate_r_n "College Grad Rate"
reg low_to_high_prob_n cs_race_theil_2000_n cs00_seg_inc_n scap_ski90pcm_n gini_n cs_elf_ind_man_n gradrate_r_n `Controls' if Treated==0, cluster(cz)
outreg using heterogeneity_perceptions_CZlevel_characteristics, se  keep(cs_race_theil_2000_n cs00_seg_inc_n scap_ski90pcm_n gini_n cs_elf_ind_man_n gradrate_r_n) ctitle("", "Q1 to Q5 (Qual.)"\"", "(4)") summstat(N) bdec(3) summtitle(Obs.) starloc(1) starlevels(10 5 1) nolegend sigsymbols(*,**,***) nocons tex fragment varlabels merge
drop low_to_high_prob_n cs_race_theil_2000_n cs00_seg_inc_n scap_ski90pcm_n gini_n cs_elf_ind_man_n gradrate_r_n



*********************************************************************************************
*********************************************************************************************
***	TABLE OA12: CORRELATION BETWEEN COMMUTING ZONE CHARACTERISTICS AND POLICY PREFERENCES *** 					
*********************************************************************************************
*********************************************************************************************

set more off

use "Data_CZ_Level_Analysis_US_Waves_BC.dta", clear

keep if Treated==0

keep if flag_1==0 & flag_2==0

*** Generate covariates of interest ***
* Income
gen rich=0
su household_income, d
replace rich=1 if household_income>r(p75)
replace rich=. if household_income==.

* Left and right
gen left=(ideology_economic ==1 | ideology_economic ==2)
replace left=. if ideology_economic==.
gen right=(ideology_economic ==4 | ideology_economic ==5)
replace right=. if ideology_economic==.
gen center=(ideology_economic ==3)
replace center=. if ideology_economic==.
* Young
gen young=(age<45)
* Moved up with respect to father
gen moved_up=(job_prestige_father>3)
replace moved_up=. if job_prestige_father==.
* Immigrant
gen immigrant=(parents_born_in_country==0)
replace immigrant=. if parents_born_in_country==.

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
	
* Table start
file open holder using temp_all_cz_characteristics_preferences.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lccccccccc} " _n
file write holder "&   & & Support & & Unequal Opp. & &  &  & \\" _n
file write holder "& Budget & Support & Equality & Government & Very Serious & Budget & Tax Rate & Tax Rate & Govt. \\" _n
file write holder "& Opp. & Estate Tax & Opp. Policies & Interv. & Problem & Safety Net & Top 1 & Bottom 50 & Tools \\" _n
file write holder "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) \\ \hline" _n
file close holder
* Table end
file open holder using temp_end.tex, write replace text
file write holder "\hline \end{tabular}\end{center} " _n
file close holder

local Controls "i.round male young children_dummy rich right left university_degree moved_up immigrant"

eststo clear

foreach y in budget_opportunities support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 {

xi: reg `y' cs_race_theil_2000 cs00_seg_inc cs_race_bla cs_born_foreign `Controls', cluster(cz)
* Standardize Variables
su `y' if e(sample)
gen `y'_n = (`y'-r(mean))/r(sd) if e(sample)
foreach var in cs_race_theil_2000 cs00_seg_inc cs_race_bla cs_born_foreign {
su `var' if e(sample)
gen `var'_n = (`var'-r(mean))/r(sd) if e(sample)
}
* Interactions
foreach x in cs_race_theil_2000 cs00_seg_inc cs_race_bla cs_born_foreign {
gen r_`x'_n=right*`x'_n
gen l_`x'_n=left*`x'_n
gen c_`x'_n=center*`x'_n

}
* Label variables
label var l_cs_race_theil_2000_n "Racial Segregation $\times$ Left"
label var l_cs00_seg_inc_n "Income Segregation $\times$ Left"
label var l_cs_race_bla_n "Frac. Black $\times$ Left"
label var l_cs_born_foreign_n "Frac. Foreign Born $\times$ Left"
label var r_cs_race_theil_2000_n "Racial Segregation $\times$ Right"
label var r_cs00_seg_inc_n "Income Segregation $\times$ Right"
label var r_cs_race_bla_n "Frac. Black $\times$ Right"
label var r_cs_born_foreign_n "Frac. Foreign Born $\times$ Right"

eststo: xi: reg `y'_n r_cs_race_theil_2000_n r_cs_race_bla_n r_cs_born_foreign_n l_cs_race_theil_2000_n l_cs_race_bla_n l_cs_born_foreign_n c_cs_race_theil_2000_n c_cs_race_bla_n c_cs_born_foreign_n `Controls', cluster(cz)

foreach var in r_cs_race_theil_2000_n r_cs00_seg_inc_n r_cs_race_bla_n r_cs_born_foreign_n l_cs_race_theil_2000_n l_cs00_seg_inc_n l_cs_race_bla_n l_cs_born_foreign_n c_cs_race_theil_2000_n c_cs00_seg_inc_n c_cs_race_bla_n c_cs_born_foreign_n cs_race_theil_2000_n cs00_seg_inc_n cs_race_bla_n cs_born_foreign_n {
drop `var'
}

}

xi: reg tools_d cs_race_theil_2000 cs00_seg_inc cs_race_bla cs_born_foreign `Controls', cluster(cz)
* Standardize Variables
su tools_d if e(sample)
gen tools_d_n = (tools_d-r(mean))/r(sd) if e(sample)
foreach var in cs_race_theil_2000 cs00_seg_inc cs_race_bla cs_born_foreign {
su `var' if e(sample)
gen `var'_n = (`var'-r(mean))/r(sd) if e(sample)
}
* Interactions
foreach x in cs_race_theil_2000 cs00_seg_inc cs_race_bla cs_born_foreign {
gen r_`x'_n=right*`x'_n
gen l_`x'_n=left*`x'_n
gen c_`x'_n=center*`x'_n

}
* Label variables
label var l_cs_race_theil_2000_n "Racial Segregation $\times$ Left"
label var l_cs00_seg_inc_n "Income Segregation $\times$ Left"
label var l_cs_race_bla_n "Frac. Black $\times$ Left"
label var l_cs_born_foreign_n "Frac. Foreign Born $\times$ Left"
label var r_cs_race_theil_2000_n "Racial Segregation $\times$ Right"
label var r_cs00_seg_inc_n "Income Segregation $\times$ Right"
label var r_cs_race_bla_n "Frac. Black $\times$ Right"
label var r_cs_born_foreign_n "Frac. Foreign Born $\times$ Right"

eststo: xi: reg tools_d_n r_cs_race_theil_2000_n r_cs_race_bla_n r_cs_born_foreign_n l_cs_race_theil_2000_n l_cs_race_bla_n l_cs_born_foreign_n c_cs_race_theil_2000_n c_cs_race_bla_n c_cs_born_foreign_n `Controls', cluster(cz)


esttab using temp_all_cz_characteristics_preferences_results.tex, replace fragment booktabs keep(r_cs_race_theil_2000_n r_cs_race_bla_n r_cs_born_foreign_n l_cs_race_theil_2000_n l_cs_race_bla_n l_cs_born_foreign_n) label /// 
star(* .1 ** .05 *** .01) se nonumbers nomtitles nolines compress stats(N, label("Obs.") fmt(0)) b(3)


appendfile temp_all_cz_characteristics_preferences_results.tex temp_all_cz_characteristics_preferences.tex
appendfile temp_end.tex temp_all_cz_characteristics_preferences.tex

erase temp_all_cz_characteristics_preferences_results.tex
erase temp_end.tex
	
	

**********************************************************************************
**********************************************************************************
***	TABLE OA13:  SUMMARY STATISTICS - ROLE OF GOVERNMENT   				       *** 					
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
drop ideology_economic


* Unequal opportunity is a problem
gen unequal_opp_problem_ser=(unequal_opportunities_problem>=2) 
replace unequal_opp_problem_ser=. if unequal_opportunities_problem==.

* Trust government dummy
gen trust_government_most=(trust_government>=2) /* at least sometimes  */
replace trust_government_most=. if trust_government==.

* Tools government
gen tools_government_some=(tools_government>=2) /* some or a lot */
replace tools_government_some=. if tools_government==.

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

gen All=1

foreach x in All US UK Italy France Sweden {	
foreach y in trust_government_most tools_government_some government_intervention lowering_taxes_better unequal_opp_problem_ser against_government_1{
su `y' if `x'==1
local `x'`y' : display %5.2f `r(mean)'
local obs_`x' : display %5.0f `r(N)'
}
cap mata drop A`x'
matrix A`x'=(``x'trust_government_most', ``x'tools_government_some', ``x'government_intervention', ``x'lowering_taxes_better', ``x'unequal_opp_problem_ser', ``x'against_government_1', `obs_`x'')
}

foreach x in All US UK Italy France Sweden {	
foreach y in trust_government_most tools_government_some government_intervention lowering_taxes_better unequal_opp_problem_ser against_government_1 {
su `y' if `x'==1 & left==1
local `x'`y'l : display %5.2f `r(mean)'
local obs_`x'l : display %5.0f `r(N)'
}
cap mata drop A`x'l
matrix A`x'l=(``x'trust_government_mostl', ``x'tools_government_somel', ``x'government_interventionl', ``x'lowering_taxes_betterl',  ``x'unequal_opp_problem_serl', ``x'against_government_1l', `obs_`x'l')
}

foreach x in All US UK Italy France Sweden {	
foreach y in trust_government_most tools_government_some government_intervention lowering_taxes_better unequal_opp_problem_ser against_government_1 {
su `y' if `x'==1 & right==1
local `x'`y'r : display %5.2f `r(mean)'
local obs_`x'r : display %5.0f `r(N)'
}
cap mata drop A`x'r
matrix A`x'r=(``x'trust_government_mostr', ``x'tools_government_somer', ``x'government_interventionr', ``x'lowering_taxes_betterr', ``x'unequal_opp_problem_serr', ``x'against_government_1r', `obs_`x'r')
}

matrix S=(.,.,.,.,.,.,.)

matrix B=S
matrix B=B\AAll
matrix B=B\AAlll
matrix B=B\AAllr 
matrix B=B\S 
matrix B=B\AUS 
matrix B=B\AUSl 
matrix B=B\AUSr 
matrix B=B\S 
matrix B=B\AUK 
matrix B=B\AUKl 
matrix B=B\AUKr 
matrix B=B\S 
matrix B=B\AFrance 
matrix B=B\AFrancel 
matrix B=B\AFrancer 
matrix B=B\S 
matrix B=B\AItaly 
matrix B=B\AItalyl 
matrix B=B\AItalyr 
matrix B=B\S 
matrix B=B\ASweden
matrix B=B\ASwedenl
matrix B=B\ASwedenr

mat colnames B= trust_government_most tools_government_some government_intervention lowering_taxes_better unequal_opp_problem_ser against_government_1
mat rownames B= All Mean Mean-left Mean-right US Mean Mean-left Mean-right UK Mean Mean-left Mean-right France Mean Mean-left Mean-right Italy Mean Mean-left Mean-right Sweden Mean Mean-left Mean-right
frmttable using summ_stats_government, statmat(B) tex fragment replace  center ///
		rtitle("\textbf{All Countries}"\All\Left\Right\"\textbf{US}"\All\Left\Right\"\textbf{UK}"\All\Left\Right\"\textbf{France}"\All\Left\Right\"\textbf{Italy}"\All\Left\Right\"\textbf{Sweden}"\All\Left\Right) ///
		ctitle("", Trust, Govt., Government, Lowering, Unequal Opp.,Negative View, Obs.\ "", Govt., Tools, Intervention, Taxes Better, Problem,of Government\ "", "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)") ///
		rtitlfont(it \ "" \ "" \ "" \ it \ "" \ "" \ "" \ it \ "" \ "" \ "" \ it \ "" \ "" \ "" \ it \ "" \ "" \ "" \ it \ "" \ "" \ "") ///
		sdec(2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0\2,2,2,2,2,2,0)

			 

**********************************************************************************
**********************************************************************************
***	TABLE OA14:  SUMMARY STATISTICS - TAXES - SPENDING					       *** 					
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
drop ideology_economic

* Generate variables
gen budget_opportunities=budget_education+budget_health
rename level_playing_field_policies support_equality_opp_pol

* Estate tax
gen support_estate_45=(estate_tax_support>=4)
replace support_estate_45=. if estate_tax_support==.

* Tax shares

gen total_income=.
replace total_income=909 if France==1
replace total_income=783 if Italy==1
replace total_income=951 if UK==1
replace total_income=1273 if Sweden==1
replace total_income=9.03 if US==1

gen tax_revenue=.
replace tax_revenue=181 if France==1
replace tax_revenue=149.6 if Italy==1
replace tax_revenue=157 if UK==1
replace tax_revenue=426.6 if Sweden==1
replace tax_revenue=1.23 if US==1

gen share_income_top1=.
replace share_income_top1=0.081 if France==1
replace share_income_top1=0.094 if Italy==1
replace share_income_top1=0.126 if UK==1
replace share_income_top1=0.0715 if Sweden==1
replace share_income_top1=0.19 if US==1

gen share_income_bottom50=.
replace share_income_bottom50=0.27 if France==1
replace share_income_bottom50=0.25 if Italy==1
replace share_income_bottom50=0.244 if UK==1
replace share_income_bottom50=0.2508 if Sweden==1
replace share_income_bottom50=0.115 if US==1

gen share_income_next40=.
replace share_income_next40=0.407 if France==1
replace share_income_next40=0.411 if Italy==1
replace share_income_next40=0.411 if UK==1
replace share_income_next40=0.4825 if Sweden==1
replace share_income_next40=0.426 if US==1

gen share_income_next9=.
replace share_income_next9=0.242 if France==1
replace share_income_next9=0.245 if Italy==1
replace share_income_next9=0.219 if UK==1
replace share_income_next9=0.1952 if Sweden==1
replace share_income_next9=0.269 if US==1

gen share_taxes_top1=(income_tax_top1*share_income_top1*total_income)/(tax_revenue*100)
gen share_taxes_bottom50=(income_tax_bottom50*share_income_bottom50*total_income)/(tax_revenue*100)
gen share_taxes_next40=(income_tax_next40*share_income_next40*total_income)/(tax_revenue*100)
gen share_taxes_next9=(income_tax_next9*share_income_next9*total_income)/(tax_revenue*100)
   
* drop a handful of observations that had problem with the budget slider   
gen tot=share_taxes_top1+share_taxes_bottom50+share_taxes_next40+share_taxes_next9
foreach x in income_tax_top1 income_tax_next9 income_tax_next40 income_tax_bottom50 ///
share_taxes_top1 share_taxes_bottom50 share_taxes_next40 share_taxes_next9 {
replace `x'=. if tot>1.05 & tot!=.
}
drop tot

gen All=1

rename Italy It
rename France Fr
rename Sweden Sw
rename All Al


foreach x in Al US UK It Fr Sw {	
foreach y in income_tax_top1 income_tax_next9 income_tax_bottom50 share_taxes_top1 share_taxes_bottom50 support_estate_45 budget_opportunities budget_safetynet support_equality_opp_pol{
su `y' if `x'==1
local `x'`y' : display %5.2f `r(mean)'
local obs_`x'`y' : display %5.0f `r(N)'
}
cap mata drop A`x'
matrix A`x'=(``x'income_tax_top1', ``x'income_tax_next9', ``x'income_tax_bottom50',  ``x'share_taxes_top1', ``x'share_taxes_bottom50', ``x'support_estate_45', ``x'budget_opportunities', ``x'budget_safetynet', ``x'support_equality_opp_pol', `obs_`x'income_tax_top1', `obs_`x'support_estate_45')
}

foreach x in Al US UK It Fr Sw {	
foreach y in income_tax_top1 income_tax_next9 income_tax_bottom50 share_taxes_top1 share_taxes_bottom50 support_estate_45 budget_opportunities budget_safetynet support_equality_opp_pol{
su `y' if `x'==1 & left==1
local `x'`y'l : display %5.2f `r(mean)'
local obs_`x'`y'l : display %5.0f `r(N)'
}
cap mata drop A`x'l
matrix A`x'l=(``x'income_tax_top1l', ``x'income_tax_next9l', ``x'income_tax_bottom50l',  ``x'share_taxes_top1l', ``x'share_taxes_bottom50l', ``x'support_estate_45l', ``x'budget_opportunitiesl', ``x'budget_safetynetl', ``x'support_equality_opp_poll', `obs_`x'income_tax_top1l', `obs_`x'support_estate_45l')
}

foreach x in Al US UK It Fr Sw {	
foreach y in income_tax_top1 income_tax_next9 income_tax_bottom50 share_taxes_top1 share_taxes_bottom50 support_estate_45 budget_opportunities budget_safetynet support_equality_opp_pol{
su `y' if `x'==1 & right==1
local `x'`y'r : display %5.2f `r(mean)'
local obs_`x'`y'r : display %5.0f `r(N)'
}
cap mata drop A`x'r
matrix A`x'r=(``x'income_tax_top1r', ``x'income_tax_next9r', ``x'income_tax_bottom50r',  ``x'share_taxes_top1r', ``x'share_taxes_bottom50r', ``x'support_estate_45r', ``x'budget_opportunitiesr', ``x'budget_safetynetr', ``x'support_equality_opp_polr', `obs_`x'income_tax_top1r', `obs_`x'support_estate_45r')
}


matrix S=(.,.,.,.,.,.,.,.,.,.,.)

matrix B=S
matrix B=B\AAl
matrix B=B\AAll
matrix B=B\AAlr 
matrix B=B\S 
matrix B=B\AUS 
matrix B=B\AUSl 
matrix B=B\AUSr 
matrix B=B\S 
matrix B=B\AUK 
matrix B=B\AUKl 
matrix B=B\AUKr 
matrix B=B\S 
matrix B=B\AFr 
matrix B=B\AFrl 
matrix B=B\AFrr 
matrix B=B\S 
matrix B=B\AIt
matrix B=B\AItl 
matrix B=B\AItr 
matrix B=B\S 
matrix B=B\ASw
matrix B=B\ASwl
matrix B=B\ASwr

mat colnames B= income_tax_top1 income_tax_next9 income_tax_bottom50 share_taxes_top1 share_taxes_bottom50 support_estate_45
mat rownames B= All Mean Mean-left Mean-right US Mean Mean-left Mean-right UK Mean Mean-left Mean-right France Mean Mean-left Mean-right Italy Mean Mean-left Mean-right Sweden Mean Mean-left Mean-right
frmttable using summ_stats_taxes_spending, statmat(B) tex fragment replace  center ///
		rtitle("\textbf{All Countries}"\All\Left\Right\"\textbf{US}"\All\Left\Right\"\textbf{UK}"\All\Left\Right\"\textbf{France}"\All\Left\Right\"\textbf{Italy}"\All\Left\Right\"\textbf{Sweden}"\All\Left\Right) ///
		ctitle("", Tax Rate, Tax Rate, Tax Rate, Share Taxes, Share Taxes, Support, Budget, Budget, Support Equality, Obs., Obs.\ "", Top 1, Next 9, Bottom 50, Top 1, Bottom 50, Estate Tax, Opportunities, Safety Net, Opp. Policies, 1-5,6-9\ "", (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11)) ///
		rtitlfont(it \ "" \ "" \ "" \ it \ "" \ "" \ "" \ it \ "" \ "" \ "" \ it \ "" \ "" \ "" \ it \ "" \ "" \ "" \ it \ "" \ "" \ "") ///
		sdec(2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0\2,2,2,2,2,2,2,2,2,0,0)


	


**********************************************************************************************
**********************************************************************************************
***	TABLE OA15: VIEWS OF GOVERNMENT AND POLICY PREFERECES - LEFT VERSUS RIGHT 			   ***					     	     			   *** 					
**********************************************************************************************
**********************************************************************************************	
	
	
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
gen tools_d=(tools_government >=2)
replace tools_d=. if tools_government==.
gen trust_d=(trust_government >=2)
replace trust_d=. if trust_government==.

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
gen lowering_taxes_better`x'=lowering_taxes_better*`x'
gen tools_d`x'=tools_d*`x'
gen trust_d`x'=trust_d*`x'
}

* Label variables
label var lowering_taxes_betterleft "Lowering taxes better $\times$ Left-Wing"
label var tools_dleft "Govt. Tools $\times$ Left-Wing"
label var trust_dleft "Trust Govt. $\times$ Left-Wing"
label var lowering_taxes_betterright "Lowering taxes better $\times$ Right-Wing"
label var tools_dright "Govt. Tools $\times$ Right-Wing"
label var trust_dright "Trust Govt. $\times$ Right-Wing"

* Table start
file open holder using table_leftright_govt_all.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lccccccc} " _n
file write holder "&   & & Support & & Unequal Opp. & &  \\" _n
file write holder "& Budget & Support & Equality & Government & Budget & Tax Rate & Tax Rate \\" _n
file write holder "& Opp. & Estate Tax & Opp. Policies & Interv. & Safety Net & Top 1 & Bottom 50 \\" _n
file write holder "& (1) & (2) & (3) & (4) & (5) & (6) & (7) \\ \hline" _n
file close holder
* Table end
file open holder using temp_end.tex, write replace text
file write holder "\hline \end{tabular}\end{center}" _n
file close holder

local Controls "i.country_survey left right center male young children_dummy rich university_degree immigrant moved_up"
	

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention budget_safetynet income_tax_top1 income_tax_bot50 {
eststo: xi: reg `var'  lowering_taxes_betterleft tools_dleft trust_dleft lowering_taxes_bettercenter tools_dcenter trust_dcenter lowering_taxes_betterright tools_dright trust_dright `Controls'
}
esttab using temp_all_results.tex, replace fragment booktabs keep(lowering_taxes_betterleft tools_dleft trust_dleft lowering_taxes_betterright tools_dright trust_dright) label /// 
star(* .1 ** .05 *** .01) se nonumbers stats( N, label("Observations") fmt(0)) nomtitles nolines compress b(3)

	
appendfile temp_all_results.tex table_leftright_govt_all.tex
appendfile temp_end.tex	table_leftright_govt_all.tex
	
	
erase temp_end.tex 
erase temp_all_results.tex	
	
	


**********************************************************************************************
**********************************************************************************************
***	TABLE OA16: CORRELATION BETWEEN VIEWS OF GOVERNMENT, POLICY PREFERENCES, AND PESSIMISM ***							   ***					     	     			   					
**********************************************************************************************
**********************************************************************************************	

set more off

* Open dataset
use "Data_Experiment_Waves_BC.dta", clear

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0
* Only control group
keep if Treated==0 

egen country_survey=group(country round)

* Tools dummy
gen tools_government_d=(tools_government<2) /* not much or nothing  */
replace tools_government_d=. if tools_government==.

* Unequal opportunities not a serious problem
gen unequal_opp_problem_d= (unequal_opportunities_problem<=2)
replace unequal_opp_problem_d=. if unequal_opportunities_problem==.

* Pessimism
gen optimistic=(low_to_high_prob>=3)
replace optimistic=. if low_to_high_prob==.
gen optimistic_2=(q1_to_q1 <true_q1_to_q1 )

* Low spending in opportunities
gen budget_opp=budget_education+budget_health
gen budget_opp_d=0
_pctile budget_opp, p(20)
replace budget_opp_d=1 if budget_opp<=r(r1) 
replace budget_opp_d=. if budget_opp==.

* Keep common sample
drop if tools_government_d==.
drop if lowering_taxes_better==.
drop if optimistic==.
drop if budget_opp_d==.
drop if unequal_opp_problem_d==.

mat T = J(10*4,4,.)

* Col 1
local i = 2
foreach v in unequal_opp_problem_d lowering_taxes_better budget_opp_d optimistic {
	xi: reg tools_government_d `v' i.country_survey
    mat T[`i',1] = _b[`v']
    mat T[`i'+1,1] = _se[`v']
	qui test `v'
	mat T[`i'+20,1] = r(p)
    local i = `i' + 3
}

* Col 2
local i = 5
foreach v in lowering_taxes_better budget_opp_d optimistic {
	xi: reg unequal_opp_problem_d `v' i.country_survey
    mat T[`i',2] = _b[`v']
    mat T[`i'+1,2] = _se[`v']
	qui test `v'
	mat T[`i'+20,2] = r(p)
    local i = `i' + 3
}

* Col 3
local i = 8
foreach v in budget_opp_d optimistic {
	xi: reg lowering_taxes_better `v' i.country_survey
    mat T[`i',3] = _b[`v']
    mat T[`i'+1,3] = _se[`v']
	qui test `v'
	mat T[`i'+20,3] = r(p)
    local i = `i' + 3
}

* Col 4
local i = 11
foreach v in  optimistic {
xi: reg budget_opp_d `v' i.country_survey
    mat T[`i',4] = _b[`v']
    mat T[`i'+1,4] = _se[`v']
	qui test `v'
	mat T[`i'+20,4] = r(p)
    local i = `i' + 3
}

svmat T

local allvar T1 T2 T3 T4
foreach v in `allvar' {
	forvalues cell = 1 / 15 { 
		replace `v' = round(`v',1)    if abs(`v'/100) > 1  & _n==`cell'
		replace `v' = round(`v',.001) if abs(`v'/100) <= 1 & _n==`cell'
	}
	
	g str_`v' = string(`v', "%9.3f")
	replace str_`v'=subinstr(str_`v',".000","",.)
	
	forvalues cell=2(3)15 {
		replace str_`v'="("+str_`v'+")" if _n==`cell'+1
		replace str_`v'=str_`v'+"***" if _n==`cell' & `v'[`cell'+20]<=0.01
		replace str_`v'=str_`v'+"**" if _n==`cell' &  `v'[`cell'+20]>0.01 & `v'[`cell'+20]<=0.05
		replace str_`v'=str_`v'+"*" if _n==`cell' &  `v'[`cell'+20]>0.05 & `v'[`cell'+20]<=0.1
	}
}

* Add a variable with names on the rows
g varname = ""
local i = 2
foreach v in unequal_opp_problem_d lowering_taxes_better budget_opp_d optimistic {
replace varname = "`v'" if _n == `i'
local i = `i' + 3
}

* Add a variable with names on the columns
local i = 1
foreach v in tools_government_d unequal_opp_problem_d lowering_taxes_better budget_opp_d {
	replace str_T`i' = "`v'" if _n==1
local i = `i' + 1
}



local last_line=12
export excel varname str_T1 str_T2 str_T3 str_T4 if _n<=`last_line' using "tables", sheetreplace sheet("t24") firstrow(variables)


xi: reg tools_government_d unequal_opp_problem_d i.country_survey
xi: reg tools_government_d lowering_taxes_better i.country_survey
xi: reg tools_government_d budget_opp_d i.country_survey
xi: reg tools_government_d optimistic i.country_survey
xi: reg unequal_opp_problem_d lowering_taxes_better  i.country_survey
xi: reg unequal_opp_problem_d budget_opp_d  i.country_survey
xi: reg unequal_opp_problem_d optimistic  i.country_survey
xi: reg lowering_taxes_better budget_opp_d i.country_survey
xi: reg lowering_taxes_better optimistic i.country_survey
xi: reg budget_opp_d optimistic i.country_survey

* .tex Matrix_types created from the excel file 




******************************************************************************************
******************************************************************************************
***	TABLE OA17-OA21:  PESSIMISM AND OPTIMISM CORRELATED WITH POLICIES BY COUNTRY       *** 					
******************************************************************************************
******************************************************************************************		
	
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



**** by country ****

save "temp.dta", replace

foreach x in US UK France Italy Sweden {

use "temp.dta", clear
keep if `x'==1


* Table start
file open holder using table_correlations_mobility_policy_`x'.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lccccccccc} " _n
file write holder "&   & & Support & & Unequal Opp. & &  &  & \\" _n
file write holder "& Budget & Support & Equality & Government & Very Serious & Budget & Tax Rate & Tax Rate & Govt. \\" _n
file write holder "& Opp. & Estate Tax & Opp. Policies & Interv. & Problem & Safety Net & Top 1 & Bottom 50 & Tools \\" _n
file write holder "& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) \\ \hline" _n
file close holder

local Controls "i.country_survey left right center male young children_dummy rich university_degree immigrant moved_up"

*** Q1 to Q1 ***

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 tools_d {
eststo: xi: reg `var'  q1_to_q1_left q1_to_q1_right q1_to_q1_center `Controls'
test q1_to_q1_left= q1_to_q1_right
local `var'_1: display %5.3f `r(p)'
}
esttab using temp_all_Q1.tex, replace fragment booktabs keep(q1_to_q1_left q1_to_q1_right) label /// 
star(* .1 ** .05 *** .01) se nonumbers noobs nomtitles nolines compress b(3)


*** Q1 to Q5 ***

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 tools_d {
eststo: xi: reg `var'  q1_to_q5_left q1_to_q5_right q1_to_q5_center `Controls'
test q1_to_q5_left= q1_to_q5_right
local `var'_5: display %5.3f `r(p)'
su q1_to_q5_left if e(sample)==1
local `var'_o : display %5.0f `r(N)'
}
esttab using temp_all_Q5.tex, replace fragment booktabs keep(q1_to_q5_left q1_to_q5_right) label /// 
star(* .1 ** .05 *** .01) se nonumbers noobs nomtitles nolines compress b(3)


*** Q1 to Q1 effort ***

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 tools_d {
eststo: xi: reg `var'  q1_to_q1_effort_left q1_to_q1_effort_right q1_to_q1_effort_center `Controls'
test q1_to_q1_effort_left= q1_to_q1_effort_right
local `var'_1e: display %5.3f `r(p)'
}
esttab using temp_all_Q1_effort.tex, replace fragment booktabs keep(q1_to_q1_effort_left q1_to_q1_effort_right) label /// 
star(* .1 ** .05 *** .01) se nonumbers noobs nomtitles nolines compress b(3)


*** Q1 to Q5 effort ***

eststo clear

foreach var in budget_opp support_estate_45 support_eq_opp_pol government_intervention unequal_opp_problem_d budget_safetynet income_tax_top1 income_tax_bot50 tools_d {
eststo: xi: reg `var'  q1_to_q5_effort_left q1_to_q5_effort_right q1_to_q5_effort_center `Controls'
test q1_to_q5_effort_left= q1_to_q5_effort_right
local `var'_5e: display %5.3f `r(p)'
su q1_to_q5_effort_left if e(sample)==1
local `var'_oe : display %5.0f `r(N)'
}
esttab using temp_all_Q5_effort.tex, replace fragment booktabs keep(q1_to_q5_effort_left q1_to_q5_effort_right) label /// 
star(* .1 ** .05 *** .01) se nonumbers noobs nomtitles nolines compress b(3)


* Table headers
file open holder using temp_q1_header.tex, write replace text
file write holder "\multicolumn{5}{l}{\textbf{\textit{A. Unconditional Beliefs}}} \\" _n
file close holder
file open holder using temp_q5_header.tex, write replace text
file write holder " & & & & & & & & & \\" _n
file write holder "p-value diff. & `budget_opp_1' & `support_estate_45_1' & `support_eq_opp_pol_1' & `government_intervention_1' & `unequal_opp_problem_d_1' &  `budget_safetynet_1' & `income_tax_top1_1' & `income_tax_bot50_1'  & `tools_d_1'  \\" _n
file write holder " & & & & & & & & & \\" _n
file close holder
file open holder using temp_q1_effort_header.tex, write replace text
file write holder " & & & & & & & & & \\" _n
file write holder "p-value diff. & `budget_opp_5' & `support_estate_45_5' & `support_eq_opp_pol_5' & `government_intervention_5' & `unequal_opp_problem_d_5' &  `budget_safetynet_5' & `income_tax_top1_5' & `income_tax_bot50_5'  & `tools_d_5'  \\" _n
file write holder "Observations & `budget_opp_o' & `support_estate_45_o' & `support_eq_opp_pol_o' & `government_intervention_o' & `unequal_opp_problem_d_o' &  `budget_safetynet_o' & `income_tax_top1_o' & `income_tax_bot50_o'  & `tools_d_o' \\" _n
file write holder " & & & & & & & & & \\" _n
file write holder " & & & & & & & & & \\" _n
file write holder "\multicolumn{5}{l}{\textbf{\textit{B. Beliefs Conditional On Effort}}} \\" _n
file close holder
file open holder using temp_q5_effort_header.tex, write replace text
file write holder " & & & & & & & & & \\" _n
file write holder "p-value diff. & `budget_opp_1e' & `support_estate_45_1e' & `support_eq_opp_pol_1e' & `government_intervention_1e' & `unequal_opp_problem_d_1e' &  `budget_safetynet_1e' & `income_tax_top1_1e' & `income_tax_bot50_1e'  & `tools_d_1e'  \\" _n
file write holder " & & & & & & & & & \\" _n
file close holder

* Table end
file open holder using temp_end.tex, write replace text
file write holder " & & & & & & & & & \\" _n
file write holder "p-value diff. & `budget_opp_5e' & `support_estate_45_5e' & `support_eq_opp_pol_5e' & `government_intervention_5e' & `unequal_opp_problem_d_5e' &  `budget_safetynet_5e' & `income_tax_top1_5e' & `income_tax_bot50_5e'  & `tools_d_5e'  \\" _n
file write holder "Observations & `budget_opp_oe' & `support_estate_45_oe' & `support_eq_opp_pol_oe' & `government_intervention_oe' & `unequal_opp_problem_d_oe' &  `budget_safetynet_oe' & `income_tax_top1_oe' & `income_tax_bot50_oe'  & `tools_d_oe' \\" _n
file write holder "\hline \end{tabular}\end{center}" _n
file close holder

appendfile temp_q1_header.tex table_correlations_mobility_policy_`x'.tex
appendfile temp_all_Q1.tex table_correlations_mobility_policy_`x'.tex
appendfile temp_q5_header.tex table_correlations_mobility_policy_`x'.tex
appendfile temp_all_Q5.tex table_correlations_mobility_policy_`x'.tex
appendfile temp_q1_effort_header.tex table_correlations_mobility_policy_`x'.tex
appendfile temp_all_Q1_effort.tex table_correlations_mobility_policy_`x'.tex
appendfile temp_q5_effort_header.tex table_correlations_mobility_policy_`x'.tex
appendfile temp_all_Q5_effort.tex table_correlations_mobility_policy_`x'.tex
appendfile temp_end.tex table_correlations_mobility_policy_`x'.tex
  
erase temp_q1_header.tex
erase temp_q5_header.tex
erase temp_q1_effort_header.tex
erase temp_q5_effort_header.tex
erase temp_end.tex
erase temp_all_Q1.tex
erase temp_all_Q5.tex
erase temp_all_Q1_effort.tex
erase temp_all_Q5_effort.tex

}
erase "temp.dta"




**********************************************************************************
**********************************************************************************
***	TABLE OA22-OA23: PERSISTENCE OF FIRST STAGE EFFECTS BY LEFT AND RIGHT	   *** 					
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

******** TABLES LEFT AND RIGHT********

foreach p in left right {

local Controls "i.round left right center male young children_dummy rich university_degree immigrant moved_up"

foreach var in q1_to_q1 q1_to_q2 q1_to_q3 q1_to_q4 q1_to_q5 low_to_middle_prob {

eststo clear

preserve
keep if flag_1==0 & flag_2==0 
eststo: xi: reg `var' Treated `Controls' if `p'==1
su `var' if Treated==0 & e(sample)==1
estadd scalar m`var' = `r(mean)'
restore

preserve
keep if flag_1==0 & flag_2==0 
eststo: xi: reg `var' Treated `Controls' if complete_fu==1 & `p'==1
su `var' if Treated==0 & e(sample)==1
estadd scalar m`var' = `r(mean)'
restore

preserve
keep if flag_1==0 & flag_2==0 
eststo: xi: reg `var'_fu Treated `Controls' if complete_fu==1 & `p'==1
su `var' if Treated==0 & e(sample)==1
estadd scalar m`var' = `r(mean)'
restore

esttab using temp_`var'.tex, replace fragment booktabs keep(Treated) label /// 
star(* .1 ** .05 *** .01) se nonumbers nomtitles nolines noobs compress b(3)

}

eststo clear

preserve
keep if flag_1==0 & flag_2==0 
eststo: xi: reg low_to_high_prob Treated `Controls' if `p'==1
su low_to_high_prob if Treated==0 & e(sample)==1 
estadd scalar mlow_to_high_prob = `r(mean)'
restore

preserve
keep if flag_1==0 & flag_2==0 
eststo: xi: reg low_to_high_prob Treated `Controls' if complete_fu==1 & `p'==1
su low_to_high_prob if Treated==0 & e(sample)==1
estadd scalar mlow_to_high_prob = `r(mean)'
restore

preserve
keep if flag_1==0 & flag_2==0 
eststo: xi: reg low_to_high_prob_fu Treated `Controls' if complete_fu==1 & `p'==1
su low_to_high_prob_fu if Treated==0 & e(sample)==1
estadd scalar mlow_to_high_prob = `r(mean)'
restore

esttab using temp_low_to_high_prob.tex, replace fragment booktabs keep(Treated) label /// 
star(* .1 ** .05 *** .01) se nonumbers nomtitles nolines compress stats(N, label("Obs.") fmt(0)) b(3)


* Table start
file open holder using table_firststage_follow_up_`p'.tex, write replace text
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
appendfile temp_header_`var'.tex table_firststage_follow_up_`p'.tex
appendfile temp_`var'.tex table_firststage_follow_up_`p'.tex
}
appendfile temp_end.tex table_firststage_follow_up_`p'.tex

erase temp_end.tex
foreach var in q1_to_q1 q1_to_q2 q1_to_q3 q1_to_q4 q1_to_q5 low_to_middle_prob low_to_high_prob {
erase temp_`var'.tex
erase temp_header_`var'.tex
}

}


***************************************************************************
***************************************************************************
***	TABLE OA24: CORRELATION BETWEEN MOBILITY AND INEQUALITY PERCEPTIONS ***									  					     	     			   					
***************************************************************************
***************************************************************************

set more off

use "Data_Inequality_Perceptions_US.dta", clear
		
* misperceptions
forvalues q=1(1)5 {
gen misp_q1_to_q`q'=(q1_to_q`q'-true_q1_to_q`q')/true_q1_to_q`q'
}

foreach x in income_top1 income_top10  wealth_top1 wealth_top10 capital_top1 capital_top10 {
gen misp_`x'=(share_`x'-share_`x'_true)/share_`x'_true
}
gen misp_incometax_top1=(current_incometax_top1-income_tax_top1_true)/income_tax_top1_true

gen over_q1_to_q1=(misp_q1_to_q1>0)
gen over_q1_to_q5=(misp_q1_to_q5>0)
foreach x in income_top1 income_top10  wealth_top1 wealth_top10 capital_top1 capital_top10 incometax_top1 {
gen over_`x'=(misp_`x'>0)
}

* Left and right
gen left=(ideology_economic ==1 | ideology_economic ==2)
replace left=. if ideology_economic==.
gen right=(ideology_economic ==4 | ideology_economic ==5)
replace right=. if ideology_economic==.
gen center=(ideology_economic==3)
replace center=. if ideology_economic==.

*Rich
gen rich=0
su household_income, d
replace rich=1 if household_income>r(p75)
replace rich=. if household_income==.
 
*Young
gen young=(age<45)
 
* Immigrant
gen immigrant=(parents_born_in_country==0)
replace immigrant=. if parents_born_in_country==.

label var q1_to_q1 "Q1 to Q1"
label var over_q1_to_q1 "Overestimate Q1 to Q1"
label var over_q1_to_q5 "Overestimate Q1 to Q5"


* Table start
file open holder using table_inequality_perc.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lccccccc} \hline\hline " _n
file write holder " & (1) & (2) & (3) & (4) & (5) & (6) & (7) \\ " _n
file write holder "&  & &  &  &  &  & \\  " _n
file write holder "\textit{\textbf{Panel A:}} & Perceived & Perceived & Perceived & Perceived & Perceived & Perceived & Perceived \\" _n
file write holder "& Share & Share & Share & Share & Share & Share & Average \\" _n
file write holder "& Income & Income & Capital & Capital & Wealth & Wealth & Tax Rate \\" _n
file write holder " & Top 1 & Top 10 & Top 1 & Top 10 & Top 1 & Top 10 & Top 1 \\" _n
file close holder

local Controls "left right male young children_dummy rich university_degree immigrant"

eststo clear
	
foreach var in income_top1 income_top10 wealth_top1 wealth_top10 capital_top1 capital_top10 {
eststo: xi: reg share_`var' q1_to_q1 `Controls'
}
eststo: xi: reg current_incometax_top1 q1_to_q1 `Controls'
esttab using temp_results_perc.tex, replace fragment booktabs keep(q1_to_q1) label /// 
nostar se nonumbers nomtitles nolines compress noobs b(3)

eststo clear
	
foreach var in income_top1 income_top10 wealth_top1 wealth_top10 capital_top1 capital_top10 incometax_top1 {
eststo: xi: reg over_`var' over_q1_to_q1 `Controls'
}
esttab using temp_results_over1.tex, replace fragment booktabs keep(over_q1_to_q1) label /// 
nostar se nonumbers nomtitles nolines compress noobs b(3)

eststo clear
	
foreach var in income_top1 income_top10 wealth_top1 wealth_top10 capital_top1 capital_top10 incometax_top1 {
eststo: xi: reg over_`var' over_q1_to_q5 `Controls'
su over_q1_to_q5 if e(sample)==1
local `var'_o : display %5.0f `r(N)'
}
esttab using temp_results_over5.tex, replace fragment booktabs keep(over_q1_to_q5) label /// 
nostar se nonumbers nomtitles nolines compress noobs b(3)


* Table headers
file open holder using temp_header_1.tex, write replace text
file write holder "&  & &  &  &  &  & \\ \hline " _n
file write holder "\textit{\textbf{Panel B:}} & Overestimate & Overestimate & Overestimate & Overestimate & Overestimate & Overestimate & Overestimate \\" _n
file write holder "& Share & Share & Share & Share & Share & Share & Average \\" _n
file write holder "& Income & Income & Capital & Capital & Wealth & Wealth & Tax Rate \\" _n
file write holder " & Top 1 & Top 10 & Top 1 & Top 10 & Top 1 & Top 10 & Top 1 \\" _n
file close holder
file open holder using temp_header_2.tex, write replace text
file write holder "&  & &  &  &  &  & \\ \hline " _n
file write holder "\textit{\textbf{Panel C:}} & Overestimate & Overestimate & Overestimate & Overestimate & Overestimate & Overestimate & Overestimate \\" _n
file write holder "& Share & Share & Share & Share & Share & Share & Average \\" _n
file write holder "& Income & Income & Capital & Capital & Wealth & Wealth & Tax Rate \\" _n
file write holder " & Top 1 & Top 10 & Top 1 & Top 10 & Top 1 & Top 10 & Top 1 \\" _n
file close holder
* Table end
file open holder using temp_end.tex, write replace text
file write holder " &  & &  &  &  &  &  \\" _n
file write holder " &  & &  &  &  &  &  \\" _n
file write holder "Observations & `income_top1_o' & `income_top10_o' & `wealth_top1_o' & `wealth_top10_o' & `capital_top1_o' & `capital_top10_o' & `incometax_top1_o' \\" _n
file write holder "\hline \hline \end{tabular}\end{center}" _n
file close holder


appendfile temp_results_perc.tex table_inequality_perc.tex
appendfile temp_header_1.tex table_inequality_perc.tex
appendfile temp_results_over1.tex table_inequality_perc.tex
appendfile temp_header_2.tex table_inequality_perc.tex
appendfile temp_results_over5.tex table_inequality_perc.tex
appendfile temp_end.tex table_inequality_perc.tex

erase temp_end.tex
erase temp_results_perc.tex
erase temp_results_over1.tex
erase temp_results_over5.tex
erase temp_header_1.tex
erase temp_header_2.tex
