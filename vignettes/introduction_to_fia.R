## ----eval=FALSE----------------------------------------------------------
#  library("devtools")
#  devtools::install_bitbucket("meireles/fia", quiet = TRUE)

## ------------------------------------------------------------------------
library("fia")

## ------------------------------------------------------------------------
fia::url_fia()

## ------------------------------------------------------------------------
tab = fia::list_available_tables() # returns a list with the tables and states available in the dataset.

## Just for kicks, check our the header of each object in the list
lapply(tab, head)

## ----eval=TRUE-----------------------------------------------------------

# Pick tables to download. Chosen from tab$reference_table_names and tab$data_table_names
my_table_names =  c("REF_SPECIES",  # a reference table
                    "PLOT")         # a plot data table

# Then choose the states you're interest in. See the pssibilities in tab$data_states.
my_states     = c("NC", "MN")

# Alternativelly, choose all states in the dataset. Will retrieve data in tab$data_tables_states_combined
my_states_2   = "ALL"

# You also must provide a directory where all the files will be dumped in.
my_output_dir = "data_test/fia/"

fia::download_fia_tables(table_names           = my_table_names,
                         states                = my_states,
                         destination_dir       = my_output_dir,
                         list_available_tables = tab)           # the object returned by fia::list_available_tables()

