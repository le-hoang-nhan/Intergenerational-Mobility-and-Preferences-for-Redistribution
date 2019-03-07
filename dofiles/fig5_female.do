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
log using "figure5_female", text replace

cd "$path"
cd dataset


*******************************************************************
*******************************************************************
*** FIGURE 5: ROLE OF EFFORT - BASELINE VS CONDITIONAL BELIEFS  ***
*******************************************************************
*******************************************************************
* Open dataset
use "Data_Descriptive_Waves_ABC.dta", clear	
drop if male == 1
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
				graph export "Fig5_effect_effort_histogram_female.pdf", as(pdf) replace
log close
