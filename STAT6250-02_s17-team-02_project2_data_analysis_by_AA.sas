
*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding (...........)
Dataset Name: (...........) created in external file
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
Rationale: this will help to determine the average price based on ecology conditions.


[Research Question 2] what is the average price for owner-occupied purchase per year?
Rational: to show the mean price per year for owner-occupied purchase properties.


[Research Question 3] does the number of cafes within 500m of the property correlated with the property’s price? 
Rational: to see if there is a correlation between the price and the number of café in the area
