# Introduction to fia
Jose Eduardo Meireles  
`r Sys.Date()`  

## Installation
 
The easiest way to get the `fia` package is to install from the bitbuket repository.


```r
library("devtools")

devtools::install_bitbucket("meireles/fia", quiet = TRUE)
```

## Usage

For now, the main goal of the `fia` package is to programatically download FIA data, which lives lives in the FIADB webpage. Use `url_fia()` to see the default FIA url if you're curious.


```r
# Load the `fia` library
library("fia")

# And check out the packages' default FIA url using
fia::url_fia()
```

```
## [1] "http://apps.fs.fed.us/fiadb-downloads"
```

### Finding out what data is available

The FIA dataset is complex and composed of many different tables. There are two main types of tables:

- Reference: These tables are prefixed `REF_`. They hold. as the name says, reference data such as species names (`REF_SPECIES`) and forest types (`REF_FOREST_TYPE`).

- Data: These are tables with plot data (collected at the sites). For example, the individual tree data in `TREE` or geometry of each plot in `PLOTGEOM`. Individual tables can be obtained at the state level or for all states together.

To find out what tables are available in the FIA, use `list_available_tables`. 


```r
# Rentrieve table names from the web
tab = fia::list_available_tables()
```

```
## Trying to download tables from: "http://apps.fs.fed.us/fiadb-downloads"
```

```
## may take a while..."
```

```r
# Kinds of tables available...
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

```r
# So you can ckeck out the names of reference tables
head(tab$reference_table_names)
```

```
## [1] "BEGINEND"               "LICHEN_SPECIES_SUMMARY"
## [3] "REF_CITATION"           "REF_FIADB_VERSION"     
## [5] "REF_FOREST_TYPE"        "REF_FOREST_TYPE_GROUP"
```

```r
# Or plot level data tables and state names
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
# As well as many the raw-ish matrices with table file names, modicication dates, etc...
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

Once you figured what data you want to grab, all you have to do is download it:


```r
# Pick tables to download. Chosen in this case from tab$reference_table_names and tab$data_table_names
my_table_names =  c("REF_SPECIES",  # a reference table
                    "PLOT")         # a plot data table

# Then choose the states you're interest in. See the pssibilities in tab$data_states.
my_states     = c("NC", "MN")

# Alternativelly, choose all states in the dataset. Will retrieve data in tab$data_tables_states_combined
my_states_2   = "ALL"

# You also must provide a directory where all the files will be dumped in.
my_output_dir = "data_test/fia/"

# Start download, will probably take a while...
fia::download_fia_tables(table_names           = my_table_names,
                         states                = my_states,
                         destination_dir       = my_output_dir,
                         list_available_tables = tab)           # the object returned by fia::list_available_tables()
```

```
## Warning in dir.create(destination_dir, recursive = TRUE): 'data_test/fia'
## already exists
```

```
## Warning in dir.create(file.path(destination_dir, i)): 'data_test/fia//MN'
## already exists
```

```
## Warning in dir.create(file.path(destination_dir, i)): 'data_test/fia//NC'
## already exists
```
