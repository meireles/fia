## ----eval=FALSE----------------------------------------------------------
#  library("devtools")
#  devtools::install_bitbucket("meireles/fia", quiet = TRUE)

## ------------------------------------------------------------------------
library("fia")

## ------------------------------------------------------------------------
fia::fia_base_url()

## ------------------------------------------------------------------------
tab = fia::list_available_tables() # returns a list with the tables and states available in the dataset.

## Just for kicks, check our the header of each object in the list
lapply(tab, head)

## ----eval=FALSE----------------------------------------------------------
#  
#  my_table_names =  c("REF_SPECIES", "PLOT") # Chosen from tab$reference_table_names and tab$data_table_names
#  
#  my_states     = c("NC", "MN") # Chosen from tab$data_states.
#  my_states_2   = "ALL"         # Or choose all states. Will get files in tab$data_tables_states_combined
#  my_output_dir = "~/somewhere/on/my/computer" # Where to save the downloaded files to?
#  
#  fia::download_fia_tables(table_names = my_table_names,
#                           states = my_states,
#                           destination_dir = my_output_dir,
#                           list_available_tables = tab)

