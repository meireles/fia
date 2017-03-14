################################################################################
# Initialization
################################################################################

.onLoad = function(libname, pkgname) {
    op = options()

    op.fia = list(fia.base_url = "https://apps.fs.usda.gov/fia/datamart/CSV/datamart_csv.html")

    toset = !(names(op.fia) %in% names(op))

    if(any(toset)) {
        options(op.fia[toset])
    }

    invisible()
}

################################################################################
# Readme setup
################################################################################

file.copy("vignettes/introduction_to_fia.md", "README.md", overwrite = TRUE)

################################################################################
# Global-ish variable
################################################################################

#' FIA base url
#'
#' Returns the url for the FIA database
#'
#' @export
url_fia = function(){
    return(options()$fia.base_url)
}
