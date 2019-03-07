***********************************
* (Project 7_Mobility)
*
* (Hoang Nhan Le and Zhengxiao Qin)
* 
* (May 10th,2018)
***********************************



cd "$path"
cd logs
log using "logtab6_female", text replace

cd "$path"
cd dataset
**********************************************************************************
***	TABLE 6:  TREATMENT EFFECTS ON POLICY PREFERENCES			       	       *** 					
**********************************************************************************
**********************************************************************************		

* Open dataset
use "Data_Experiment_Waves_BC.dta", clear

drop if male==1


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
file open holder using tab6_treatment_effects_female.tex, write replace text
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

appendfile temp_reduced_header_panelA.tex tab6_treatment_effects_female.tex
appendfile temp_reduced_PanelA.tex tab6_treatment_effects_female.tex
appendfile temp_reduced_header_panelB.tex tab6_treatment_effects_female.tex
appendfile temp_reduced_PanelB.tex tab6_treatment_effects_female.tex
appendfile temp_IV_header_panelC.tex tab6_treatment_effects_female.tex
appendfile temp_IV_PanelC.tex tab6_treatment_effects_female.tex
appendfile temp_IV_header_panelD.tex tab6_treatment_effects_female.tex
appendfile temp_IV_PanelD.tex tab6_treatment_effects_female.tex
appendfile temp_end.tex tab6_treatment_effects_female.tex	

erase temp_reduced_header_panelA.tex
erase temp_reduced_PanelA.tex
erase temp_reduced_header_panelB.tex
erase temp_reduced_PanelB.tex
erase temp_IV_header_panelC.tex
erase temp_IV_PanelC.tex
erase temp_IV_header_panelD.tex
erase temp_IV_PanelD.tex
erase temp_end.tex

		****** (rest of the do file

log close
