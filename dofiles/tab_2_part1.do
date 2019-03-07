***********************************
* (Project 7_Mobility)
*
* (Hoang Nhan Le and Zhengxiao Qin)
* 
* (May 10th,2018)
***********************************

* Log file inside your personal folder
cd "$path"
cd logs
log using "logtable_2_part1", text replace

cd "$path"
cd dataset
**********************************************************************************
**********************************************************************************
***	TABLE 2:  REAL AND PERCEIVED TRANSITION PROBABILITIES					   *** 					
**********************************************************************************
**********************************************************************************	

* Open dataset
use "Data_Descriptive_Waves_ABC.dta", clear	

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Only control group
keep if Treated==0

* Table Panel A
file open holder using tab2_table_mobility_summ_part1.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lccccccccccccccccc} " _n
file write holder " & \multicolumn{2}{c}{\textbf{US}} & & \multicolumn{2}{c}{\textbf{UK}} & & \multicolumn{2}{c}{\textbf{France}} & & \multicolumn{2}{c}{\textbf{Italy}} & & \multicolumn{2}{c}{\textbf{Sweden}} & & \multicolumn{2}{c}{\textbf{US vs EU}} \\" _n
file write holder " \cline{2-3} \cline{5-6} \cline{8-9} \cline{11-12} \cline{14-15} \cline{17-18} " _n
file write holder " & Female & Male & & Female & Male & & Female & Male & & Female & Male & & Female & Male & & Female - Male in US & Female - Male in EU \\ " _n
file write holder "& (1) & (2) & & (3) & (4) & & (5) & (6) & & (7) & (8) & & (9) & (10) & & (11) & (12) \\" _n
file close holder

forvalues q=1(1)5 {
label var q1_to_q`q' "Q1 to Q`q'"
}

* Panel A

cap mata drop A
cap mata drop C

su q1_to_q5 if US==1&male==0
local q5_US_female : display %5.2f `r(mean)'
su q1_to_q5 if US!=1&male==0
local q5_EU_female : display %5.2f `r(mean)'
su q1_to_q5 if UK==1&male==0
local q5_UK_female : display %5.2f `r(mean)'
su q1_to_q5 if France==1&male==0
local q5_France_female : display %5.2f `r(mean)'
su q1_to_q5 if Italy==1&male==0
local q5_Italy_female : display %5.2f `r(mean)'
su q1_to_q5 if Sweden==1&male==0
local q5_Sweden_female : display %5.2f `r(mean)'

su q1_to_q5 if US==1&male==1
local q5_US_male : display %5.2f `r(mean)'
su q1_to_q5 if US!=1&male==1
local q5_EU_male : display %5.2f `r(mean)'
su q1_to_q5 if UK==1&male==1
local q5_UK_male : display %5.2f `r(mean)'
su q1_to_q5 if France==1&male==1
local q5_France_male : display %5.2f `r(mean)'
su q1_to_q5 if Italy==1&male==1
local q5_Italy_male : display %5.2f `r(mean)'
su q1_to_q5 if Sweden==1&male==1
local q5_Sweden_male : display %5.2f `r(mean)'

ttest q1_to_q5 if US==1, by(male)
local p_US: display %5.4f `r(p)'
ttest q1_to_q5 if UK==1, by(male)
local p_UK: display %5.4f `r(p)'
ttest q1_to_q5 if US==1, by(male)
local p_France: display %5.4f `r(p)'
ttest q1_to_q5 if Italy==1, by(male)
local p_Italy: display %5.4f `r(p)'
ttest q1_to_q5 if Sweden==1, by(male)
local p_Sweden: display %5.4f `r(p)'
ttest q1_to_q5 if US!=1, by(male)
local p_EU: display %5.4f `r(p)'

local diff_q1_to_q5_US = `q5_US_female' - `q5_US_male'
local diff_q1_to_q5_EU = `q5_EU_female' - `q5_EU_male'


cap mata drop A
matrix A = (`q5_US_female',`q5_US_male',.,`q5_UK_female',`q5_UK_male',.,`q5_France_female',`q5_France_male',.,`q5_Italy_female',`q5_Italy_male',.,`q5_Sweden_female',`q5_Sweden_male',.,`diff_q1_to_q5_US',`diff_q1_to_q5_EU')
cap mata drop B
matrix B = (.,`p_US',.,.,`p_UK',.,.,`p_France',.,.,`p_Italy',.,.,`p_Sweden',.,`p_US',`p_EU')
matrix A=A\B 


********q1_to_q4


su q1_to_q4 if US==1&male==0
local q4_US_female : display %5.2f `r(mean)'
su q1_to_q4 if US!=1&male==0
local q4_EU_female : display %5.2f `r(mean)'
su q1_to_q4 if UK==1&male==0
local q4_UK_female : display %5.2f `r(mean)'
su q1_to_q4 if France==1&male==0
local q4_France_female : display %5.2f `r(mean)'
su q1_to_q4 if Italy==1&male==0
local q4_Italy_female : display %5.2f `r(mean)'
su q1_to_q4 if Sweden==1&male==0
local q4_Sweden_female : display %5.2f `r(mean)'

su q1_to_q4 if US==1&male==1
local q4_US_male : display %5.2f `r(mean)'
su q1_to_q4 if US!=1&male==1
local q4_EU_male : display %5.2f `r(mean)'
su q1_to_q4 if UK==1&male==1
local q4_UK_male : display %5.2f `r(mean)'
su q1_to_q4 if France==1&male==1
local q4_France_male : display %5.2f `r(mean)'
su q1_to_q4 if Italy==1&male==1
local q4_Italy_male : display %5.2f `r(mean)'
su q1_to_q4 if Sweden==1&male==1
local q4_Sweden_male : display %5.2f `r(mean)'

ttest q1_to_q4 if US==1, by(male)
local p_US: display %5.4f `r(p)'
ttest q1_to_q4 if UK==1, by(male)
local p_UK: display %5.4f `r(p)'
ttest q1_to_q4 if US==1, by(male)
local p_France: display %5.4f `r(p)'
ttest q1_to_q4 if Italy==1, by(male)
local p_Italy: display %5.4f `r(p)'
ttest q1_to_q4 if Sweden==1, by(male)
local p_Sweden: display %5.4f `r(p)'
ttest q1_to_q4 if US!=1, by(male)
local p_EU: display %5.4f `r(p)'

local diff_q1_to_q4_US = `q4_US_female' - `q4_US_male'
local diff_q1_to_q4_EU = `q4_EU_female' - `q4_EU_male'


cap mata drop D
matrix D = (`q4_US_female',`q4_US_male',.,`q4_UK_female',`q4_UK_male',.,`q4_France_female',`q4_France_male',.,`q4_Italy_female',`q4_Italy_male',.,`q4_Sweden_female',`q4_Sweden_male',.,`diff_q1_to_q4_US',`diff_q1_to_q4_EU')
cap mata drop B
matrix B = (.,`p_US',.,.,`p_UK',.,.,`p_France',.,.,`p_Italy',.,.,`p_Sweden',.,`p_US',`p_EU')
matrix D=D\B
matrix A=A\D


**************q1_to_q3



su q1_to_q3 if US==1&male==0
local q3_US_female : display %5.2f `r(mean)'
su q1_to_q3 if US!=1&male==0
local q3_EU_female : display %5.2f `r(mean)'
su q1_to_q3 if UK==1&male==0
local q3_UK_female : display %5.2f `r(mean)'
su q1_to_q3 if France==1&male==0
local q3_France_female : display %5.2f `r(mean)'
su q1_to_q3 if Italy==1&male==0
local q3_Italy_female : display %5.2f `r(mean)'
su q1_to_q3 if Sweden==1&male==0
local q3_Sweden_female : display %5.2f `r(mean)'

su q1_to_q3 if US==1&male==1
local q3_US_male : display %5.2f `r(mean)'
su q1_to_q3 if US!=1&male==1
local q3_EU_male : display %5.2f `r(mean)'
su q1_to_q3 if UK==1&male==1
local q3_UK_male : display %5.2f `r(mean)'
su q1_to_q3 if France==1&male==1
local q3_France_male : display %5.2f `r(mean)'
su q1_to_q3 if Italy==1&male==1
local q3_Italy_male : display %5.2f `r(mean)'
su q1_to_q3 if Sweden==1&male==1
local q3_Sweden_male : display %5.2f `r(mean)'

ttest q1_to_q3 if US==1, by(male)
local p_US: display %5.4f `r(p)'
ttest q1_to_q3 if UK==1, by(male)
local p_UK: display %5.4f `r(p)'
ttest q1_to_q3 if US==1, by(male)
local p_France: display %5.4f `r(p)'
ttest q1_to_q3 if Italy==1, by(male)
local p_Italy: display %5.4f `r(p)'
ttest q1_to_q3 if Sweden==1, by(male)
local p_Sweden: display %5.4f `r(p)'
ttest q1_to_q3 if US!=1, by(male)
local p_EU: display %5.4f `r(p)'

local diff_q1_to_q3_US = `q3_US_female' - `q3_US_male'
local diff_q1_to_q3_EU = `q3_EU_female' - `q3_EU_male'


cap mata drop D
matrix D = (`q3_US_female',`q3_US_male',.,`q3_UK_female',`q3_UK_male',.,`q3_France_female',`q3_France_male',.,`q3_Italy_female',`q3_Italy_male',.,`q3_Sweden_female',`q3_Sweden_male',.,`diff_q1_to_q3_US',`diff_q1_to_q3_EU')
cap mata drop B
matrix B = (.,`p_US',.,.,`p_UK',.,.,`p_France',.,.,`p_Italy',.,.,`p_Sweden',.,`p_US',`p_EU')
matrix D=D\B
matrix A=A\D




**********q1_to_q2

su q1_to_q2 if US==1&male==0
local q2_US_female : display %5.2f `r(mean)'
su q1_to_q2 if US!=1&male==0
local q2_EU_female : display %5.2f `r(mean)'
su q1_to_q2 if UK==1&male==0
local q2_UK_female : display %5.2f `r(mean)'
su q1_to_q2 if France==1&male==0
local q2_France_female : display %5.2f `r(mean)'
su q1_to_q2 if Italy==1&male==0
local q2_Italy_female : display %5.2f `r(mean)'
su q1_to_q2 if Sweden==1&male==0
local q2_Sweden_female : display %5.2f `r(mean)'

su q1_to_q2 if US==1&male==1
local q2_US_male : display %5.2f `r(mean)'
su q1_to_q2 if US!=1&male==1
local q2_EU_male : display %5.2f `r(mean)'
su q1_to_q2 if UK==1&male==1
local q2_UK_male : display %5.2f `r(mean)'
su q1_to_q2 if France==1&male==1
local q2_France_male : display %5.2f `r(mean)'
su q1_to_q2 if Italy==1&male==1
local q2_Italy_male : display %5.2f `r(mean)'
su q1_to_q2 if Sweden==1&male==1
local q2_Sweden_male : display %5.2f `r(mean)'

ttest q1_to_q2 if US==1, by(male)
local p_US: display %5.4f `r(p)'
ttest q1_to_q2 if UK==1, by(male)
local p_UK: display %5.4f `r(p)'
ttest q1_to_q2 if US==1, by(male)
local p_France: display %5.4f `r(p)'
ttest q1_to_q2 if Italy==1, by(male)
local p_Italy: display %5.4f `r(p)'
ttest q1_to_q2 if Sweden==1, by(male)
local p_Sweden: display %5.4f `r(p)'
ttest q1_to_q2 if US!=1, by(male)
local p_EU: display %5.4f `r(p)'

local diff_q1_to_q2_US = `q2_US_female' - `q2_US_male'
local diff_q1_to_q2_EU = `q2_EU_female' - `q2_EU_male'

cap mata drop D
matrix D = (`q2_US_female',`q2_US_male',.,`q2_UK_female',`q2_UK_male',.,`q2_France_female',`q2_France_male',.,`q2_Italy_female',`q2_Italy_male',.,`q2_Sweden_female',`q2_Sweden_male',.,`diff_q1_to_q2_US',`diff_q1_to_q2_EU')
cap mata drop B
matrix B = (.,`p_US',.,.,`p_UK',.,.,`p_France',.,.,`p_Italy',.,.,`p_Sweden',.,`p_US',`p_EU')
matrix D=D\B
matrix A=A\D


**********q1_to_q1

cap mata drop A
cap mata drop C

su q1_to_q1 if US==1&male==0
local q1_US_female : display %5.2f `r(mean)'
su q1_to_q1 if US!=1&male==0
local q1_EU_female : display %5.2f `r(mean)'
su q1_to_q1 if UK==1&male==0
local q1_UK_female : display %5.2f `r(mean)'
su q1_to_q1 if France==1&male==0
local q1_France_female : display %5.2f `r(mean)'
su q1_to_q1 if Italy==1&male==0
local q1_Italy_female : display %5.2f `r(mean)'
su q1_to_q1 if Sweden==1&male==0
local q1_Sweden_female : display %5.2f `r(mean)'

su q1_to_q1 if US==1&male==1
local q1_US_male : display %5.2f `r(mean)'
su q1_to_q1 if US!=1&male==1
local q1_EU_male : display %5.2f `r(mean)'
su q1_to_q1 if UK==1&male==1
local q1_UK_male : display %5.2f `r(mean)'
su q1_to_q1 if France==1&male==1
local q1_France_male : display %5.2f `r(mean)'
su q1_to_q1 if Italy==1&male==1
local q1_Italy_male : display %5.2f `r(mean)'
su q1_to_q1 if Sweden==1&male==1
local q1_Sweden_male : display %5.2f `r(mean)'

ttest q1_to_q1 if US==1, by(male)
local p_US: display %5.4f `r(p)'
ttest q1_to_q1 if UK==1, by(male)
local p_UK: display %5.4f `r(p)'
ttest q1_to_q1 if US==1, by(male)
local p_France: display %5.4f `r(p)'
ttest q1_to_q1 if Italy==1, by(male)
local p_Italy: display %5.4f `r(p)'
ttest q1_to_q1 if Sweden==1, by(male)
local p_Sweden: display %5.4f `r(p)'
ttest q1_to_q1 if US!=1, by(male)
local p_EU: display %5.4f `r(p)'

local diff_q1_to_q1_US = `q1_US_female' - `q1_US_male'
local diff_q1_to_q1_EU = `q1_EU_female' - `q1_EU_male'

cap mata drop D
matrix D = (`q1_US_female',`q1_US_male',.,`q1_UK_female',`q1_UK_male',.,`q1_France_female',`q1_France_male',.,`q1_Italy_female',`q1_Italy_male',.,`q1_Sweden_female',`q1_Sweden_male',.,`diff_q1_to_q1_US',`diff_q1_to_q1_EU')
cap mata drop B
matrix B = (.,`p_US',.,.,`p_UK',.,.,`p_France',.,.,`p_Italy',.,.,`p_Sweden',.,`p_US',`p_EU')
matrix D=D\B
matrix A=A\D




su q1_to_q5 if US==1&male==0
local obs_US_female : display %5.0f `r(N)'
su q1_to_q5 if US==1&male==1
local obs_US_male : display %5.0f `r(N)'
su q1_to_q5 if UK==1&male==0
local obs_UK_female : display %5.0f `r(N)'
su q1_to_q5 if UK==1&male==1
local obs_UK_male : display %5.0f `r(N)'
su q1_to_q5 if France==1&male==0
local obs_France_female : display %5.0f `r(N)'
su q1_to_q5 if France==1&male==1
local obs_France_male : display %5.0f `r(N)'
su q1_to_q5 if Italy==1&male==0
local obs_Italy_female : display %5.0f `r(N)'
su q1_to_q5 if Italy==1&male==1
local obs_Italy_male : display %5.0f `r(N)'
su q1_to_q5 if Sweden==1&male==0
local obs_Sweden_female : display %5.0f `r(N)'
su q1_to_q5 if Sweden==1&male==1
local obs_Sweden_male : display %5.0f `r(N)'

su q1_to_q5 if US==1
local obs_US : display %5.0f `r(N)'
su q1_to_q5 if US!=1
local obs_EU : display %5.0f `r(N)'

cap mata drop C
matrix C = (.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.)
matrix A=A\C
cap mata drop C
matrix C = (int(`obs_US_female'),int(`obs_US_male'),.,int(`obs_UK_female'), int(`obs_UK_male'),.,int(`obs_France_female'), int(`obs_France_male'),.,int(`obs_Italy_female'), int(`obs_Italy_male'),.,int(`obs_Sweden_female'), int(`obs_Sweden_male'),.,int(`obs_US'),int(`obs_EU'))
matrix A=A\C

		
frmttable using tab2_table_perceived_probs_panel_part1, statmat(A) tex fragment  nocoltitl replace sdec(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2) center ///
		rtitle(Q1 to Q5\"p-value:Difference"\Q1 to Q4\"p-value:Difference"\Q1 to Q3\"p-value:Difference"\Q1 to Q2\"p-value:Difference"\Q1 to Q1\"p-value:Difference"\""\Observations)

log close

