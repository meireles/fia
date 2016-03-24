## ----eval=FALSE----------------------------------------------------------
#  library("devtools")
#  devtools::install_bitbucket("meireles/fia", quiet = TRUE)

## ------------------------------------------------------------------------

# Load the `fia` library
library("fia")

# And check out the packages' default FIA url using
fia::url_fia()

## ------------------------------------------------------------------------
# Rentrieve table names from the web
tab = fia::list_available_tables()

# Kinds of tables available...
print(tab)

# So you can ckeck out the names of reference tables
head(tab$reference_table_names)

# Or plot level data tables and state names
head(tab$data_table_names)
head(tab$data_states)

# As well as many the raw-ish matrices with table file names, modicication dates, etc...
head(tab$reference_tables)

## ----eval=TRUE-----------------------------------------------------------
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

