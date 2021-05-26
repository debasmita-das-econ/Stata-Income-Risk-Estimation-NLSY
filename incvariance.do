
*****************************************************
* RA work FAll 2019
* .do file: incvariance.do
* date: 9/20/2019
* Code written by: Debasmita Das
* das57@purde.edu
*****************************************************

cd "C:\Users\das57\Documents\My TA-RA Works\RA_Fall2019_Trevor"
*!! change path !!

set more off
clear

use "nlsy_2019/nlsy_working.dta", clear

*--------------------------
* Sample Selection
*---------------------------

/* use only the non-biennial data (before and equal to 1994) */
keep if year < 1996

/* keep only female respondents */
keep if sex == 2

/* drop households with missing observations on marriage, age, income */
drop if marst ==. & NetInc == . & NetWlth == . & Inc == . & IncSp == . & age == . & haschild !=0

/* drop never mom (18.9 per cent of the sample) */
by CASEID year: gen mom = (haschild != .)
drop if mom == 0
drop mom

*---------------
* Real Income
*---------------

* generate real income using PCE (personal consumption expenditure) deflators
* U.S. Bureau of Economic Analysis, Real Personal Consumption Expenditures [PCECCA], retrieved from FRED, Federal Reserve Bank of St. Louis; https://fred.stlouisfed.org/series/PCECCA, September 23, 2019. 
* edit graph=> units => from dropdown menu, select "Index" => choose base year
* Base 1990 = 100

gen 	pce=	70.8	 if year ==	1979
replace pce = 	70.6	 if year ==	1980
replace pce = 	71.5	 if year ==	1981
replace pce = 	72.6	 if year ==	1982
replace pce = 	76.7	 if year ==	1983
replace pce = 	80.7	 if year ==	1984
replace pce = 	84.9	 if year ==	1985
replace pce = 	88.4	 if year ==	1986
replace pce = 	91.4	 if year ==	1987
replace pce = 	95.2	 if year ==	1988
replace pce = 	98.0	 if year ==	1989
replace pce = 	100		 if year ==	1990
replace pce = 	100.2	 if year ==	1991
replace pce = 	103.9	 if year ==	1992
replace pce = 	107.5	 if year ==	1993
replace pce = 	111.7	 if year ==	1994

label var pce "PCE, base year is 1990"

/* Incomes refer to last year, so PCE of year X-1 is used for observations of year X */
foreach var of varlist NetInc NetWlth Inc IncSp {
   gen real_`var' = `var' / pce * 100
}

/* * CPI

*Add a CPI price index and transform variables in real term
*This series is drawn from https://www.minneapolisfed.org/community/financial-and-economic-education/cpi-calculator-information/consumer-price-index-and-inflation-rates-1913
*CPI Base year is chained; 1982-1984 = 100
*2000 U.S. Department Of Labor, Bureau of Labor Statistics, Washington, D.C. 20212
*Consumer Price Index All Urban Consumers - (CPI-U) U.S. city average All items 1982-84=100

gen     price=0.726 if year==1979
replace price=0.824 if year==1980
replace price=0.909 if year==1981
replace price=0.965 if year==1982
replace price=0.996 if year==1983
replace price=1.039 if year==1984
replace price=1.076 if year==1985
replace price=1.096 if year==1986
replace price=1.136 if year==1987
replace price=1.183 if year==1988
replace price=1.240 if year==1989
replace price=1.307 if year==1990
replace price=1.362 if year==1991
replace price=1.403 if year==1992
replace price=1.445 if year==1993
replace price=1.482 if year==1994

label var pce "CPI, base year is 1982-84"

foreach var of varlist NetInc NetWlth Inc IncSp {
   gen real_`var' = `var' / price
}

*/

/* log transformation */
foreach var of varlist real_NetInc real_NetWlth real_Inc real_IncSp{
 gen log_`var' = log(`var')
}

* generate dummies
tab marst, gen(mard)
tab race, gen(raced)
tab year, gen(yrd)

/* Education dummies */

* Make some manual adjustment
sort CASEID year
qui by CASEID: replace educ=educ[_n-1] if educ==.

* Take the maximum grade achieved as the relevant education level
sort CASEID year
egen maxed=max(educ),by(CASEID)
gen educ2=educ
replace educ2=maxed
drop maxed

* create dummies
gen edu_lesshs= ( educ2 < 12)
gen edu_hsgrad= ( educ2 == 12)
gen edu_morehs= ( educ2 > 12)

*------------------------------
* Estimate residual income
*------------------------------
xtset CASEID year
qui regress log_real_Inc age raced* mard* yrd*
predict uy if e(sample), resid

sort CASEID year
qui by CASEID:gen duy=uy-uy[_n-1]

keep CASEID year duy haschild
save nlsy_2019/residual.dta, replace

*----------------------------
* Estimate Auto-covariances
*----------------------------
use "nlsy_2019/residual.dta", clear

sort CASEID year

qby CASEID: gen D_Y_t_after  = (duy[_n-1] + duy + duy[_n+1])*duy if haschild >= 2
qby CASEID: gen D_Y_t0 		 = (duy[_n-1] + duy + duy[_n+1])*duy if haschild == 0
qby CASEID: gen D_Y_t_before = (duy[_n-1] + duy + duy[_n+1])*duy if haschild <= -2

sort year
by year:  reg D_Y_t_after,noheader
by year:  reg D_Y_t0,noheader
by year:  reg D_Y_t_before,noheader

