*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the  analytic dataset to address several research
questions regarding Average House Price per square meter.

Dataset Name: Housing_Data_2014_raw_sorted, Housing_Data_2015_raw_sorted and 
macro_raw_sorted  created in external file 
STAT6250-02_s17-team-2_project2_data_preparation.sas, which is assumed to be 
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))"""
;


* load external file that generates analytic dataset cde_2014_analytic_file;
%include '.\STAT6250-02_s17-team-02_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the top five districts districts that have highest "Average House Price per square meter" between AY2014 and AY2015?'
;

title2
'Rationale: This should help identify districts to consider for investment having highest "Average House Price per square meter".'
;

title3
'Top 5 Districts having highest "Average House Price per square meter".'
;

footnote1
'Horoshevo-Mnevniki district has highest Average House Price per square meter during AY2014 and AY2015.'
;


footnote2
'Given the magnitude of these average house price, further investigation should be performed to ensure no data errors are involved.'
;


              
*
Note: Average House Price per square meter is calculated as sale price per total 
area in square meters.

Methodology: When combining Housing_Data_2014_raw_sorted with Housing_Data_2015_
raw sorted using proc sql, union and use aggregated function average to compute 
the average sale price per total area in square meters for each district. Use 
label to display the data in user friendly format. Reuslt is restricted to 5 records 
having highest Average House Price per square meter.

Limitations: This methodology does not account for districts with missing data.

Follow-up Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc sql outobs = 5;
    select
         Housing_Data_Group.sub_area
         label = "District"
        ,Housing_Data_Group.avg_price
         label = "Average House Price per square meter"
    from
        (
            select
                 Housing_Data_combined.sub_area
                ,avg(
                     Housing_Data_combined.price_doc
                     / Housing_Data_combined.full_sq
                 )
                 AS avg_price
            from 
                (
                    (
                        select
                            sub_area
                           ,price_doc
                           ,full_sq
                        from
                            Housing_Data_2014_raw_sorted
                    )
                    union all
                    (
                        select
                            sub_area
                           ,price_doc
                           ,full_sq
                        from
                           Housing_Data_2015_raw_sorted
                    )
                ) AS Housing_Data_combined
            where
                Housing_Data_combined.full_sq <> 0
            group by
                Housing_Data_combined.sub_area
        ) AS Housing_Data_Group
    order by
        Housing_Data_Group.avg_price desc
    ;
quit;
title;
footnote;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What are the bottom five districts that have lowest "Average House Price per square meter" between AY2014 and AY2015?'
;

title2
'Rationale: This should help identify districts to avoid for investment having lowest "Average House Price per square meter".'
;

title3
'Bottom 5 Districts having lowest "Average House Price per square meter".'
;

footnote1
'Molzhaninovskoe district has lowest Average House Price per square meter during AY2014 and AY2015.'
;

footnote2
'Given the magnitude of these lowest average house price, further investigation should be performed to ensure no data errors are involved.'
;



*
Note: Average House Price per square meter is calculated as sale price per total 
area in square meters.

Methodology: When combining Housing_Data_2014_raw_sorted with Housing_Data_2015_
raw sorted using proc sql, union and use aggregated function average to compute 
the average sale price per total area in square meters for each district. Use 
label to display the data in user friendly format. Reuslt is restricted to 5 records 
having lowest Average House Price per square meter.

Limitations: This methodology does not account for districts with missing data.

Follow-up Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc sql outobs = 5;
    select
         Housing_Data_Group.sub_area
         label = "District"
        ,Housing_Data_Group.avg_price
         label = "Average House Price per square meter"
    from
        (
            select
                 Housing_Data_combined.sub_area
                ,avg(
                     Housing_Data_combined.price_doc
                     / Housing_Data_combined.full_sq
                 )
                 AS avg_price
            from 
                (
                    (
                        select
                            sub_area
                           ,price_doc
                           ,full_sq
                        from
                            Housing_Data_2014_raw_sorted
                    )
                    union all
                    (
                        select
                            sub_area
                           ,price_doc
                           ,full_sq
                        from
                           Housing_Data_2015_raw_sorted
                    )
                ) AS Housing_Data_combined
            where
                Housing_Data_combined.full_sq <> 0
            group by
                Housing_Data_combined.sub_area
        ) AS Housing_Data_Group
    order by
        Housing_Data_Group.avg_price asc
    ;
quit;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Does Average monthly salary and Average income per capita correlated with the Average House Price per square meter between AY2014 and AY2015?'
;

title2
'Rationale: This should help identify the correlation between the Average monthly salary and Average income per capita correlated with the Average House Price per square meter.'
;

title4
'Correlation Matrix of Average monthly salary, Average income per capita and Average House Price per square meter".'
;

footnote1
'Average monthly salary has vary weak negative correlation with Average House Price per square meter during AY2014 and AY2015.'
;

footnote2
'Average income per capita has weak positive correlation with Average House Price per square meter during AY2014 and AY2015.'
;

footnote3
'As there are few variation in Average income per capita and Average monthly salary, further investigation should be performed to ensure no data errors are involved.'
;

*
Note: Average House Price per square meter is calculated as sale price per total 
area in square meters per day.

Methodology: Using proc corr procedure correlation matrix is generated between .
Average monthly salary, Average income per capita and Average House Price per 
square meter

Limitations: This methodology does not account for days doesn't match between Macro 
and Housing Data Set.

Follow-up Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc corr
	nosimple 
	data=Housing_Macro_Combined outp=corr
	; 
 	var avg_price_sqm income_per_cap salary
	;
run;

title;
footnote;
