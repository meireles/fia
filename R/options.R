################################################################################
#
################################################################################

.onLoad = function(libname, pkgname) {
    op = options()

    op.fia = list(
        fia.base_url = "http://apps.fs.fed.us/fiadb-downloads"
    )

    toset = !(names(op.fia) %in% names(op))

    if(any(toset)) {
        options(op.fia[toset])
    }
    invisible()
}


#' @title Returns FIA base url
#' @export
fia_base_url = function(){
    return(options()$fia.base_url)
}

