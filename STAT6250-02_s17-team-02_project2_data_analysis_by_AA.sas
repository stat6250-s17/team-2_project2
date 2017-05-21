
 

*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;
 
*
This file uses the following analytic dataset to address several research
questions regarding the prices for housing
Dataset Name: housing_analytic_file created in external file
STAT6250-02_s17-team-2_project2_data_preparation.sas, which is assumed to be
in the same directory as this file
See included file for dataset properties
;
 
* environmental setup;
 
* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";
 
 
* load external file that generates analytic dataset cde_2014_analytic_file;
%include '.\STAT6250-02_s17-team-2_project2_data_preparation.sas';
 
 
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
[Research Question 1] what is the average price for each ecology level?

Rationale: this will help to determine the average price based on ecology 
conditions

Note: This compares the column ecology and Price_doc 

Methodology: using proc means to calculate the mean per ecology level

Limitations: the numbers may be confusing since the mean prices is almost the
same for excellent and satisfactory so we would need to consider other 
variables such as the size of the lot 

Followup Steps:we can do a regression analysis to check if the ecology level is
helpful in predicting the price of the house
;
 
 
title1
 
'Research Question:what is the average price for each ecology level?'
;
 
 
 
title2
 
'Rationale: this should help to determine the average price based on ecology conditions'
 
;
 
 
 
footnote1
 
" From the table above we can see the mean price for each ecology level "
;
 
 
 
footnote2
 
"the numbers may be confusing since the mean price is almost the same for excellent and satisfactory so we would need to consider other variables such as the size of the lot  "
 
;

footnote3
"Followup Steps:we can do a regression analysis to check if the ecology level is helpful in predicting the price of the house" 
; 
 
proc means data = housing_analytic_file  nway noprint mean;
var price_doc ;
class ecology;
output out = mean_of_price_by_ecology_level
mean=Mean_Price
;
run;

data mean_of_price_by_ecology_level;
set mean_of_price_by_ecology_level;
drop _TYPE_ _FREQ_;run;
 
proc print  data=mean_of_price_by_ecology_level;
run;
 
 
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
[Research Question 2] what is the average price for owner-occupied purchase?

Rational: to show the mean price for owner-occupied purchase 
properties.


Note: This compares the column product_type and Price_doc 

Methodology: using proc means to calculate the mean per type

Limitations:this comparision does not consider other variables that 
might have an effect on the price

Followup Steps:we can do a mean per year for each type to see if 
there is a significant differnces per year
;
 
 
title1
 
'Research Question:what is the average price for owner-occupied purchase?'
;
 
 
 
title2
 
'Rationale:to show the mean price for owner-occupied and investment purchase'
 
;
 
 
 
footnote1
 
" From the table above we can see the mean price is 6,941,522 for OwnerOccupier houses "
;
 
 
 
footnote2
 
"Followup step: to test if the mean is the same for both types we can run a two sample t test "
 
;


proc means data = housing_analytic_file nway noprint ;
var price_doc ;
class Product_type;
output out = mean_of_price_by_type
mean=Mean_Price
;
run;
data mean_of_price_by_type ;
set mean_of_price_by_type ;
drop _TYPE_ _FREQ_;
run;
 
proc print  data=mean_of_price_by_type;
run;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
[Research Question 3] does the number of cafes within 500m of the property 
correlated with the property’s price?

Rational: to see if there is a correlation between the price 
and the number of café in the area

Note: This compares the column cafe_count_500 and Price_doc 

Methodology: using proc corr to calculate the correlation

Limitations: I did not check if there is any missing values for cafe_count_500

Followup Steps: we can check the data to see if there is missing values which 
might effect the correlation calculation
;


title1
 
'Research Question:what is the average price for owner-occupied purchase?'
;
 
 
 
title2
 
'Rationale:to show the mean price for owner-occupied and investment purchase'
 
;
 
 
 
footnote1
 
" From the table above the correlation between the number of cafe within 500 meters and the price is 0.11291   "
;
 
 
 
footnote2
 
"we conclude that there is no correlation between the 2 variables "
 
;
 
proc corr data=housing_analytic_file ;
var price_doc  cafe_count_500;
run;
 
 
