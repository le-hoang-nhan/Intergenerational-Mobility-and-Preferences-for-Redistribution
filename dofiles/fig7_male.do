***********************************
* (Project 7_Mobility)
*
* (Hoang Nhan Le and Zhengxiao Qin)
* 
* (May 10th,2018)
***********************************

cd "$path"
cd logs

log using "logfig7_male", text replace

cd "$path"
cd dataset

**********************************************************************
**********************************************************************
***		 FIGURE 7: PERCEPTIONS OF GOVERNMENT AND FAIRNESS		   ***
**********************************************************************
**********************************************************************

set more off

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
				graph export "Fig7_Government_Country_male.pdf", as(pdf) replace
				
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
				graph export "Fig7_Government_LeftRight_male.pdf", as(pdf) replace
				
restore				
		

		
				

****** (rest of the do file

log close
