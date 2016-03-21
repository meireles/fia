################################################################################
#    Utility functions
################################################################################

#' @title Creates a new directory if it doesn't already exist
#' @param path The full path where the new directory should be created
#' @return Nothing. This functions is called for its side effect.
create_dir_if_doesnt_exist = function(path) {
    if(! file.exists(path) )
        dir.create(path)
}
