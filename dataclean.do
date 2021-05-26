
*****************************************************
* RA work FAll 2019
* .do file: dataclean.do
* date: 9/9/2019
* Code written by: Debasmita Das
* das57@purde.edu
*****************************************************

cd "C:\Users\das57\Documents\My TA-RA Works\RA_Fall2019_Trevor"
*!! change path !!

set more off
clear

local dat_name "nlsy_2019/nlsy_2019.dat"
local dta_name "nlsy_2019/nlsy_working.dta"
local dct_name "nlsy_2019/nlsy_2019.dct"

quietly infile using "`dct_name'", using("`dat_name'") clear

do "nlsy_2019/nlsy_2019-value-labels.do"

order CASEID_1979 SAMPLE_ID_1979 SAMPLE_RACE_78SCRN SAMPLE_SEX_1979 MARSTAT_KEY_* TNFI_* TNFW_* Q13_5_* Q13_18_* Q10_13_* Q10_32_* Q3_4_* AGEATINT_*

*------------------------
*  		VARIBLES
*------------------------

* Marital Status & Net Family Income
foreach x of numlist 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014 2016 {
rename MARSTAT_KEY_`x' marst`x'
rename TNFI_TRUNC_`x' NetInc`x'
}

* Net wealth
foreach x of numlist 1985 1986 1987 1988 1989 1990 1992 1993 1994 1996 1998 2000 2004 2008 2012 2016 {
rename TNFW_TRUNC_`x' NetWlth`x'
}

* Own Income & Spouse Income
foreach x of numlist 1979 1980 1981 {
rename Q13_5_`x' Inc`x'
rename Q13_18_`x' IncSp`x'
}

foreach x of numlist 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1996 1998 2000 {
rename Q13_5_TRUNC_REVISED_`x' Inc`x'
rename Q13_18_TRUNC_REVISED_`x' IncSp`x'
}

foreach x of numlist 2002 2004 2006 2008 2010 2012 2014 2016 {
rename Q13_5_TRUNC_`x' Inc`x'
rename Q13_18_TRUNC_`x' IncSp`x'
}

* child care
* child 1/2 (c_1/ c_2); year of care 1/2 (yr1care/yr2care)

* year 1
rename Q10_13_1_1986    c1_yr1care1986
rename Q10_13_2_1986 	c2_yr1care1986
rename Q10_13_1_1988    c1_yr1care1988
rename Q10_13_2_1988 	c2_yr1care1988
rename Q10_13_1_1992 	c1_yr1care1992
rename Q10_13_2_1992 	c2_yr1care1992

foreach x of numlist 1994 1996 1998 2000 2002 2004 2006 2008 2010 2014 {
rename Q10_13_01_`x' c1_yr1care`x'
rename Q10_13_02_`x' c2_yr1care`x'
}
rename Q10_13_02_2012 	c2_yr1care2012

* year  2
foreach x of numlist 1994 1996 1998 2000 2002 2004 2006 2008 2010 2014 {
rename Q10_32_01_`x' c1_yr2care`x'
rename Q10_32_02_`x' c2_yr2care`x'
}
rename Q10_32_02_2012 	c2_yr2care2012

* Age of Respondent
*------------------------------------------------------------------------------------------------------------------------------------------
* Date of birth information was collected from each NLSY79 respondent during the 1979 and 1981 interviews. 
* The variable 'Age of R,' gathered during the 1979-83 surveys, is the self-reported age of the respondent as of the interview date.
* The NLSY79 main data files also contain a yearly created variable, 'Age of R at Interview Date.' 
*-------------------------------------------------------------------------------------------------------------------------------------------

foreach x of numlist 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014 2016 {
rename AGEATINT_`x' age`x'
}

* Education

foreach x of numlist 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014 2016 {
rename Q3_4_`x' educ`x'
}

* child DOB, sex, race
foreach x of numlist 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1996 1998 2000 2002 2004 2006 2008 2010 2012 2014 2016 {

gen c1DOB_m`x' = C1DOB_M_XRND
gen c1DOB_y`x' = C1DOB_Y_XRND
gen c2DOB_m`x' = C2DOB_M_XRND
gen c2DOB_y`x' = C2DOB_Y_XRND
gen c3DOB_m`x' = C3DOB_M_XRND
gen c3DOB_y`x' = C3DOB_Y_XRND

gen race`x' = SAMPLE_RACE_78SCRN
gen sex`x'  = SAMPLE_SEX_1979

}

drop SAMPLE_ID_1979 SAMPLE_RACE_78SCRN SAMPLE_SEX_1979 C1DOB_M_XRND C1DOB_Y_XRND C2DOB_M_XRND C2DOB_Y_XRND C3DOB_M_XRND C3DOB_Y_XRND FL1M1B_XRND Q1_3_A_M_1981 Q1_3_A_Y_1981

order CASEID_1979 marst* NetInc* NetWlth* Inc* IncSp* c1_yr1care* c2_yr1care* c1_yr2care* c2_yr2care* c1DOB_m* c2DOB_m* c3DOB_m* c1DOB_y* c2DOB_y* c3DOB_y* race* sex* age* educ*

rename CASEID_1979 CASEID

reshape long marst NetInc NetWlth Inc IncSp c1_yr1care c2_yr1care c1_yr2care c2_yr2care c1DOB_m c2DOB_m c3DOB_m c1DOB_y c2DOB_y c3DOB_y race sex age educ, i(CASEID) j(year)

* missing data
foreach var of varlist marst NetInc NetWlth Inc IncSp c1_yr1care c2_yr1care c1_yr2care c2_yr2care c1DOB_m c2DOB_m c3DOB_m c1DOB_y c2DOB_y c3DOB_y race sex age educ{
   replace `var' =. if `var'<0
}

* create variable to identify presence of child
sort CASEID year
by CASEID year: gen haschild = year - c1DOB_y
order year CASEID c1DOB_m c1DOB_y haschild

la var year 	  "Year"
la var marst	  "Marital Status"
la var NetInc 	  "Total Net Family Income"
la var NetWlth 	  "Family Net Wealth"
la var Inc 		  "Respondent's Wages/Salary/Tips"
la var IncSp 	  "Spouse's Wages/Salary/Tips"
la var c1_yr1care "Child #1 Care Year 1"
la var c2_yr1care "Child #2 Care Year 1"
la var c1_yr2care "Child #1 Care Year 2"
la var c2_yr2care "Child #2 Care Year 2"
la var c1DOB_m 	  "Child #1 DOB Month"
la var c2DOB_m 	  "Child #2 DOB Month"
la var c3DOB_m 	  "Child #3 DOB Month"
la var c1DOB_y 	  "Child #1 DOB Year"
la var c2DOB_y 	  "Child #2 DOB Year"
la var c3DOB_y 	  "Child #3 DOB Year"
la var race 	  "Respondent's Race"
la var sex		  "Respondent's Sex"
la var age        "Respondent's Age"
la var educ		  "Highest Grade Completed"
la var haschild	  "Countdown for child birth"

save "nlsy_2019/nlsy_working.dta", replace




