# NLSY


This repository contains STATA codes that I wrote for an RA Assignment for Prof. Trevor Gallen (Fall 2019). In this project, I used data from the NLSY (National Longitudinal Survey Data) to **estimate the contribution of motherhood to the size of permanent income risk**.

### Data and Stata Files
-  Original Datasets and Dictionary Files (under /nlsy_2019) are downloaded from [the NLSY investigator](https://www.nlsinfo.org/investigator/pages/search.jsp?s=NLSY79)

### Code
* [`dataclean.do`](https://github.com/debasmita-das-econ/NLSY/blob/main/dataclean.do): Loads the raw dataset, reads in the dictionary file, keeps variables of interest, renames variables, constructs variables, cleans data and save working data.
    * Output: nlsy_2019/nlsy_working.dta
    * We can get the working data by running the dataclean.do file

* [`incvariance.do`](https://github.com/debasmita-das-econ/NLSY/blob/main/incvariance.do): Estimates contribution of motherhood to the size of permanent income shocks
    * Data used: nlsy_2019/nlsy_working.dta 
    * Output: nlsy_2019/residual.dta
    * Deflate nominal income variables using personal consumption expenditure, estimate residual income by performing regression, estimate variance of the permanent income shocks  
* [`master.do`](https://github.com/debasmita-das-econ/NLSY/blob/main/master.do): runs all .do files using one click

### Author
Debasmita Das (Purdue University, 2019)
