*****************************************************
* RA work FAll 2019
* .do file: master.do
* date: 9/26/2019
* Code written by: Debasmita Das
* das57@purde.edu
*****************************************************

cd "C:\Users\das57\Documents\My TA-RA Works\RA_Fall2019_Trevor"
*!! change path !!

clear

*  Original Datasets and Dictionary Files (under /nlsy_2019) are downloaded from https://www.nlsinfo.org/investigator/pages/search.jsp?s=NLSY79
*   Create the raw datasets: Read in the dictionary file, keep variables of interest, rename variables, variable construction, data cleaning.
*   Output: nlsy_2019/nlsy_working.dta

do "dataclean.do"



* Estimation of contribution of motherhood to the size of permanent shocks
* Data used: nlsy_2019/nlsy_working.dta 
* Output: nlsy_2019/residual.dta

do "incvariance.do"


