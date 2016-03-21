##################################################
#    Download FIA
##################################################

devtools::use_package("RCurl")

#' @title Download FIA tables.
#' @description Gets the Forest Inventory Scervice (FIA) data tables for each state
#' separatelly.
#' @details TODO
#' @param tables The names of the tables to be downloaded.
#' @param states TODO
#' @param destination_dir The directory where files will be saved to.
#' @param dir_by_sate Save tables from each state in a separate directory?
#' @param overwrite Should overwrite file if it already exists?
#' @return Nothing. This function is called for its side effect.
#' @export
download_fia = function(tables,
                        states,
                        destination_dir,
                        dir_by_sate = TRUE,
                        overwrite   = FALSE)
{

    source("R/utilities.R")

    create_dir_if_doesnt_exist(destination_dir)
    states = toupper(states)

    if(dir_by_sate){
        for(i in states)
            create_dir_if_doesnt_exist(file.path(destination_dir, i))
    }

    base_url       = "http://apps.fs.fed.us/fiadb-downloads"
    dir_files      = basename(dir(destination_dir, recursive = TRUE))
    files_mat      = expand.grid(state = states, table = tables, stringsAsFactors = FALSE)
    files_mat      = files_mat[order(files_mat$state), ]
    file_names     = apply(files_mat, 1, function(x){paste(x, sep = "", collapse = c("_"))})
    file_names     = toupper(paste(file_names, ".ZIP", sep = ""))
    files_mat      = cbind(files_mat, file_name = file_names)
    already_exist  = file_names %in% dir_files

    if(!overwrite)
        files_mat  = subset(files_mat, !already_exist)

    for(i in seq_along(files_mat$file_name)){
        u = file.path(base_url, files_mat$file_name[i])
        e = RCurl::url.exists(u)

        if(dir_by_sate)
            f = file.path(destination_dir, files_mat$state[i], files_mat$file_name[i])
        else
            f = file.path(destination_dir, files_mat$file_name[i])

        if(e){
            message("Trying to download ", files_mat$file_name[i], "... May take a very long time!\n")
            download.file(u, f)
        }
        else
            warning(files_mat$file_name[i], " could not be downloaded", call. = FALSE)
    }
}
