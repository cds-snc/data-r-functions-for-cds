#' On Load
#'
#' @param libname character string giving the library directory where the package defining the namespace was found.
#' @param pkgname character string giving the name of the package.
#'
#' @return TRUE if successful
#' @export
#'
#' @importFrom extrafont font_import loadfonts fonts
#'
.onLoad <- function(libname, pkgname) {

  if (!("Lato" %in% fonts())) {
    font_import(paths = "inst/font/Lato", prompt = FALSE)

  }

  suppressMessages(loadfonts())

  TRUE
}



