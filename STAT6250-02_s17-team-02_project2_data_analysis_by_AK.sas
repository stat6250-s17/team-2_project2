

*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the  analytic dataset to address several research
questions regarding Average House Price per square meter.
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
/*
Research Question: What are the top five districts that experienced the biggest increase in "Average House Price per square meter" between AY2014 and AY2015?
Rationale: This should help identify districts to consider for investment having a high percentage increase in Average House Price per meter to gain more profit.


Research Question: Can increase in Employment rate will be used to predict the "Average House Price per square meter"
Rational: This would help inform the investors whether change in employment rate has any effect on Average House Price per square meter


Research Question: Can increase in Average monthly salary will be used to predict the “Average House Price per square meter”?
Rational: This would help inform the investors whether increase in Average monthly salary has any effect on Average House Price per square meter
*/;


