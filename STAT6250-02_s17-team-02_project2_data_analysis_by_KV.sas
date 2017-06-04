*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding Russian housing market

Dataset Name: housing_data_analytic_file created in external file
STAT6250-02_s17-team-2_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset cde_2014_analytic_file;
%include '.\STAT6250-02_s17-team-02_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Has the price of the house kept increasing or decreasing from 2014 to mid 2015 and at what rate?'
;

title2
'Rationale: This should help the investors understand how the housing market behave from 2014 to mid 2015.'
;

footnote1
'From Janaury 2014 to June 2015, the housing price in Russia has increased from 7,002,025 Ruble to 8,062,025 Ruble. '
;

footnote2
'We can see the consistent increase from Janaury 2014 until March 2015, then the housing prices started to decrease after that.'
;

footnote3
'Also we can see that there were more number of houses sold in 2014 than in the 2015. This implies that in 2015 the house price is driven up by a small volume unlike in 2014.'
;

*
Note: This would involve combining housing data from 2014-2015 and taking the 
average of housing price by monthly.

Methodology: Combining Housing_Data_2014 with Housing_Data_2015.
Use proc sort to create a temporary sorted table in descending by
Housing_Data_2014_2015.

Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy. Present data with
visualization instead of table
;


proc means data=housing_concat nway;
  where timestamp between '09JAN2014'd and '30JUN2015'd ;
  class timestamp ;
  format timestamp yymon. ;
  var price_doc ;
run;
title;
footnote;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
'Research Question: What is the relationship between housing price and economics indicators such as cpi, salary growth, income per capita and labor_force?'
;

title2
'Rationale: This should help the investors understand the big picture which is the relaionship between economics indicators and housing price.'
;

footnote1
'At the first glance the economics indicators that increase along with housing price from Janaury 2014 to March 2015 are CPI, income per capita'
;

footnote2
'We do not see any increase for salary grwoth and labor force. Salar growth actually went down while labor force approximately going side way.'
;

*
Note: This would involve merging two data sets one from macroeconomics data set
and housing data set then we can make a table or a graph to see the relationship.

Methodology: Combining Housing_Data_2014 with Housing_Data_2015.
Use proc means to compute average housing price and 
cpi, income_per_capital, salary_growth, and labor_force by month or yearly. 

Limitations: This methodology solely relies on just looking at the result in the
table, which could be too coarse a method to find actual association between the
variables.

Followup Steps: A possible follow-up to this approach would be to use an inferential
statistical technique like linear regression and add some graphs.
;

proc means data=housing_and_macro_edited;
  where timestamp between '09JAN2014'd and '30JUN2015'd ;
  class timestamp cpi income_per_cap salary_growth labor_force;
  format timestamp yymon.;
  var housing_price_avg;
run;
title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
'Research Question: What is the difference in housing price between the houses near metro area and the ones further from the metro area?'
;

title2
'Rationale: This should help the investors understand the housing price in different areas of the market.'
;

footnote1
'As expected houses that are close to metro area are more expensive which is about 25% more expensive than the ones that are further away from metro area.'
;

footnote2
'Majority of the houses that are near metro area has the average price is about 7,699,464 Ruble.'
;

footnote3
'There's no big price difference in the houses that are far or very far from the metro area.'
;

*
Note: This would involve making table to show the housing price in different areas.

Methodology:  Combining Housing_Data_2014 with Housing_Data_2015.
Use proc sort to create a temporary sorted table in descending by
Housing_Data_2011_2015 and then use Proc mean to calculate the average price in each
metro area and compare them.

Limitations: This methodology does not account for missing data,
nor does it attempt to validate data in any way, like filtering for values
outside of admissable values.

Followup Steps: More carefully clean the values of variables so that the
statistics computed do not include any possible illegal values, and better
handle missing data, e.g., by using a previous year's data or a rolling average
of previous years' data as a proxy. We should also add another dimension by
looking at this data across time. 
;

proc means mean data=housing_concat;
    class metro_min_walk;
    var price_doc;
    format metro_min_walk $metro_min_walk_bins.;
    output out=house_price_metro;
run;
title;
footnote;
