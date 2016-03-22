########################################
#    Download FIA
########################################


devtools::use_package("RCurl")


########################################
# Make filenames for download
########################################

.make_filename_fia_tables = function(table_names,
                                     states_abreviation,
                                     list_available_tables) {

    # Is `list_available_tables` of the right class?
    if(class(list_available_tables) != "list_available_tables") {
        stop("list_available_tables must be the output of fia::list_available_tables()")
    }

    ####################################
    # table_names
    ####################################
    table_names = toupper(table_names)

    # Match table names to available files
    table_names_matched = table_names %in% unlist(list_available_tables[c("reference_table_names", "data_table_names")])


    if(all(!table_names_matched)) {
        stop("None of `table_names` match available files.")
    }

    if(any(!table_names_matched)){
        warning(table_names[!table_names_matched], "not matched!")
        table_names = table_names[table_names_matched]
    }

    table_names = list(
        ref = table_names[table_names %in% list_available_tables[["reference_table_names"]] ],
        dat = table_names[table_names %in% list_available_tables[["data_table_names"]] ]
    )

    ####################################
    # states_abreviation
    ####################################

    # Match state names
    states_abreviation = toupper(states_abreviation)
    get_states_comb    = FALSE

    state_names_matched = states_abreviation %in% list_available_tables[["data_states"]]


    if(all(!state_names_matched)){         # No state match at all!
        if(states_abreviation == "ALL"){   # Because the user wants `ALL` states
            get_states_comb = TRUE
        } else {                           # Or because the user really messed up
            stop("None of the `states_abreviation` entries are valid")
        }
    } else {                               # State matched
        if(sum(state_names_matched) == length(list_available_tables[["data_states"]])) { # Completely...
            get_states_comb    = TRUE
            states_abreviation = "ALL"
        } else {                           # Or partially
            states_abreviation = states_abreviation[state_names_matched]
            if(any(!state_names_matched)){
                warning(states_abreviation[!state_names_matched], "is not a valid state.")
            }
        }
    }

    ####################################
    # Make names
    ####################################

    # Ref
    files_ref = paste(table_names[["ref"]], ".zip", sep = "")

    # Dat
    if(get_states_comb){
        files_dat = paste(table_names[["dat"]], ".zip", sep = "")
    } else {
        files_mat = expand.grid(states_abreviation, table_names[["dat"]], stringsAsFactors = FALSE)
        colnames(files_mat) = c("state", "file_name")

        files_dat = apply(files_mat, 1, function(x){paste(x, sep = "", collapse = c("_"))})
        files_dat = paste(files_dat, ".zip", sep = "")
        files_mat[ , "file_name"] = files_dat
    }

    files_mat = files_mat[ order(files_mat[ , "state"]), ]

    out = list(file_names_ref = files_ref,
               file_names_dat = files_mat)

    return(out)
}


################################################################################

#' Downloads fia tables to dir
#'
#' @param table_names Choose which tables to download
#' @param states Download data for which states. If "all", `data_tables_states_combined` will be downloaded
#' @param destination_dir Path to directory where the data .zip files will be saved.
#' @param list_available_tables Object returned from `fia::list_available_tables`
#' @param dir_by_sate Save data for each state in a separate directory? Only works if states != `all` and for non-reference tables.
#' @param overwrite Should datasets be overwritten?
#'
#' @return Nothing. Side effect of saving files to a directory
#' @export
download_fia_tables = function(table_names,
                               states,
                               destination_dir,
                               list_available_tables,
                               dir_by_sate = TRUE,
                               overwrite   = FALSE) {

    file_names = .make_filename_fia_tables(table_names, states, list_available_tables)
    states     = unique(file_names$file_names_dat$state)

    dir.create(destination_dir, recursive = TRUE)


    if(dir_by_sate) {
        for(i in states)
            dir.create(file.path(destination_dir, i))
    }

    dir_files       = basename(dir(destination_dir, recursive = TRUE))
    already_exist_r = file_names$file_names_ref %in% dir_files
    already_exist_d = file_names$file_names_dat$file_name %in% dir_files

    if(!overwrite){
        file_names$file_names_ref           = file_names$file_names_ref[!already_exist_r]
        file_names$file_names_dat$file_name = file_names$file_names_dat$file_name[!already_exist_d]
    }


    # Ref
    for(i in seq_along(file_names$file_names_ref)){
        u = file.path(list_available_tables$url_downloaded_from, file_names$file_names_ref[i])
        e = RCurl::url.exists(u)
        f = file.path(destination_dir, file_names$file_names_ref[i])

        if(e){
            message("Trying to download ", file_names$file_names_ref[i], "... May take a very long time!\n")
            download.file(u, f)
        }
        else
            warning(file_names$file_names_ref[i], " could not be downloaded", call. = FALSE)
    }

    # Dat
    for(i in seq_along(file_names$file_names_dat)){
        u = file.path(list_available_tables$url_downloaded_from, file_names$file_names_dat$file_name[i])
        e = RCurl::url.exists(u)

        if(dir_by_sate)
            f = file.path(destination_dir, file_names$file_names_dat$state[i], file_names$file_names_dat$file_name[i])
        else
            f = file.path(destination_dir, file_names$file_names_dat$file_name[i])

        if(e){
            message("Trying to download ", file_names$file_names_dat$file_name[i], "... May take a very long time!\n")
            download.file(u, f)
        }
        else
            warning(file_names$file_names_dat$file_name[i], " could not be downloaded", call. = FALSE)
    }

}


