################################################################################
#
################################################################################

devtools::use_package("RCurl")
devtools::use_package("XML")


########################################
# Find which FIA tables are available online
########################################

.get_available_tables = function(url) {
    ref_table          = "AutoNumber2"               ## html name of reference table
    dat_states_table   = "AutoNumber3"               ## html name of state data table
    dat_combined_table = "AutoNumber4"               ## html name of all states combined data table

    url_exists  = RCurl::url.exists(url)

    if(url_exists){
        message("Trying to download tables from: \"", url, "\"")
        message("may take a while...", "\"")
        raw_tables = XML::readHTMLTable(url, trim = TRUE, as.data.frame = TRUE)
    } else {
        warning(url, "does not exist.", call. = FALSE)
    }

    raw_tables = list(reference_tables       = raw_tables[[ref_table]],
                      tables_by_state        = raw_tables[[dat_states_table]],
                      tables_states_combined = raw_tables[[dat_combined_table]],
                      url_downloaded_from    = url)

    return(raw_tables)
}


########################################
# Clean up available tables
########################################

.clean_raw_tables = function(raw_tables) {

    colname_lookup = c(zip_tables    = "ZIP Files",
                       csv_tables    = "CSV Files",
                       n_records     = "Number of Records",
                       last_created  = "Last Created Date",
                       last_modified = "Last Modified Date")

    select_to_clean = c("reference_tables", "tables_by_state","tables_states_combined")

    cleanup_tables = function(x){

        # Rename columns
        colnames(x) = names(colname_lookup)

        # Change "" and "N/A" to NA
        x[x == ""]    = NA
        x[x == "N/A"] = NA

        # Remove NA only columns
        x = x[ apply(x, 1, function(y){ !all(is.na(y)) }) , ]

        # In reference_tables, remove extra row
        x = x[ x[ , "zip_tables"] != "All of the reference files zipped together", ]

        # Rename rows
        rownames(x) = seq(nrow(x))

        # Appropriate classes for columns
        x[["zip_tables"]]    = as.character(x[["zip_tables"]])
        x[["csv_tables"]]    = as.character(x[["csv_tables"]])
        x[["n_records"]]     = as.numeric(as.character(x[["n_records"]]))
        x[["last_created"]]  = as.character(x[["last_created"]])
        x[["last_modified"]] = as.character(x[["last_modified"]])

        return(x)
    }

    # Clean up tables
    raw_tables[select_to_clean] = lapply(raw_tables[select_to_clean], cleanup_tables)

    return(raw_tables)
}


########################################
# Reshape available tables
########################################

.reshape_clean_tables = function(clean_tables) {

    x = clean_tables$tables_by_state

    ########################################
    ## Which rows are state names?
    ########################################

    s1 = grepl(" ", x[["zip_tables"]], fixed = TRUE) ## they have a space in their name
    s2 = is.na(x[["csv_tables"]])                    ## are NA for "csv_tables"

    s3 = apply(is.na(x[ , c("n_records", "last_created", "last_modified")]), ## n_records and dates are NA
               1, all)

    s  = which(s1 & s2 & s3)

    ########################################
    ## Make a column of state names
    ########################################

    w  = c(s, nrow(x) + 1)
    z  = diff(w)
    n  = rep(x[["zip_tables"]][s], z)
    n1 = gsub(".zip", "", n)

    n2 = do.call(rbind, strsplit(n1, ' (?=[^ ]+$)', perl = TRUE))
    colnames(n2) = c("state_name", "state_abbreviation")

    ########################################
    x = cbind(n2, x)

    x[["zip_tables"]][s]      = paste(x[["state_abbreviation"]][s], ".zip", sep = "")
    x[["state_name"]]         = as.character(x[["state_name"]])
    x[["state_abbreviation"]] = as.character(x[["state_abbreviation"]])

    rownames(x) = seq(nrow(x))

    ########################################

    table_names = substring(gsub(".zip", "", x[["zip_tables"]][- s]), 4)

    ########################################
    out = list()

    out$reference_table_names       = gsub(".zip", "", clean_tables[["reference_tables"]][["zip_tables"]])
    out$data_table_names            = unique(table_names)
    out$data_states                 = unique(x[["state_abbreviation"]])
    out$url_downloaded_from         = clean_tables[["url_downloaded_from"]]
    out$reference_tables            = clean_tables[["reference_tables"]]
    out$data_tables_by_state        = x
    out$data_tables_states_combined = clean_tables[["tables_states_combined"]]

    class(out) = "list_available_tables"

    return(out)
}


#' @title List available tables in the FIA dataset
#' @description Lists the available data tables from FIA.
#' @details TODO
#' @param url The base url for the FIA database. It defaults to the url returned by `fia::fia_base_url()`
#' @return TODO
#' @export
list_available_tables = function(url = fia::url_fia()) {
    tables = .get_available_tables(url = url)
    tables = .clean_raw_tables(raw_tables = tables)
    tables = .reshape_clean_tables(clean_tables = tables)
    return(tables)
}

