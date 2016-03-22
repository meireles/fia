library("rmarkdown")

rmarkdown::render("vignettes/introduction_to_fia.Rmd",
                  output_format = "md_document",
                  output_file = "README.md",
                  output_dir = getwd() )