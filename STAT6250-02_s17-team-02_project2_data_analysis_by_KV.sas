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
%include '.\STAT6250-02_s17-team-0\2_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Has the price of the house kept increasing or decreasing from 2010 to 
2016 and at what rate? 

Rationale: This should help the investors to see how the housing market behave 
from 2010 to 2016.

Note: This would involve combining housing data from 2011-2015 and taking the 
average of housing price by monthly or yearly.

Methodology: Combining Housing_Data_2011 with Housing_Data_2012 to Housing_Data_2015.
Use proc sort to create a temporary sorted table in descending by
Housing_Data_2011_2015 and then proc print to display the first five
rows of the sorted dataset.

Limitations: This methodology does not account for schools with missing data,
nor does it attempt to validate data in any way, like filtering for percentages
between 0 and 1.

Followup Steps: More carefully clean values in order to filter out any possible
illegal values, and better handle missing data, e.g., by using a previous year's
data or a rolling average of previous years' data as a proxy.
;

proc sort
        data=cde_2014_analytic_file
        out=cde_2014_analytic_file_sorted
    ;
    by descending frpm_rate_change_2014_to_2015;
run;

proc print data=cde_2014_analytic_file_sorted(obs=5);
    id School_Name;
    var frpm_rate_change_2014_to_2015;
run;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What is the relationship between housing price and GDP?

Rationale: This should help the investors understand the picture and the 
relaionship between GDP and housing price.

Note: This would involve merging two data sets one from macroeconomics data set
and housing data set then we can make a table or a graph to see the relationship.

Methodology: Combining Housing_Data_2011 with Housing_Data_2012 to Housing_Data_2015.
Use proc sort to create a temporary sorted table in descending by
Housing_Data_2011_2015 and then se proc means to compute average housing price and 
GDP by month or yearly. Then use proc sort to sort the result by year and look at GDP
and housing price side by side in a table.

Limitations: This methodology solely relies on just looking at the result in the
table, which could be too coarse a method to find actual association between the
variables.

Followup Steps: A possible follow-up to this approach could use an inferential
statistical technique like linear regression and add some graph.
;

proc means min q1 median q3 max data=cde_2014_analytic_file;
    var
        Percent_Eligible_FRPM_K12
        PCTGE1500
    ;
run;
proc format;
    value Percent_Eligible_FRPM_K12_bins
        low-<.39="Q1 FRPM"
        .39-<.69="Q2 FRPM"
        .69-<.86="Q3 FRPM"
        .86-high="Q4 FRPM"
    ;
    value PCTGE1500_bins
        low-20="Q1 SAT_Scores_GE_1500"
        20-<37="Q2 SAT_Scores_GE_1500"
        37-<56.3="Q3 SAT_Scores_GE_1500"
        56.3-high="Q4 SAT_Scores_GE_1500"
    ;
run;
proc freq data=cde_2014_analytic_file;
    table
             Percent_Eligible_FRPM_K12
            *PCTGE1500
            / missing norow nocol nopercent
    ;
        where not(missing(PCTGE1500))
    ;
    format
        Percent_Eligible_FRPM_K12 Percent_Eligible_FRPM_K12_bins.
        PCTGE1500 PCTGE1500_bins.
    ;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What is the difference in housing price between the houses near metro 
area and the ones further from the metro area?

Rationale: This should help the investors understand the housing price in 
different areas of the market.

Note: This would involve making table to show the housing price in different areas.

Methodology:  Combining Housing_Data_2011 with Housing_Data_2012 to Housing_Data_2015.
Use proc sort to create a temporary sorted table in descending by
Housing_Data_2011_2015 and then use Proc mean to calculate the average price in each
metro area and compare them.

Limitations: This methodology does not account for missing data,
nor does it attempt to validate data in any way, like filtering for values
outside of admissable values.

Followup Steps: More carefully clean the values of variables so that the
statistics computed do not include any possible illegal values, and better
handle missing data, e.g., by using a previous year's data or a rolling average
of previous years' data as a proxy.
;

proc sort
        data=cde_2014_analytic_file
        out=cde_2014_analytic_file_sorted
    ;
    by descending excess_sat_takers;
run;

proc print data=cde_2014_analytic_file_sorted(obs=10);
    id School_Name;
    var excess_sat_takers;
run;

