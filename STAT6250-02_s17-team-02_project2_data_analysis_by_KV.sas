*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding college-preparation trends at CA public K-12 schools

Dataset Name: cde_2014_analytic_file created in external file
STAT6250-02_s17-team-0_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset cde_2014_analytic_file;
%include '.\STAT6250-02_s17-team-0_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What are the top five schools that experienced the biggest increase
in "Percent (%) Eligible Free (K-12)" between AY2014-15 and AY2015-16?

Rationale: This should help identify schools to consider for new outreach based
upon increasing child-poverty levels.

Note: This compares the column "Percent (%) Eligible Free (K-12)" from frpm1415
to the column of the same name from frpm1516.

Methodology: When combining frpm1415 with frpm1516 during data preparation,
take the difference of values of "Percent (%) Eligible Free (K-12)" for each
school and create a new variable called frpm_rate_change_2014_to_2015. Here,
use proc sort to create a temporary sorted table in descending by
frpm_rate_change_2014_to_2015 and then proc print to display the first five
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
Question: Can "Percent (%) Eligible FRPM (K-12)" be used to predict the
proportion of high school graduates earning a combined score of at least 1500
on the SAT?

Rationale: This would help inform whether child-poverty levels are associated
with college-preparedness rates, providing a strong indicator for the types of
schools most in need of college-preparation outreach.

Note: This compares the column "Percent (%) Eligible Free (K-12)" from frpm1415
to the column PCTGE1500 from sat15.

Methodology: Use proc means to compute 5-number summaries of "Percent (%)
Eligible Free (K-12)" and PCTGE1500. Then use proc format to create formats
that bin both columns with respect to the proc means output. Then use proc freq
to create a cross-tab of the two variables with respect to the created formats.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations along quartile values, which could be too coarse a
method to find actual association between the variables.

Followup Steps: A possible follow-up to this approach could use an inferential
statistical technique like linear regression.
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
Question: What are the top ten schools were the number of high school graduates
taking the SAT exceeds the number of high school graduates completing UC/CSU
entrance requirements?

Rationale: This would help identify schools with significant gaps in
preparation specific for California's two public university systems, suggesting
where focused outreach on UC/CSU college-preparation might have the greatest
impact.

Note: This compares the column NUMTSTTAKR from sat15 to the column TOTAL from
gradaf15.

Methodology: When combining sat15 and gradaf15 during data preparation, take
the difference between NUMTSTTAKR in sat15 and TOTAL in gradaf15 for each
school and create a new variable called excess_sat_takers. Here, use proc sort
to create a temporary sorted table in descending by excess_sat_takers and then
proc print to display the first 10 rows of the sorted dataset.

Limitations: This methodology does not account for schools with missing data,
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

