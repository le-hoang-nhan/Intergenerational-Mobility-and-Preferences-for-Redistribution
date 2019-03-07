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
log using "logtable_2_part2", text replace

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
file open holder using tab2_table_mobility_summ_part2.tex, write replace text
file write holder "\begin{center}\begin{tabular}{lcccccccccccccc} " _n
file write holder " & \multicolumn{2}{c}{\textbf{US}} & & \multicolumn{2}{c}{\textbf{UK}} & & \multicolumn{2}{c}{\textbf{France}} & & \multicolumn{2}{c}{\textbf{Italy}} & & \multicolumn{2}{c}{\textbf{Sweden}}} \\" _n
file write holder " \cline{2-3} \cline{5-6} \cline{8-9} \cline{11-12} \cline{14-15}  " _n
file write holder " & Female & Male & & Female & Male & & Female & Male & & Female & Male & & Female & Male\\ " _n
file write holder "& (1) & (2) & & (3) & (4) & & (5) & (6) & & (7) & (8) & & (9) & (10)\\" _n
file close holder

gen female = 0
replace female = 1 if male == 0

forvalues q=1(1)5 {
label var q1_to_q`q' "Q1 to Q`q'"
}

* Panel A

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


foreach x in male female{
	foreach y in US UK France Italy Sweden {
		local d_q5_`y'_`x' = `q5_`y'_`x'' - `q5_`y'_true'
		ttest q1_to_q5 = `q5_`y'_true' if `x'==1&`y'==1
		local t_q5_`y'_`x' : dis %5.4f `r(p)'
	}
}		


cap mata drop A
matrix A = (`d_q5_US_female',`d_q5_US_male',.,`d_q5_UK_female',`d_q5_UK_male',.,`d_q5_France_female',`d_q5_France_male',.,`d_q5_Italy_female',`d_q5_Italy_male',.,`d_q5_Sweden_female',`d_q5_Sweden_male')
cap mata drop B
matrix B = (`t_q5_US_female',`t_q5_US_male',.,`t_q5_UK_female',`t_q5_UK_female',.,`t_q5_France_female', `t_q5_France_male',., `t_q5_Italy_female', `t_q5_Italy_male',., `t_q5_Sweden_female', `t_q5_Sweden_male')
matrix A=A\B 


********q1_to_q4


su q1_to_q4 if US==1&male==0
local q4_US_female : display %5.2f `r(mean)'
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
su q1_to_q4 if UK==1&male==1
local q4_UK_male : display %5.2f `r(mean)'
su q1_to_q4 if France==1&male==1
local q4_France_male : display %5.2f `r(mean)'
su q1_to_q4 if Italy==1&male==1
local q4_Italy_male : display %5.2f `r(mean)'
su q1_to_q4 if Sweden==1&male==1
local q4_Sweden_male : display %5.2f `r(mean)'


su true_q1_to_q4 if US==1
local q4_US_true : display %5.2f `r(mean)'
su true_q1_to_q4 if UK==1
local q4_UK_true : display %5.2f `r(mean)'
su true_q1_to_q4 if France==1
local q4_France_true : display %5.2f `r(mean)'
su true_q1_to_q4 if Italy==1
local q4_Italy_true : display %5.2f `r(mean)'
su true_q1_to_q4 if Sweden==1
local q4_Sweden_true : display %5.2f `r(mean)'



foreach x in male female{
	foreach y in US UK France Italy Sweden {
		local d_q4_`y'_`x' = `q4_`y'_`x'' - `q4_`y'_true'
		ttest q1_to_q4 = `q4_`y'_true' if `x'==1&`y'==1
		local t_q4_`y'_`x' : dis %5.4f `r(p)'
	}
}		



cap mata drop D
matrix D = (`d_q4_US_female',`d_q4_US_male',.,`d_q4_UK_female',`d_q4_UK_male',.,`d_q4_France_female',`d_q4_France_male',.,`d_q4_Italy_female',`d_q4_Italy_male',.,`d_q4_Sweden_female',`d_q4_Sweden_male')
cap mata drop B
matrix B = (`t_q4_US_female',`t_q4_US_male',.,`t_q4_UK_female',`t_q4_UK_female',.,`t_q4_France_female', `t_q4_France_male',., `t_q4_Italy_female', `t_q4_Italy_male',., `t_q4_Sweden_female', `t_q4_Sweden_male')
matrix D=D\B



matrix A=A\D


**************q1_to_q3


su q1_to_q3 if US==1&male==0
local q3_US_female : display %5.2f `r(mean)'
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
su q1_to_q3 if UK==1&male==1
local q3_UK_male : display %5.2f `r(mean)'
su q1_to_q3 if France==1&male==1
local q3_France_male : display %5.2f `r(mean)'
su q1_to_q3 if Italy==1&male==1
local q3_Italy_male : display %5.2f `r(mean)'
su q1_to_q3 if Sweden==1&male==1
local q3_Sweden_male : display %5.2f `r(mean)'


su true_q1_to_q3 if US==1
local q3_US_true : display %5.2f `r(mean)'
su true_q1_to_q3 if UK==1
local q3_UK_true : display %5.2f `r(mean)'
su true_q1_to_q3 if France==1
local q3_France_true : display %5.2f `r(mean)'
su true_q1_to_q3 if Italy==1
local q3_Italy_true : display %5.2f `r(mean)'
su true_q1_to_q3 if Sweden==1
local q3_Sweden_true : display %5.2f `r(mean)'



foreach x in male female{
	foreach y in US UK France Italy Sweden {
		local d_q3_`y'_`x' = `q3_`y'_`x'' - `q3_`y'_true'
		ttest q1_to_q3 = `q3_`y'_true' if `x'==1&`y'==1
		local t_q3_`y'_`x' : dis %5.4f `r(p)'
	}
}		



cap mata drop D
matrix D = (`d_q3_US_female',`d_q3_US_male',.,`d_q3_UK_female',`d_q3_UK_male',.,`d_q3_France_female',`d_q3_France_male',.,`d_q3_Italy_female',`d_q3_Italy_male',.,`d_q3_Sweden_female',`d_q3_Sweden_male')
cap mata drop B
matrix B = (`t_q3_US_female',`t_q3_US_male',.,`t_q3_UK_female',`t_q3_UK_female',.,`t_q3_France_female', `t_q3_France_male',., `t_q3_Italy_female', `t_q3_Italy_male',., `t_q3_Sweden_female', `t_q3_Sweden_male')
matrix D=D\B

matrix A=A\D


**********q1_to_q2


su q1_to_q2 if US==1&male==0
local q2_US_female : display %5.2f `r(mean)'
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
su q1_to_q2 if UK==1&male==1
local q2_UK_male : display %5.2f `r(mean)'
su q1_to_q2 if France==1&male==1
local q2_France_male : display %5.2f `r(mean)'
su q1_to_q2 if Italy==1&male==1
local q2_Italy_male : display %5.2f `r(mean)'
su q1_to_q2 if Sweden==1&male==1
local q2_Sweden_male : display %5.2f `r(mean)'


su true_q1_to_q2 if US==1
local q2_US_true : display %5.2f `r(mean)'
su true_q1_to_q2 if UK==1
local q2_UK_true : display %5.2f `r(mean)'
su true_q1_to_q2 if France==1
local q2_France_true : display %5.2f `r(mean)'
su true_q1_to_q2 if Italy==1
local q2_Italy_true : display %5.2f `r(mean)'
su true_q1_to_q2 if Sweden==1
local q2_Sweden_true : display %5.2f `r(mean)'



foreach x in male female{
	foreach y in US UK France Italy Sweden {
		local d_q2_`y'_`x' = `q2_`y'_`x'' - `q2_`y'_true' 
		ttest q1_to_q2 = `q2_`y'_true' if `x'==1&`y'==1
		local t_q2_`y'_`x' : dis %5.4f `r(p)'
	}
}		



cap mata drop D
matrix D = (`d_q2_US_female',`d_q2_US_male',.,`d_q2_UK_female',`d_q2_UK_male',.,`d_q2_France_female',`d_q2_France_male',.,`d_q2_Italy_female',`d_q2_Italy_male',.,`d_q2_Sweden_female',`d_q2_Sweden_male')
cap mata drop B
matrix B = (`t_q2_US_female',`t_q2_US_male',.,`t_q2_UK_female',`t_q2_UK_female',.,`t_q2_France_female', `t_q2_France_male',., `t_q2_Italy_female', `t_q2_Italy_male',., `t_q2_Sweden_female', `t_q2_Sweden_male')
matrix D=D\B



matrix A=A\D



**********q1_to_q1


su q1_to_q1 if US==1&male==0
local q1_US_female : display %5.2f `r(mean)'
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
su q1_to_q1 if UK==1&male==1
local q1_UK_male : display %5.2f `r(mean)'
su q1_to_q1 if France==1&male==1
local q1_France_male : display %5.2f `r(mean)'
su q1_to_q1 if Italy==1&male==1
local q1_Italy_male : display %5.2f `r(mean)'
su q1_to_q1 if Sweden==1&male==1
local q1_Sweden_male : display %5.2f `r(mean)'



su true_q1_to_q1 if US==1
local q1_US_true : display %5.2f `r(mean)'
su true_q1_to_q1 if UK==1
local q1_UK_true : display %5.2f `r(mean)'
su true_q1_to_q1 if France==1
local q1_France_true : display %5.2f `r(mean)'
su true_q1_to_q1 if Italy==1
local q1_Italy_true : display %5.2f `r(mean)'
su true_q1_to_q1 if Sweden==1
local q1_Sweden_true : display %5.2f `r(mean)'



foreach x in male female{
	foreach y in US UK France Italy Sweden {
		local d_q1_`y'_`x' = `q1_`y'_`x'' - `q1_`y'_true' 
		ttest q1_to_q1 = `q1_`y'_true' if `x'==1&`y'==1
		local t_q1_`y'_`x' : dis %5.4f `r(p)'
	}
}		



cap mata drop D
matrix D = (`d_q1_US_female',`d_q1_US_male',.,`d_q1_UK_female',`d_q1_UK_male',.,`d_q1_France_female',`d_q1_France_male',.,`d_q1_Italy_female',`d_q1_Italy_male',.,`d_q1_Sweden_female',`d_q1_Sweden_male')
cap mata drop B
matrix B = (`t_q1_US_female',`t_q1_US_male',.,`t_q1_UK_female',`t_q1_UK_female',.,`t_q1_France_female', `t_q1_France_male',., `t_q1_Italy_female', `t_q1_Italy_male',.,`t_q1_Sweden_female', `t_q1_Sweden_male')
matrix D=D\B



matrix A=A\D


*****Observations*****


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



cap mata drop C
matrix C = (.,.,.,.,.,.,.,.,.,.,.,.,.,.)
matrix A=A\C
cap mata drop C
matrix C = (int(`obs_US_female'),int(`obs_US_male'),.,int(`obs_UK_female'), int(`obs_UK_male'),.,int(`obs_France_female'), int(`obs_France_male'),., int(`obs_Italy_female'), int(`obs_Italy_male'),., int(`obs_Sweden_female'), int(`obs_Sweden_male'))
matrix A=A\C

		
frmttable using tab2_table_perceiveD_probs_panel_part2, statmat(A) tex fragment  nocoltitl replace sdec(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2\0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2) center ///
		rtitle(Q1 to Q5\"p-value:Difference"\Q1 to Q4\"p-value:Difference"\Q1 to Q3\"p-value:Difference"\Q1 to Q2\"p-value:Difference"\Q1 to Q1\"p-value:Difference"\""\Observations)

		
log close

