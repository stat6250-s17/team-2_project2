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
%let inputDataset1URL =
https://github.com/stat6250/team-2_project2/blob/master/Data/macro.xls?raw=true
;
%let inputDataset1Type = XLS;
%let inputDataset1DSN = macro_raw;


%let inputDataset2URL =
https://github.com/stat6250/team-2_project2/blob/master/Data/Housing_Data_2014.xls?raw=true
;
%let inputDataset2Type = XLS;
%let inputDataset2DSN = Housing_Data_2014_raw;

%let inputDataset3URL =
https://github.com/stat6250/team-2_project2/blob/master/Data/Housing_Data_2015.xls?raw=true
;
%let inputDataset3Type = XLS;
%let inputDataset3DSN = Housing_Data_2015_raw;

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
        data=macro_raw
        dupout=macro_raw_dups
        out=macro_raw_sorted(where=(not(missing(timestamp))))
    ;
    by
        timestamp
    ;
run;

proc sort
        nodupkey
        data=Housing_Data_2014_raw
        dupout=Housing_Data_2014_raw_dups
        out=Housing_Data_2014_raw_sorted
    ;
    by
       id
    ;
run;
proc sort
        nodupkey
        data=Housing_Data_2015_raw
        dupout=Housing_Data_2015_raw_dups
        out=Housing_Data_2015_raw_sorted
    ;
    by
        id
    ;
run;

