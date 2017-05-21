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

[Data Source] https://www.kaggle.com/c/sberbank-russian-housing-market/download/train.csv.zip

[Data Dictionary] https://www.kaggle.com/c/sberbank-russian-housing-market/download/data_dictionary.txt

[Unique ID Schema] The columns "timestamp"

--

[Dataset 6 Name] Housing_Data_2015

[Dataset Description] this dataset includes information about individual transactions. The rows are indexed by the "id" field, which refers to individual transactions. These files also include supplementary information about the local area of each property (from 2015)

[Experimental Unit Description] Housing data from Sberbank Russian Housing Market

[Number of Observations] 3239                   

[Number of Features] 291

[Data Source] https://www.kaggle.com/c/sberbank-russian-housing-market/download/train.csv.zip

[Data Dictionary] https://www.kaggle.com/c/sberbank-russian-housing-market/download/data_dictionary.txt

[Unique ID Schema] The columns "timestamp"

--

* setup environmental parameters;
%let inputDataset1URL =
https://github.com/stat6250/team-2_project2/blob/master/Data/macro_2014-2015.xlsx?raw=true
;
%let inputDataset1Type = XLSX;
%let inputDataset1DSN = Macro_raw;

%let inputDataset2URL =
https://github.com/stat6250/team-2_project2/blob/master/Data/Housing_Data_2014.xlsx?raw=true
;
%let inputDataset2Type = XLSX;
%let inputDataset2DSN = Housing_Data_2014_raw;

%let inputDataset3URL =
https://github.com/stat6250/team-2_project2/blob/master/Data/Housing_Data_2015.xlsx?raw=true
;
%let inputDataset3Type = XLSX;
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
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
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
        data=Macro_raw
        dupout=Macro_raw_dups
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
        dupout=Housing_2015_raw_dups
        out=Housing_Data_2015_raw_sorted
    ;
    by
        id
    ;
run;

*******************************************************************************;
*
Housing_Macro_Combined datset is created using proc sql statement by 
combining Housing_Data_2014_raw_sorted with Housing_Data_2015_raw sorted using 
union and use aggregated function average to compute the average sale price per 
total area in square meters for each day. Used label to display the data in user 
friendly format. This combined dataset joined with macro_raw_sorted on timestamp.
;
*******************************************************************************;
proc sql noprint;
create table Housing_Macro_Combined as
	select  house_avg_price.timestamp as timestamp 
				label="Date", 

		house_avg_price.avg_price_sqm as avg_price_sqm 
				label="Average House Price per square meter" , 
	   		macro_raw_sorted.salary as salary 
				label ="Average monthly salary " , 
	   		macro_raw_sorted.income_per_cap as income_per_cap 
				label = "Average income per capita "
	from
	(
	 select timestamp, avg(price_doc/full_sq) as avg_price_sqm
	 from Housing_Data_2014_raw_sorted
	 where price_doc <> 0 and full_sq <> 0
	 group by timestamp
	 union all
	 select timestamp, avg(price_doc/full_sq) as avg_price_sqm
	 from Housing_Data_2015_raw_sorted
	 where price_doc <> 0 and full_sq <> 0
	 group by timestamp
	) house_avg_price, macro_raw_sorted 
	where house_avg_price.timestamp = macro_raw_sorted.timestamp
;
run;

*Combine Housing_Data_2014 and Housing_Data_2015 data vertically;
Data housing_concat;
	set Housing_Data_2014_raw_sorted Housing_Data_2015_raw_sorted;
run;


*Take average of housing price by day of the month;
proc sql;
    create table housing_price_avg as
        select timestamp, avg(price_doc) as housing_price_avg
        from housing_concat
        group by timestamp
    ;
quit;

*Combine housing_price_ave with macro data horizontally;
Data housing_and_macro;
	set housing_price_avg;
	set Macro_raw_sorted;
run;

data housing_and_macro_edited;
	retain
		timestamp
		housing_price_avg
		cpi
		income_per_cap
		salary_growth
		retail_trade_turnover_growth
		labor_force
		;
	keep
		timestamp
		housing_price_avg
		cpi
		income_per_cap
		salary_growth
		retail_trade_turnover_growth
		labor_force
		;
	set housing_and_macro;
run;


******************************************************************************;
* 
build analytic dataset with the least number of columns
and minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files
;
******************************************************************************;
data housing_analytic_file;

        retain

	       timestamp

	       product_type

	       ecology

	       cafe_count_500
         
         price_doc

	       ;
	keep
               timestamp

               product_type

               ecology

               cafe_count_500
               
               price_doc

               ;
	set Housing_concat
       ;
  run;
