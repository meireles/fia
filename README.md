# Introduction to fia
Jose Eduardo Meireles  

### Installation
 
The easiest way to get the `fia` package is to install from the bitbuket repository.


```r
library("devtools")

devtools::install_bitbucket("meireles/fia", quiet = TRUE)
```

### Usage

The main goal of the `fia` package is to programatically download FIA data, which lives lives in the FIADB webpage. Use `url_fia()` to see the default FIA url if you're curious.


```r
# Load the `fia` library
library("fia")

# Check out the packages' default FIA url
fia::url_fia()
```

```
## [1] "http://apps.fs.fed.us/fiadb-downloads"
```

### Finding out what data is available

The FIA dataset is complex and composed of many different tables. To find out which tables are available in the FIA, use `list_available_tables`.


```r
# Retrieve table names from the web
tab = fia::list_available_tables()
```

```
## Trying to download tables from: "http://apps.fs.fed.us/fiadb-downloads"
```

```
## may take a while..."
```

```r
# Kinds of tables available.
print(tab)
```

```
## Available FIA data:
##                      objects                   size
##        reference_table_names               19 items
##             data_table_names               54 items
##                  data_states               54 items
##          url_downloaded_from                1 items
##             reference_tables   19 rows by 5 columns
##         data_tables_by_state 2970 rows by 7 columns
##  data_tables_states_combined   54 rows by 5 columns
```

There are two main types of tables:

+ **Reference:** Prefixed `REF`. They hold, as the name says, reference data such as species names (`REF_SPECIES`) and forest types (`REF_FOREST_TYPE`). You 'll find them in `reference_table_names`.

+ **Data:** These are tables with plot data (collected at the sites). For example, the individual tree data in `TREE` or geometry of each plot in `PLOTGEOM`. You'll find their names inside `data_table_names`. Note that these individual tables can be obtained:

    + At the **state level:** The state abbreviations are found inside `data_states`. A detailed list of state level datasets is given in `data_tables_by_state`
    
    + For **all states combined:** The detailed list of data combined for all states is given inside `data_tables_states_combined`. 



```r
# Check out the names of reference tables
head(tab$reference_table_names)
```

```
## [1] "BEGINEND"               "LICHEN_SPECIES_SUMMARY"
## [3] "REF_CITATION"           "REF_FIADB_VERSION"     
## [5] "REF_FOREST_TYPE"        "REF_FOREST_TYPE_GROUP"
```

```r
# or of plot level data tables and state names
head(tab$data_table_names)
```

```
## [1] "BOUNDARY"                "COND"                   
## [3] "COND_DWM_CALC"           "COUNTY"                 
## [5] "DWM_COARSE_WOODY_DEBRIS" "DWM_DUFF_LITTER_FUEL"
```

```r
head(tab$data_states)
```

```
## [1] "AL" "AK" "AZ" "AR" "CA" "CO"
```

```r
# You can also get a detailed desrciption of the data available in the FIA, e.g.
head(tab$reference_tables)
```

```
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
```


### Downloading FIA tables

Once you figured out what data you want to grab, all you have to do is download it:


```r
# Pick tables to download.
# Chosen from tab$reference_table_names and tab$data_table_names
my_table_names =  c("REF_SPECIES",  # a reference table
                    "PLOT")         # a plot data table

# Pick states of interest.
# See the pssibilities in tab$data_states.
my_states     = c("NC", "MN")

# Alternativelly, choose all states in the dataset.
# Thus will retrieve data in tab$data_tables_states_combined
my_states_2   = "ALL"

# You also must provide the directory where the files will be dumped in.
my_output_dir = "data_test/fia/"

# Start download!
#Wwill probably take a while...
fia::download_fia_tables(table_names           = my_table_names,
                         states                = my_states,      # could have been `my_states_2`
                         destination_dir       = my_output_dir,
                         list_available_tables = tab)            # the object returned by `list_available_tables()`
```

```
## Trying to download REF_SPECIES.zip... May take a very long time!
```

```
## Trying to download MN_PLOT.zip... May take a very long time!
```

```
## Trying to download NC_PLOT.zip... May take a very long time!
```
