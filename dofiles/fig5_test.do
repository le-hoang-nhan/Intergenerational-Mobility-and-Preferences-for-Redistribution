***********************************
* (Project 7_Mobility)
*
* (Hoang Nhan Le and Zhengxiao Qin)
* 
* (May 10th,2018)
***********************************
cd "$path"
cd logs

* Log file inside your personal folder
log using "figure5_test", text replace

cd "$path"
cd dataset
*******************************************************************
*******************************************************************
*** FIGURE 5: ROLE OF EFFORT - BASELINE VS CONDITIONAL BELIEFS  ***
*******************************************************************
*******************************************************************
* Open dataset
use "Data_Descriptive_Waves_ABC.dta", clear	

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Only control group
keep if Treated==0


preserve 

keep if US == 1

forvalues i=1(1)5 {
ttest q1_to_q`i'_effort = q1_to_q`i' if male == 0
local US_male_diff_q`i': dis %4.3f `r(p)'
}


forvalues i=1(1)5 {
ttest q1_to_q`i'_effort = q1_to_q`i' if male == 1
local US_female_diff_q`i': dis %4.3f `r(p)'
}

restore



preserve 

keep if US != 1

forvalues i=1(1)5 {
ttest q1_to_q`i'_effort = q1_to_q`i' if male == 0
local EU_male_diff_q`i': dis %4.3f `r(p)'
}


forvalues i=1(1)5 {
ttest q1_to_q`i'_effort = q1_to_q`i' if male == 1
local EU_female_diff_q`i': dis %4.3f `r(p)'
}

restore



preserve 

keep if UK == 1

forvalues i=1(1)5 {
ttest q1_to_q`i'_effort = q1_to_q`i' if male == 0
local UK_male_diff_q`i': dis %4.3f `r(p)'
}


forvalues i=1(1)5 {
ttest q1_to_q`i'_effort = q1_to_q`i' if male == 1
local UK_female_diff_q`i': dis %4.3f `r(p)'
}

restore


preserve 

keep if France == 1

forvalues i=1(1)5 {
ttest q1_to_q`i'_effort = q1_to_q`i' if male == 0
local France_male_diff_q`i': dis %4.3f `r(p)'
}


forvalues i=1(1)5 {
ttest q1_to_q`i'_effort = q1_to_q`i' if male == 1
local France_female_diff_q`i': dis %4.3f `r(p)'
}

restore


preserve 

keep if Italy == 1

forvalues i=1(1)5 {
ttest q1_to_q`i'_effort = q1_to_q`i' if male == 0
local Italy_male_diff_q`i': dis %4.3f `r(p)'
}


forvalues i=1(1)5 {
ttest q1_to_q`i'_effort = q1_to_q`i' if male == 1
local Italy_female_diff_q`i': dis %4.3f `r(p)'
}

restore


preserve 

keep if Sweden == 1

forvalues i=1(1)5 {
ttest q1_to_q`i'_effort = q1_to_q`i' if male == 0
local Sweden_male_diff_q`i': dis %4.3f `r(p)'
}
forvalues i=1(1)5 {
ttest q1_to_q`i'_effort = q1_to_q`i' if male == 1
local Sweden_female_diff_q`i': dis %4.3f `r(p)'
}

restore


mat A = (`US_female_diff_q5',`US_male_diff_q5',`US_female_diff_q4',`US_male_diff_q4',`US_female_diff_q3',`US_male_diff_q3',`US_female_diff_q2',`US_male_diff_q2',`US_female_diff_q1',`US_male_diff_q1')
mat B = (`UK_female_diff_q5',`UK_male_diff_q5',`UK_female_diff_q4',`UK_male_diff_q4',`UK_female_diff_q3',`UK_male_diff_q3',`UK_female_diff_q2',`UK_male_diff_q2',`UK_female_diff_q1',`UK_male_diff_q1')
mat C = (`France_female_diff_q5',`France_male_diff_q5',`France_female_diff_q4',`France_male_diff_q4',`France_female_diff_q3',`France_male_diff_q3',`France_female_diff_q2',`France_male_diff_q2',`France_female_diff_q1',`France_male_diff_q1')
mat D = (`Italy_female_diff_q5',`Italy_male_diff_q5',`Italy_female_diff_q4',`Italy_male_diff_q4',`Italy_female_diff_q3',`Italy_male_diff_q3',`Italy_female_diff_q2',`Italy_male_diff_q2',`Italy_female_diff_q1',`Italy_male_diff_q1')
mat E = (`Sweden_female_diff_q5',`Sweden_male_diff_q5',`Sweden_female_diff_q4',`Sweden_male_diff_q4',`Sweden_female_diff_q3',`Sweden_male_diff_q3',`Sweden_female_diff_q2',`Sweden_male_diff_q2',`Sweden_female_diff_q1',`Sweden_male_diff_q1')
mat F = (`EU_female_diff_q5',`EU_male_diff_q5',`EU_female_diff_q4',`EU_male_diff_q4',`EU_female_diff_q3',`EU_male_diff_q3',`EU_female_diff_q2',`EU_male_diff_q2',`EU_female_diff_q1',`EU_male_diff_q1')



mat A = A\B
mat A = A\C
mat A = A\D
mat A = A\E
mat A = A\F
 


*matrix rownames A = US UK France Italy Sweden EU
*matrix colnames A = Female Male "" Female Male "" Female Male "" Female Male "" Female Male
mat list A

frmttable using figure5_test, statmat(A) sdec(3) title("Different Opinions about Effort within Gender Group Across Countries") replace     ///
             ctitles("", "{\ul Q1 to Q5}", "{\ul Q1 to Q4}", "{\ul Q1 to Q3}", "{\ul Q1 to Q2}","{\ul Q1 to Q1}" \                  ///
                 "","Female","Male","Female","Male","Female","Male","Female","Male","Female","Male")                     ///
             multicol(1,2,2;1,4,2;1,6,2;1,8,2;1,10,2)                                               ///
             rtitles("US"\"UK" \"France"\"Italy"\"Sweden"\"EU") ///

log close


