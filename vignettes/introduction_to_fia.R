## ----eval=FALSE----------------------------------------------------------
#  library("devtools")
#  devtools::install_github("meireles/fia")

## ------------------------------------------------------------------------
# Load the `fia` library
library("fia")

# Check out the packages' default FIA url
fia::url_fia()

## ------------------------------------------------------------------------
# Retrieve table names from the web
tab = fia::list_available_tables()

# Types of tables available.
print(tab)

## ------------------------------------------------------------------------
# Check out the names of reference tables
head(tab$reference_table_names)

# or names of states or plot level data tables
head(tab$data_states)
head(tab$data_table_names)

# You can also get a detailed desrciption of the data available in the FIA, e.g.
head(tab$reference_tables)

## ----eval=TRUE-----------------------------------------------------------
# Pick tables to download
# Chosen from tab$reference_table_names and tab$data_table_names
my_table_names = c("REF_SPECIES",  # a reference table
                   "PLOT")         # a plot data table

# Pick states of interest
# See the pssibilities in tab$data_states
my_states = c("NC", "MN")

# Alternativelly, choose all states in the dataset
# Thus will retrieve data in tab$data_tables_states_combined
my_states_2 = "ALL"

# You also must provide the directory where the files will be dumped in.
my_output_dir = "data_test/fia"

# Start download!
# Will probably take a while...
fia::download_fia_tables(table_names           = my_table_names,
                         states                = my_states,
                         destination_dir       = my_output_dir,
                         list_available_tables = tab, # returned by `list_available_tables()`
                         table_format          = "zip",
                         overwrite             = TRUE)

