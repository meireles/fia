################################################################################
#
################################################################################

#' Sets default options on load
.onLoad = function(libname, pkgname) {
    op = options()

    op.fia = list(fia.base_url = "http://apps.fs.fed.us/fiadb-downloads")

    toset = !(names(op.fia) %in% names(op))

    if(any(toset)) {
        options(op.fia[toset])
    }

    invisible()
}


#' FIA base url
#'
#' Returns the url for the FIA database
#'
#' @export
url_fia = function(){
    return(options()$fia.base_url)
}

