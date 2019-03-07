
/*

INTERGENERATIONAL MOBILITY AND PREFERENCES FOR REDISTRIBUTION
ALESINA, STANTCHEVA, TESO 
AER

THIS DO FILE GENERATES ALL FIGURES IN THE MAIN PART OF THE PAPER

*/

set more off

* set path here

*******************************************************************
*******************************************************************
*** FIGURE 2: COMPARISON OF TRUE AND PERCEIVED AVERAGE BELIEFS  ***
*******************************************************************
*******************************************************************

set more off

* Use dataset
use "Data_Descriptive_Waves_ABC.dta", clear

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Only control group
keep if Treated==0

* Mean perceived beliefs
forvalues q=1(1)5 {
gen perceived_`q'=.
foreach x in US UK France Italy Sweden {
su q1_to_q`q' if `x'==1 
replace perceived_`q' = r(mean) if `x'==1 
}
}
* Keep mean beliefs and true probabilities
keep true_q1_to_q1 true_q1_to_q2 true_q1_to_q3 true_q1_to_q4 true_q1_to_q5 ///
perceived_1 perceived_2 perceived_3 perceived_4 perceived_5 country
duplicates drop country, force

* Country labels
replace country="SE" if country=="Sweden"
replace country="IT" if country=="Italy"
replace country="FR" if country=="France"

* Q1 TO Q5
twoway (scatter perceived_5 true_q1_to_q5 if country=="US", mcolor(red) msize(medlarge) mlabs(small) mlabel(country) mlabc(red)) ///
	   (scatter perceived_5 true_q1_to_q5 if country=="UK", mcolor(blue) msize(medlarge) mlabs(small) mlabel(country) mlabc(blue)) ///
	   (scatter perceived_5 true_q1_to_q5 if country=="FR", mcolor(dkgreen) mlabposition(4) msize(medlarge) mlabs(small) mlabel(country) mlabc(dkgreen)) ///
	   (scatter perceived_5 true_q1_to_q5 if country=="IT", mcolor(orange) msize(medlarge) mlabs(small) mlabel(country) mlabc(orange)) ///
	   (scatter perceived_5 true_q1_to_q5 if country=="SE", mcolor(purple) mlabposition(2) msize(medlarge) mlabs(small) mlabel(country) mlabc(purple)) ///
	   (function y=x, range(6 12) lpattern(-) lcolor(gs9)) , ///
        ytitle("Average Perceived Probability") ylabel(6(1)12, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
		xtitle("Actual Probability") xlabel(6(1)12, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
        graphregion(color(white)) plotregion(color(white)) ///
		text(7 10 "Pessimistic", place(c) color(gs9) size(large)) ///
		text(10 7 "Optimistic", place(c) color(gs9) size(large)) ///
		legend(off)
		graph export "figure_scatter_mean_perceptions_Q5.pdf", as(pdf) replace
		
* Q1 TO Q1
twoway (scatter perceived_1 true_q1_to_q1 if country=="US", mcolor(red) msize(medlarge) mlabs(small) mlabel(country) mlabc(red)) ///
	   (scatter perceived_1 true_q1_to_q1 if country=="UK", mcolor(blue) msize(medlarge) mlabs(small) mlabel(country) mlabc(blue)) ///
	   (scatter perceived_1 true_q1_to_q1 if country=="FR", mcolor(dkgreen) msize(medlarge) mlabs(small) mlabel(country) mlabc(dkgreen)) ///
	   (scatter perceived_1 true_q1_to_q1 if country=="IT", mcolor(orange) msize(medlarge) mlabs(small) mlabel(country) mlabc(orange)) ///
	   (scatter perceived_1 true_q1_to_q1 if country=="SE", mcolor(purple) msize(medlarge) mlabs(small) mlabel(country) mlabc(purple)) ///
	   (function y=x, range(24 38) lpattern(-) lcolor(gs9)) , ///
        ytitle("Average Perceived Probability") ylabel(24(2)38, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
		xtitle("Actual Probability") xlabel(24(2)38, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
        graphregion(color(white)) plotregion(color(white)) ///
		text(27 36 "Optimistic", place(c) color(gs9) size(large)) ///
		text(36 26 "Pessimistic", place(c) color(gs9) size(large)) ///
		legend(off)
		graph export "figure_scatter_mean_perceptions_Q1.pdf", as(pdf) replace
		

* Q1 TO Q2/Q3/Q4		
reshape long perceived_ true_q1_to_q, j(q) i(country)		

gen country2=country+" Q"+string(q)
keep if q==2 | q==3 | q==4
		
twoway (scatter perceived_ true_q1_to_q if q==2 & country!="FR", msymbol(circle) mcolor(red) msize(medlarge) mlabs(small) mlabel(country) mlabc(red)) ///
	   (scatter perceived_ true_q1_to_q if q==2 & country=="FR", msymbol(circle) mcolor(red) msize(medlarge) mlabposition(2) mlabs(small) mlabel(country) mlabc(red)) ///
	   (scatter perceived_ true_q1_to_q if q==3, msymbol(triangle) mcolor(blue) msize(medlarge) mlabs(small) mlabel(country) mlabc(blue)) ///
	   (scatter perceived_ true_q1_to_q if q==4 & country!="FR", msymbol(square) mcolor(dkgreen) mlabposition(3) msize(medlarge) mlabs(small) mlabel(country) mlabc(dkgreen)) ///
	   (scatter perceived_ true_q1_to_q if q==4 & country=="FR", msymbol(square) mcolor(dkgreen) mlabposition(9) msize(medlarge) mlabs(small) mlabel(country) mlabc(dkgreen)) ///
	   (function y=x, range(10 30) lpattern(-) lcolor(gs9)) , ///
        ytitle("Average Perceived Probability") ylabel(10(2)30, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
		xtitle("Actual Probability") xlabel(10(2)30, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
        graphregion(color(white)) plotregion(color(white)) ///
		legend(order(1 3 5) cols(3) label(1 "Q1 to Q2") label(3 "Q1 to Q3") label(5 "Q1 to Q4"))
		graph export "figure_scatter_mean_perceptions_Q2_Q3_Q4.pdf", as(pdf) replace
				


**********************************************************************
**********************************************************************
***	 			FIGURE 3: CDF OF MISPERCEPTIONS				       ***
**********************************************************************
**********************************************************************

set more off

* Use dataset
use "Data_Descriptive_Waves_ABC.dta", clear

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Only control group
keep if Treated==0 

* Take out additional outliers
drop if q1_to_q1==100
drop if q1_to_q5>=80

* Misperceptions relative to the truth
forvalues q=1(1)5 {
gen misperception_q`q'=-abs(q1_to_q`q'-true_q1_to_q`q')
}
su q1_to_q1 if country=="US"
local mean_q1_US : display %5.2f `r(mean)'
su true_q1_to_q1 if country=="US"
local true_mean_q1_US : display %5.2f `r(mean)'
gen mean_error_q1_US=-abs(`mean_q1_US'-`true_mean_q1_US')

su q1_to_q5 if country=="US"
local mean_q5_US : display %5.2f `r(mean)'
su true_q1_to_q5 if country=="US"
local true_mean_q5_US : display %5.2f `r(mean)'
gen mean_error_q5_US=-abs(`mean_q5_US'-`true_mean_q5_US')

gen diff_q1=q1_to_q1-true_q1_to_q1
su diff_q1 if country!="US"
local mean_q1_EU : display %5.2f `r(mean)'
gen mean_error_q1_EU=-abs(`mean_q1_EU')

gen diff_q5=q1_to_q5-true_q1_to_q5
su diff_q5 if country!="US"
local mean_q5_EU : display %5.2f `r(mean)'
gen mean_error_q5_EU=-abs(`mean_q5_EU')

* Keep beliefs
keep misperception_q1 misperception_q2 misperception_q3 misperception_q4 misperception_q5 country mean_error_*

* calculations for the figure description in the paper
count if misperception_q1<mean_error_q1_US & country=="US"
count if misperception_q5<mean_error_q5_US & country=="US"
count if misperception_q1<mean_error_q1_EU & country!="US"
count if misperception_q5<mean_error_q5_EU & country!="US"
count if country=="US"
count if country!="US"
su misperception_q5 if country=="US"
su mean_error_q5_US if country=="US"
su misperception_q1 if country!="US"
su mean_error_q1_EU if country!="US"

* Prepare data for the plot
forvalues q=1(1)5 {
preserve
keep country misperception_q`q' mean_error_*
rename misperception_q`q' misperception_q
gen quintile=`q'
save "temp`q'.dta", replace
restore
}
clear
use "temp1.dta"
forvalues q=2(1)5 {
append using "temp`q'.dta"
}
forvalues q=1(1)5 {
erase "temp`q'.dta"
}

preserve
keep if quintile==1 | quintile==5
su mean_error_q1_US
local q1_US : display %5.2f `r(mean)'
su mean_error_q5_US
local q5_US : display %5.2f `r(mean)'
distplot line misperception_q if country=="US", by(quintile) ///
ytitle("CDF") ///
xtitle("Negative Absolute Error") ///
graphregion(color(white)) plotregion(color(white)) /// 
xline(`q1_US', lcolor(blue) lpattern("-")) ///
xline(`q5_US', lcolor(red) lpattern("-")) ///
legend(order(1 2) cols(2) label(1 "Q1 to Q1") label(2 "Q1 to Q5"))
graph export "cdf_abs_difference_US.pdf", as(pdf) replace
restore

preserve
keep if quintile==1 | quintile==5
su mean_error_q1_EU
local q1_EU : display %5.2f `r(mean)'
su mean_error_q5_EU
local q5_EU : display %5.2f `r(mean)'
su misperception_q if quintile==1 & country!="US"
local mean_q1 : display %5.2f `r(mean)'
su misperception_q if quintile==5 & country!="US"
local mean_q5 : display %5.2f `r(mean)'
distplot line misperception_q if country!="US", by(quintile) ///
ytitle("CDF") ///
xtitle("Negative Absolute Error") ///
graphregion(color(white)) plotregion(color(white)) ///
xline(`q1_EU', lcolor(blue) lpattern("-")) ///
xline(`q5_EU', lcolor(red) lpattern("-")) /// 
legend(order(1 2) cols(2) label(1 "Q1 to Q1") label(2 "Q1 to Q5"))
graph export "cdf_abs_difference_EU.pdf", as(pdf) replace
restore

*******************************************************************
*******************************************************************
*** FIGURE 4: ROLE OF EFFORT - BASELINE VS CONDITIONAL BELIEFS  ***
*******************************************************************
*******************************************************************


set more off

* Open dataset
use "Data_Descriptive_Waves_ABC.dta", clear	

* Keep only those with flag 1 and 2 equal to zero
keep if flag_1==0 & flag_2==0

* Only control group
keep if Treated==0

forvalues q=1(1)5 {
gen diff_q`q'=q1_to_q`q'_effort-q1_to_q`q'
}

forvalues q=1(1)5 {
foreach x in US UK France Italy Sweden {
ci means diff_q`q' if `x'==1
local b`q'`x' = r(mean)
local ub_b`q'`x' = r(ub)
local lb_b`q'`x' = r(lb)
}
}

        clear
        set obs 29
        egen t = seq()
        gen b = .
        gen ub_b = .
        gen lb_b = .
		
  			
				replace b = `b1US' if t==1
                replace ub_b = `ub_b1US' if t==1
                replace lb_b = `lb_b1US' if t==1
				replace b = `b1UK' if t==2
                replace ub_b = `ub_b1UK' if t==2
                replace lb_b = `lb_b1UK' if t==2
				replace b = `b1France' if t==3
                replace ub_b = `ub_b1France' if t==3
                replace lb_b = `lb_b1France' if t==3			
				replace b = `b1Italy' if t==4
                replace ub_b = `ub_b1Italy' if t==4
                replace lb_b = `lb_b1Italy' if t==4				
				replace b = `b1Sweden' if t==5
                replace ub_b = `ub_b1Sweden' if t==5
                replace lb_b = `lb_b1Sweden' if t==5
				
				replace b = `b2US' if t==7
                replace ub_b = `ub_b2US' if t==7
                replace lb_b = `lb_b2US' if t==7
				replace b = `b2UK' if t==8
                replace ub_b = `ub_b2UK' if t==8
                replace lb_b = `lb_b2UK' if t==8
				replace b = `b2France' if t==9
                replace ub_b = `ub_b2France' if t==9
                replace lb_b = `lb_b2France' if t==9			
				replace b = `b2Italy' if t==10
                replace ub_b = `ub_b2Italy' if t==10
                replace lb_b = `lb_b2Italy' if t==10			
				replace b = `b2Sweden' if t==11
                replace ub_b = `ub_b2Sweden' if t==11
                replace lb_b = `lb_b2Sweden' if t==11

				replace b = `b3US' if t==13
                replace ub_b = `ub_b3US' if t==13
                replace lb_b = `lb_b3US' if t==13
				replace b = `b3UK' if t==14
                replace ub_b = `ub_b3UK' if t==14
                replace lb_b = `lb_b3UK' if t==14
				replace b = `b3France' if t==15
                replace ub_b = `ub_b3France' if t==15
                replace lb_b = `lb_b3France' if t==15			
				replace b = `b3Italy' if t==16
                replace ub_b = `ub_b3Italy' if t==16
                replace lb_b = `lb_b3Italy' if t==16			
				replace b = `b3Sweden' if t==17
                replace ub_b = `ub_b3Sweden' if t==17
                replace lb_b = `lb_b3Sweden' if t==17

				replace b = `b4US' if t==19
                replace ub_b = `ub_b4US' if t==19
                replace lb_b = `lb_b4US' if t==19
				replace b = `b4UK' if t==20
                replace ub_b = `ub_b4UK' if t==20
                replace lb_b = `lb_b4UK' if t==20
				replace b = `b4France' if t==21
                replace ub_b = `ub_b4France' if t==21
                replace lb_b = `lb_b4France' if t==21			
				replace b = `b4Italy' if t==22
                replace ub_b = `ub_b4Italy' if t==22
                replace lb_b = `lb_b4Italy' if t==22			
				replace b = `b4Sweden' if t==23
                replace ub_b = `ub_b4Sweden' if t==23
                replace lb_b = `lb_b4Sweden' if t==23				
				
				replace b = `b5US' if t==25
                replace ub_b = `ub_b5US' if t==25
                replace lb_b = `lb_b5US' if t==25
				replace b = `b5UK' if t==26
                replace ub_b = `ub_b5UK' if t==26
                replace lb_b = `lb_b5UK' if t==26
				replace b = `b5France' if t==27
                replace ub_b = `ub_b5France' if t==27
                replace lb_b = `lb_b5France' if t==27			
				replace b = `b5Italy' if t==28
                replace ub_b = `ub_b5Italy' if t==28
                replace lb_b = `lb_b5Italy' if t==28			
				replace b = `b5Sweden' if t==29
                replace ub_b = `ub_b5Sweden' if t==29
                replace lb_b = `lb_b5Sweden' if t==29	
				
			label define b 1 "" 2 "" 3 "Q1 to Q1" 4 "" 5 "" 6 "" 7 "" 8 "" 9 "Q1 to Q2" 10 "" 11 "" 12 "" 13 "" 14 "" 15 "Q1 to Q3" 16 "" 17 "" 18 "" 19 "" 20 "" 21 "Q1 to Q4" 22 "" 23 "" 24 "" 25 "" 26 "" 27 "Q1 to Q5" 28 "" 29 ""
			label values t b

		 twoway (bar b t if (t==1 | t==7 | t==13 | t==19 | t==25),  color(blue)) ///	
				(bar b t if (t==2 | t==8 | t==14 | t==20 | t==26),  color(red)) ///
				(bar b t if (t==3 | t==9 | t==15 | t==21 | t==27),  color(dkgreen)) ///
				(bar b t if (t==4 | t==10 | t==16 | t==22 | t==28),  color(orange)) ///
				(bar b t if (t==5 | t==11 | t==17 | t==23 | t==29),  color(purple)) ///
				(rcap lb_b ub_b t, lcolor(black) lpattern(solid)  msymbol(D) lwidth(medthick)),  ///
				legend(order(1 2 3 4 5) col(5) lab(1 "US") lab(2 "UK") lab(3 "France") lab(4 "Italy") lab(5 "Sweden")) ///
				graphregion(color(white)) plotregion(color(white)) ysca(titlegap(2)) ///
				xlabel(3(6)27,labsize(2.3) val) xtitle("") ytitle("Conditional Minus Unconditional Probability")			
				graph export "effect_effort_histogram.pdf", as(pdf) replace



*******************************************************************
*******************************************************************
*** 		FIGURE 5: HETEROGENEITY OF PERCEPTIONS 		        ***
*******************************************************************
*******************************************************************

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
rename black var_10
rename young  var_11
rename children_dummy  var_12
rename male var_13


*** GRAPH Q1 to Q1 ***

forvalues q=2(1)13 {
ci means q1_to_q1 if var_`q'==1, level(90)
local bY_`q' = r(mean)
local ub_bY_`q' = r(ub)
local lb_bY_`q' = r(lb)
}
forvalues q=2(1)13 {
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
			graph export "Figure_heterogeneity_Q1.pdf", as(pdf) replace			
restore		
		
		

*** GRAPH Q1 to Q5 ***

forvalues q=2(1)13 {
ci means q1_to_q5 if var_`q'==1, level(90)
local bY_`q' = r(mean)
local ub_bY_`q' = r(ub)
local lb_bY_`q' = r(lb)
}
forvalues q=2(1)13 {
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
			graph export "Figure_heterogeneity_Q5.pdf", as(pdf) replace			
restore		
		

********************************************************************************************
********************************************************************************************
*** FIGURE 6: REAL AND PERCEIVED TRANSITION PROBABILITIES IN THE US STATES	     ***					 
********************************************************************************************
********************************************************************************************

set more off

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

* Real probabilities
maptile prob_p1_k5_state, geo(state) cutv(6.44 8.06 9.14 10.52 12.63 14.74 ) fcolor(eggshell yellow*0.3 yellow*0.5 orange*0.6 orange*0.8 red*0.6 red*0.8 cranberry) twopt(legend(off) title(Average Actual Probability, size(huge)))
graph export "MAP_revised_real.pdf", as(pdf) replace	

* Perceived probabilities
maptile prob_p1_k5_belief_state if numb_responses_state>=10 , geo(state) cutv(6.44 8.06 9.14 10.52 12.63 14.74 ) fcolor(eggshell yellow*0.3 yellow*0.5 orange*0.6 orange*0.8 red*0.6 red*0.8 cranberry) twopt(title(Average Perceived Probability, size(vlarge))legend(label(2 "<6.44") label(3 "6.44 - 8.06") label(4 "8.06 - 9.14") label(5 "9.14 - 10.52") label(6 "10.52 - 12.63") label(7 "12.63 - 14.74") label(8 "> 14.74") size(4.5) ring(1) position(4)))
graph export "MAP_revised_perceived.pdf", as(pdf) replace	

* Negative correlations described in the paper
reg prob_p1_k5_belief_state prob_p1_k5_state if numb_responses_state>=10
reg prob_p1_k5_belief_state prob_p1_k5_state if numb_responses_state>=10 & state!="NC" & state!="SC" & state!="VA" & ///
state!="WV" & state!="TN" & state!="GA" & state!="KY" & state!="AL" & state!="MS" & state!="FL"

* Ratio of perceived over state real
gen ratio=prob_p1_k5_belief/prob_p1_k5_state
replace ratio=. if numb_responses_state<10
maptile ratio, geo(state) fcolor(eggshell sandb*0.8 gold orange red*0.7) n(5) twopt(title(Ratio of Perceived to Actual State-Level Probability, size(huge)) legend(label(2 "<0.98") label(3 "0.98 - 1.28") label(4 "1.28 - 1.57") label(5 "1.57 - 2.18") label(6 ">2.18")))
graph export "MAP_ratio.pdf", as(pdf) replace	
drop ratio
* Ratio of perceived over national real
gen ratio=prob_p1_k5_belief/7.8
replace ratio=. if numb_responses_state<10
maptile ratio, geo(state) fcolor(eggshell sandb*0.8 gold orange red*0.7) n(5) twopt(title(Ratio of Perceived to Actual National Probability, size(huge)) legend(label(2 "<1.21") label(3 "1.21 - 1.39") label(4 "1.39 - 1.58") label(5 "1.58 - 1.73") label(6 ">1.73")))
graph export "MAP_ratio_national.pdf", as(pdf) replace

	
	
**********************************************************************
**********************************************************************
***		 FIGURE 7: PERCEPTIONS OF GOVERNMENT AND FAIRNESS		   ***
**********************************************************************
**********************************************************************

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

*** Means of variables ***
foreach x in US UK Italy France Sweden {	
foreach y in econ_system_fair american_dream_alive effort_reason_poor /// 
effort_reason_rich trust_government_some tools_government_some govt_intervention_d ///
lowering_taxes_better against_government_1 unequal_opp_problem_ser {
su `y' if `x'==1
local m`y'`x' = r(mean)
}
}


preserve
        clear
        set obs 51
        egen t = seq()
		label define var 10 "Economic System Fair" 9 "American Dream Alive" 8 "Effort Reason Poor" 7 "Effort Reason Rich" ///
		6 "Never Trust Government" 5 "Government Has No Tools" 4 "Prefer Low Govt. Intervention" 3 "Lowering Taxes Better" ///
		2 "Unequal Opp. No Problem" 1 "Negative View of Government" 
		label values t var
		replace t=t/5
		
		
        gen m_US = .
		gen m_UK = .
        gen m_France = .
        gen m_Italy = .
        gen m_Sweden = .
		
		gen n=_n
		foreach x in US UK Italy France Sweden {	
		replace m_`x'=`mecon_system_fair`x'' if n==50
		replace m_`x'=`mamerican_dream_alive`x'' if n==45
		replace m_`x'=`meffort_reason_poor`x'' if n==40
		replace m_`x'=`meffort_reason_rich`x'' if n==35
		replace m_`x'=1-`mtrust_government_some`x'' if n==30
		replace m_`x'=1-`mtools_government_some`x'' if n==25
		replace m_`x'=1-`mgovt_intervention_d`x'' if n==20
		replace m_`x'=`mlowering_taxes_better`x'' if n==15
		replace m_`x'=1-`munequal_opp_problem_ser`x'' if n==10
		replace m_`x'=`magainst_government_1`x'' if n==5
		}


	
		twoway 	(scatter t m_US, mcolor(red) msize(large) lcolor(midblue) lpattern(solid) msymbol(D)) ///
				(scatter t m_UK, mcolor(blue) msize(large) lcolor(red) lpattern(solid) msymbol(O)) ///
				(scatter t m_France, mcolor(dkgreen) msize(large) lcolor(red) lpattern(solid) msymbol(S)) ///
				(scatter t m_Italy, mcolor(orange) msize(large) lcolor(red) lpattern(solid) msymbol(T)) ///
				(scatter t m_Sweden, mcolor(purple) msize(vlarge) lcolor(midblue) lpattern(solid) msymbol(X)), ///
                ytitle("") ylabel(1 2 3 4 5 6 7 8 9 10, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
                legend(order(1 2 3 4 5) cols(5) label(1 "US") label(2 "UK") label(3 "France") label(4 "Italy") label(5 "Sweden")) ///
				xtitle("Share Answering Yes") ///
				yline(1, lcolor(gs14) lpattern("-")) yline(2, lcolor(gs14) lpattern("-")) ///
				yline(3, lcolor(gs14) lpattern("-")) yline(4, lcolor(gs14) lpattern("-")) ///
				yline(5, lcolor(gs14) lpattern("-")) yline(6, lcolor(gs14) lpattern("-")) ///	
				yline(7, lcolor(gs14) lpattern("-")) yline(8, lcolor(gs14) lpattern("-")) ///
				yline(9, lcolor(gs14) lpattern("-")) yline(10, lcolor(gs14) lpattern("-")) ///
                graphregion(color(white)) plotregion(color(white))
				graph export "Figure_Government_Country.pdf", as(pdf) replace
				
restore		
		

********** BY LEFT-RIGHT **********

*** Means of variables ***
foreach x in left right {	
foreach y in econ_system_fair american_dream_alive effort_reason_poor /// 
effort_reason_rich trust_government_some tools_government_some govt_intervention_d ///
lowering_taxes_better against_government_1 unequal_opp_problem_ser {
su `y' if `x'==1
local m`y'`x' = r(mean)
}
}


preserve
        clear
        set obs 51
        egen t = seq()

		label values t var
		replace t=t/5
		
		
        gen m_left = .
		gen m_right = .
		label define var 1 "" 2 "" 3 "" 4 "" 5 "" 6 "" 7 "" 8 "" 9 "" 10 "" 
		gen n=_n
		foreach x in left right {	
		replace m_`x'=`mecon_system_fair`x'' if n==50
		replace m_`x'=`mamerican_dream_alive`x'' if n==45
		replace m_`x'=`meffort_reason_poor`x'' if n==40
		replace m_`x'=`meffort_reason_rich`x'' if n==35
		replace m_`x'=1-`mtrust_government_some`x'' if n==30
		replace m_`x'=1-`mtools_government_some`x'' if n==25
		replace m_`x'=1-`mgovt_intervention_d`x'' if n==20
		replace m_`x'=`mlowering_taxes_better`x'' if n==15
		replace m_`x'=1-`munequal_opp_problem_ser`x'' if n==10
		replace m_`x'=`magainst_government_1`x'' if n==5
		}


	
		twoway 	(scatter t m_left, mcolor(blue) msize(large) lcolor(midblue) lpattern(solid) msymbol(S)) ///
				(scatter t m_right, mcolor(red) msize(large) lcolor(red) lpattern(solid) msymbol(D)) , ///
                ytitle("") ylabel(1 2 3 4, value labsize(small) angle(0) glcolor(gs16) noticks)  ///
                legend(order(1 2) cols(2) label(1 "Left-Wing") label(2 "Right-Wing") ) ///
                ytitle("") ylabel(1 2 3 4 5 6 7 8 9 10, value labsize(zero) angle(0) glcolor(gs16) noticks)  ///
				xtitle("Share Answering Yes") xlabel(0(0.2)1) ///
				yline(1, lcolor(gs14) lpattern("-")) yline(2, lcolor(gs14) lpattern("-")) ///
				yline(3, lcolor(gs14) lpattern("-")) yline(4, lcolor(gs14) lpattern("-")) ///
				yline(5, lcolor(gs14) lpattern("-")) yline(6, lcolor(gs14) lpattern("-")) ///	
				yline(7, lcolor(gs14) lpattern("-")) yline(8, lcolor(gs14) lpattern("-")) ///
				yline(9, lcolor(gs14) lpattern("-")) yline(10, lcolor(gs14) lpattern("-")) ///
                graphregion(color(white)) plotregion(color(white))
				graph export "Figure_Government_LeftRight.pdf", as(pdf) replace
				
restore				
		
