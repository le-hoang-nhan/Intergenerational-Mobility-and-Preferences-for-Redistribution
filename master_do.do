***The master do file for project 7 Intergenerational Mobility and Preferences for Redistribution***
clear
set more off
cap log close
***Here please enter the path to the root position of our given folder!!!*****
*																		     *
    cd "D:\empirical\project_7"   //  cd"...\project_7" for example          *
*																		     *
***!!! You need to adapt to your enviroment for this project once only********

*********************WARNING*********************************
/*In case if it not running successfully, do not put our root folder into the path with any "space"
in every layer of name of the folders*/

/*To run the code successfully, some external commands are also recommanded to be installed, please follow the 
error code if any wrong with it and use ssc install of "findit" command for searching the solutions*/
cap qui ssc install tabstatmat
cap qui ssc install mat2txt
cap qui ssc install frmttable
cap qui ssc install dataout
cap qui ssc install appendfile
*********************WARNING********************************


***The master do file for project 7 Intergenerational Mobility and Preferences for Redistribution***

**** Make dirs in order to store the "products" of our program****

***Set the return point***
global path `c(pwd)'


**Initialization**
shell rd /s/q $path\logs         /* /s delete all the things below the folder */
shell rd /s/q $path\raw_outcome  /* /q quitely */ 

***Create new folders

shell md $path\logs
shell md $path\raw_outcome


shell md $path\raw_outcome\doc_files
shell md $path\raw_outcome\pdf_files
shell md $path\raw_outcome\excels
shell md $path\raw_outcome\tex_files





***************************Run the do files*************************************




********	Table 2      *********

*Create the Table 2 for the perceived value for each country by gender and test
cd dofiles
do tab_2_part1
cd "$path"  //return to root

shell copy $path\dataset\*.tex $path\raw_outcome\tex_files     //move the outcome
shell delete $path\dataset\*.tex        				//delete previous files

*Create the Table 2 for the difference of perceived and actual for each country
*by gender
cd dofiles
do tab_2_part2
cd "$path"

shell copy $path\dataset\*.tex $path\raw_outcome\tex_files   //move the outcome
shell del $path\dataset\*.tex                            //delete previous files



******     Figure 5  ********

*Generate figure for figure 5 Male*

cd dofiles
do fig5_male
cd "$path"

shell copy $path\dataset\*.pdf $path\raw_outcome\pdf_files     //move the outcome
shell del $path\dataset\*.pdf       				//delete previous files


*Generate figure for figure 5 Female*

cd dofiles
do fig5_female
cd "$path"

shell copy $path\dataset\*.pdf $path\raw_outcome\pdf_files     //move the outcome
shell del $path\dataset\*.pdf       				//delete previous files


*Test for figure 5 between genders*

cd dofiles
do fig5_test
cd "$path"

shell copy $path\dataset\*.doc $path\raw_outcome\doc_files     //move the outcome
shell del $path\dataset\*.doc      				//delete previous files




*****   Figure 7   ******



*Create the table for fig_7 by gender

cd dofiles
do fig7_male
cd "$path"

shell copy $path\dataset\*.pdf $path\raw_outcome\pdf_files     //move the outcome
shell del $path\dataset\*.pdf       				//delete previous files

cd dofiles
do fig7_female
cd "$path"

shell copy $path\dataset\*.pdf $path\raw_outcome\pdf_files     //move the outcome
shell del $path\dataset\*.pdf       				//delete previous files


*Run the test and get the results table


*across countries
cd dofiles
do fig7_test_country
cd "$path"

shell copy $path\dataset\*.xml $path\raw_outcome\excels     //move the outcome
shell del $path\dataset\*.xml       				//delete previous file
shell del $path\dataset\*.txt						

*political 
cd dofiles
do fig7_test_political
cd "$path" 

shell copy $path\dataset\*.xml $path\raw_outcome\excels     //move the outcome
shell del $path\dataset\*.xml       				//delete previous file
shell del $path\dataset\*.txt		


*****   Table 3   ******


***for male***


cd dofiles
do tab3_male
cd "$path" 

shell copy $path\dataset\*.tex $path\raw_outcome\tex_files   //move the outcome
shell del $path\dataset\*.tex                            //delete previous files


***for female***


cd dofiles
do tab3_female
cd "$path"

shell copy $path\dataset\*.tex $path\raw_outcome\tex_files   //move the outcome
shell del $path\dataset\*.tex                            //delete previous files
shell del $path\raw_outcome\tex_files\temp*.tex  //erase miidle results


***    Table 6    ******


***for male***


cd dofiles
do tab6_male
cd "$path" 

shell copy $path\dataset\*.tex $path\raw_outcome\tex_files   //move the outcome
shell del $path\dataset\*.tex                            //delete previous files


***for female***


cd dofiles
do tab6_female
cd "$path"

shell copy $path\dataset\*.tex $path\raw_outcome\tex_files   //move the outcome
shell del $path\dataset\*.tex                            //delete previous files
shell del $path\raw_outcome\tex_files\temp*.tex  //erase miidle results


************The end of our project**********


