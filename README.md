The easiest way to get the `fia` package is to install from the bitbuket
repository.

    library("devtools")

    devtools::install_bitbucket("meireles/fia", quiet = TRUE)

Now you can just load the package.

    library("fia")

All of the data lives in the FIADB webpage. You can see the default FIA
url, simply run `fia_base_url()` and check the results.

    fia::fia_base_url()

    ## [1] "http://apps.fs.fed.us/fiadb-downloads"

The FIA dataset is complex and composed of many different tables. There
are two main types of tables, holding:

-   Reference Data: For instance, species names in the
    `REF_SPECIES` table.
-   Plot data: For example, the individual tree data in `TREE` or
    geometry of each plot in `PLOTGEOM`.

In general, to find out what tables are available in the fia using:

    tab = fia::list_available_tables() # returns a list with the tables and states available in the dataset.

    ## Trying to download tables from: "http://apps.fs.fed.us/fiadb-downloads"

    ## Just for kicks, check our the header of each object in the list
    lapply(tab, head)

    ## $reference_table_names
    ## [1] "BEGINEND"               "LICHEN_SPECIES_SUMMARY"
    ## [3] "REF_CITATION"           "REF_FIADB_VERSION"     
    ## [5] "REF_FOREST_TYPE"        "REF_FOREST_TYPE_GROUP" 
    ## 
    ## $data_table_names
    ## [1] "BOUNDARY"                "COND"                   
    ## [3] "COND_DWM_CALC"           "COUNTY"                 
    ## [5] "DWM_COARSE_WOODY_DEBRIS" "DWM_DUFF_LITTER_FUEL"   
    ## 
    ## $data_states
    ## [1] "AL" "AK" "AZ" "AR" "CA" "CO"
    ## 
    ## $url_downloaded_from
    ## [1] "http://apps.fs.fed.us/fiadb-downloads"
    ## 
    ## $reference_tables
    ##                   zip_tables                 csv_tables n_records
    ## 1               BEGINEND.zip               BEGINEND.csv         2
    ## 2 LICHEN_SPECIES_SUMMARY.zip LICHEN_SPECIES_SUMMARY.csv      2404
    ## 3           REF_CITATION.zip           REF_CITATION.csv        35
    ## 4      REF_FIADB_VERSION.zip      REF_FIADB_VERSION.csv        19
    ## 5        REF_FOREST_TYPE.zip        REF_FOREST_TYPE.csv       207
    ## 6  REF_FOREST_TYPE_GROUP.zip  REF_FOREST_TYPE_GROUP.csv        34
    ##   last_created last_modified
    ## 1   2013/09/24          <NA>
    ## 2   2014/08/04          <NA>
    ## 3   2012/10/26          <NA>
    ## 4   2015/05/08    2015/03/19
    ## 5   2014/06/18    2009/01/28
    ## 6   2010/04/21    2010/06/17
    ## 
    ## $data_tables_by_state
    ##   state_name state_abbreviation                     zip_tables
    ## 1    ALABAMA                 AL                         AL.zip
    ## 2    ALABAMA                 AL                AL_BOUNDARY.zip
    ## 3    ALABAMA                 AL                    AL_COND.zip
    ## 4    ALABAMA                 AL           AL_COND_DWM_CALC.zip
    ## 5    ALABAMA                 AL                  AL_COUNTY.zip
    ## 6    ALABAMA                 AL AL_DWM_COARSE_WOODY_DEBRIS.zip
    ##                       csv_tables n_records last_created last_modified
    ## 1                           <NA>        NA         <NA>          <NA>
    ## 2                AL_BOUNDARY.csv      5798   2015/11/17    2011/11/04
    ## 3                    AL_COND.csv     43386   2016/01/13    2016/01/13
    ## 4           AL_COND_DWM_CALC.csv       421   2014/12/16    2015/05/08
    ## 5                  AL_COUNTY.csv        67   2002/04/23    2005/03/22
    ## 6 AL_DWM_COARSE_WOODY_DEBRIS.csv      1158   2015/11/17    2014/12/15
    ## 
    ## $data_tables_states_combined
    ##                    zip_tables                  csv_tables n_records
    ## 1                BOUNDARY.zip                BOUNDARY.csv    148971
    ## 2                    COND.zip                    COND.csv   1693174
    ## 3           COND_DWM_CALC.zip           COND_DWM_CALC.csv    123481
    ## 4                  COUNTY.zip                  COUNTY.csv      3204
    ## 5 DWM_COARSE_WOODY_DEBRIS.zip DWM_COARSE_WOODY_DEBRIS.csv    437932
    ## 6    DWM_DUFF_LITTER_FUEL.zip    DWM_DUFF_LITTER_FUEL.csv    701370
    ##   last_created last_modified
    ## 1   2015/12/07    2016/02/05
    ## 2   2016/01/13    2016/02/05
    ## 3   2015/10/27    2016/02/05
    ## 4   2013/01/11    2016/02/05
    ## 5   2015/12/07    2016/02/05
    ## 6   2015/12/07    2016/02/05

Once you figured what data you want to grab, go ahead and download it
with:

    my_table_names =  c("REF_SPECIES", "PLOT") # Chosen from tab$reference_table_names and tab$data_table_names

    my_states     = c("NC", "MN") # Chosen from tab$data_states.
    my_states_2   = "ALL"         # Or choose all states. Will get files in tab$data_tables_states_combined
    my_output_dir = "~/somewhere/on/my/computer" # Where to save the downloaded files to?

    fia::download_fia_tables(table_names = my_table_names,
                             states = my_states,
                             destination_dir = my_output_dir,
                             list_available_tables = tab)
