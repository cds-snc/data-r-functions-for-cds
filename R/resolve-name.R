#' Resolve a name to an official organisation name
#'
#' @param x a character vector of identifiers
#' @param lang language to return organisations in, one of 'en', 'fr', or 'id' (for CDS-specific unique department IDs)
#'
#' @return a character vector of official organisation names
#' @examples
#'
#' resolve_name("IRCC")
#' # "Immigration, Refugees and Citizenship Canada"
#'
#' resolve_name(c("NRCan", "ESDC"), lang = "fr")
#' # "Ressources naturelles Canada", "Emploi et Développement social Canada"
#'
#' resolve_name("Transport Canada / Transports Canada", lang = "id")
#' # "001I9000004Vt6JIAS"
#'
#' resolve_name("Department of Unicorns", lang = "en")
#' # NA with warning
#'
#' @export

resolve_name <- function(x, lang = "en", warn = TRUE) {

  nlang <- normalize_name(lang)
  org_resolver <- cds::org_resolver  # Resolve CMD check error

  input <- x
  x <- normalize_name(x)

  if (nlang %in% c("en", "english", "anglais")) {
    conversion_vector <- org_resolver$name_en
  } else if (nlang %in% c("fr", "french", "francais")) {
    conversion_vector <- org_resolver$name_fr
  } else if (nlang %in% c("id")) {
    conversion_vector <- org_resolver$resolves_to
  } else {
    stop("Unrecognized language: ", lang, "\n `lang` must be one of c('en', 'fr', 'id')")
  }

  names(conversion_vector) <- org_resolver$identifier

  o <- conversion_vector[x]
  names(o) <- input

  if (sum(is.na(o)) > 0 & warn) {
    warning(
      sum(is.na(o)),
      " names couldn't be matched:\n   \"",
      paste(input[is.na(o)], collapse = "\"\n   \""),
      "\""
      )
  }

  as.character(o)

}
