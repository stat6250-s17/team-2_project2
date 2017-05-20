*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
[Dataset 1 Name] Marcoeconomics

[Dataset Description] Russia's macro economy and financial sector Data, AY2010-16 

[Experimental Unit Description] Macroeconomics data in AY2010-16

[Number of Observations] 2484                    

[Number of Features] 100

[Data Source] https://www.kaggle.com/c/sberbank-russian-housing-market/download/macro.csv.zip

[Data Dictionary] https://www.kaggle.com/c/sberbank-russian-housing-market/download/data_dictionary.txt

[Unique ID Schema] The columns "timestamp"

--


[Dataset 5 Name] Housing_Data_2014

[Dataset Description] this dataset includes information about individual transactions. The rows are indexed by the "id" field, which refers to individual transactions. These files also include supplementary information about the local area of each property (from 2014)

[Experimental Unit Description] Housing data from Sberbank Russian Housing Market

[Number of Observations] 13662                   

[Number of Features] 291

[Data Source] https://www.kaggle.com/c/sberbank-russian-housing-market/download/test.csv.zip

[Data Dictionary] https://www.kaggle.com/c/sberbank-russian-housing-market/download/data_dictionary.txt

[Unique ID Schema] The columns "timestamp"

--

[Dataset 6 Name] Housing_Data_2015

[Dataset Description] this dataset includes information about individual transactions. The rows are indexed by the "id" field, which refers to individual transactions. These files also include supplementary information about the local area of each property (from 2015)

[Experimental Unit Description] Housing data from Sberbank Russian Housing Market

[Number of Observations] 3239                   

[Number of Features] 291

[Data Source] https://www.kaggle.com/c/sberbank-russian-housing-market/download/test.csv.zip

[Data Dictionary] https://www.kaggle.com/c/sberbank-russian-housing-market/download/data_dictionary.txt

[Unique ID Schema] The columns "timestamp"

--

* setup environmental parameters;
%let inputDataset1URL = https://github.com/stat6250/team-2_project2/blob/master/Data/Housing_Data_2014.csv?raw=true;
%let inputDataset1Type = CSV;
%let inputDataset1DSN = Housing_2014;

%let inputDataset2URL = https://github.com/stat6250/team-2_project2/blob/master/Data/Housing_Data_2015.csv?raw=true;
%let inputDataset2Type = CSV;
%let inputDataset2DSN = Housing_2015;

%let inputDataset3URL = https://github.com/stat6250/team-2_project2/blob/master/Data/macro_2014-2015.csv?raw=true;
%let inputDataset3Type = CSV;
%let inputDataset3DSN = Macro;

* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xls";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;


%loadDataIfNotAlreadyAvailable(
    &inputDataset1DSN.,
    &inputDataset1URL.,
    &inputDataset1Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset2DSN.,
    &inputDataset2URL.,
    &inputDataset2Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset3DSN.,
    &inputDataset3URL.,
    &inputDataset3Type.
)



* sort and check raw datasets for duplicates with respect to their unique ids,
  removing blank rows, if needed;
proc sort
        nodupkey
        data=Macro
        dupout=Macro_dups
        out=Macro_sorted(where=(not(missing(timestamp))))
    ;
    by
        timestamp
    ;
run;

proc sort
        nodupkey
        data=Housing_2014
        dupout=Housing_Data_2014_dups
        out=Housing_2014_sorted
    ;
    by
       id
    ;
run;

proc sort
        nodupkey
        data=Housing_2015
        dupout=Housing_2015_dups
        out=Housing_2015_sorted
    ;
    by
        id
    ;
run;

* combine Housing_Data_2014 and Housing_Data_2015 data vertically, combine composite key values into a primary key
  key, and compute year-over-year change in Percent_Eligible_FRPM_K12,
  retaining all AY2014-15 fields and y-o-y Percent_Eligible_FRPM_K12 change;

Data Housing.interlv;
	set Housing_2014 Housing_2015;
	by id
run;

proc sql;
    create table Macro_and_Housing_Price_2014_2015 as
        select Month, UniqueCarrier, avg(ArrDelay) as ArrDelay_avg
        from flights_analytic_file
        group by Month, UniqueCarrier
        order by Month, UniqueCarrier desc
    ;
quit;
