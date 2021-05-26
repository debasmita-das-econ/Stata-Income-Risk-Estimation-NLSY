# NLSY

RA Assignment for Prof. Trevor Gallen (Fall 2019)

**Used data from the NLSY to estimate contribution of motherhood to the size of permanent income shocks**

### Data and Stata Files
-  Original Datasets and Dictionary Files (under /nlsy_2019) are downloaded from https://www.nlsinfo.org/investigator/pages/search.jsp?s=NLSY79

**dataclean.do:** Creates the raw dataset, read in the dictionary file, keep variables of interest, rename variables, variable construction, cleaned data.
-  Output: nlsy_2019/nlsy_working.dta
-  We can get the working data by running the dataclean.do file

**incvariance.do:** estimates of contribution of motherhood to the size of permanent shocks
- Data used: nlsy_2019/nlsy_working.dta 
- Output: nlsy_2019/residual.dta

**master.do:** run all .do files using one click
