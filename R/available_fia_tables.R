################################################################################
#
################################################################################

devtools::use_package("RCurl")
devtools::use_package("XML")


########################################
# Find which FIA tables are available
########################################

#' @title TODO
#' @description TODO
#' @details TODO
#' @param TODO
#' @return TODO
.get_available_fia_tables = function(url){

    ref_table = "AutoNumber2" # html name of reference table
    dat_table = "AutoNumber3" # html name of state data table

    url_exists  = RCurl::url.exists(url)

    if(url_exists){
        message("Trying to download tables from: \"", url, "\"")
        raw_tables = XML::readHTMLTable(url, trim = TRUE, as.data.frame = TRUE)
    } else {
        warning(url, "does not exist.", call. = FALSE)
    }

    tables = list(reference   = raw_tables[[ref_table]],
                  data_tables = raw_tables[[dat_table]])
    return(tables)
}


########################################
# Clean up available tables
########################################


#' @title TODO
#' @description TODO
#' @details TODO
#' @param TODO
#' @return TODO
.clean_available_fia_tables = function(tables) {

    col_remove     = "CSV Files"
    colname_lookup = c(table_name    = "ZIP Files",
                       n_records     = "Number of Records",
                       last_created  = "Last Created Date",
                       last_modified = "Last Modified Date")

    out = lapply(tables, function(x){

        x = x[ , colnames(x) != col_remove]
        colnames(x) = names(colname_lookup)
        x[["table_name"]] = gsub(".zip", "", as.character(x[["table_name"]]))
        x[x == ""] = NA
        x[x == "N/A"] = NA
        x = x[apply(x, 1, function(y){ !all(is.na(y)) }) , ]
        rownames(x) = seq(nrow(x))
        return(x)
    })
    return(out)
}



########################################
# Reshape available tables
########################################


#' @title TODO
#' @description TODO
#' @details TODO
#' @param TODO
#' @return TODO
.reshape_available_fia_tables = function(tables_list) {

    x = tables_list$data_tables

    ## Which rows are state names?
    s1 = grepl(" ", x[["table_name"]], fixed = TRUE) ## they have a space in their name
    s2 = apply( is.na(x[ , c("n_records", "last_created", "last_modified")]), ## and everything else is NA
                1, all)
    s  = which(s1 & s2)

    ## Make a column of state names
    w  = c(s, nrow(x) + 1)
    z  = diff(w)
    n  = rep(x$table_name[s], z)
    n1 = do.call(rbind, strsplit(n, ' (?=[^ ]+$)', perl=TRUE))
    colnames(n1) = c("state_name", "state_abbreviation")

    x = cbind(n1, x)
    x[["table_name"]] = substring(x[["table_name"]], 4)

    ## Remove state only rows
    x  = x[ -s, ]
    rownames(x) = seq(nrow(x))

    b = list()

    b$reference_tables = tables_list$reference
    b$states           = as.character(unique(x$state_abbreviation))
    b$tables           = as.character(unique(x$table_name))
    b$raw_data_tables  = x
    return(b)
}



########################################
#
########################################

#' @title TODO
#' @description TODO
#' @details TODO
#' @param TODO
#' @return TODO
#' @export
available_fia_tables = function(url = "http://apps.fs.fed.us/fiadb-downloads") {
    tables = .get_available_fia_tables(url = url)
    tables = .clean_available_fia_tables(tables)
    tables = .reshape_available_fia_tables(tables)
    return(tables)
}




