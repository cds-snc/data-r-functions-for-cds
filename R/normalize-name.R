#' Normalize Name
#'
#' Takes a vector of organisation names and normalizes them to be more friendly
#' for joins. The steps it takes, in order, are:
#'
#' 1. Convert the string to lower case
#' 2. Remove all diacritics (i.e., convert to the Latin-ASCII charset)
#' 3. Remove all trailing instances of "of Canada" or "du Canada"
#' 4. Remove prepositions and articles (e.g., the, of, and, du, le, et, and, etc)
#' 5. Replace non-critical punctuation with a space, as per the regex [/\(\)&',\"]
#' 6. Normalize whitespace to remove double, leading or trailing whitespace
#'
#' @param x a character vector of organisation names
#'
#' @importFrom stringi stri_trans_general
#' @importFrom stringr str_remove_all str_replace_all str_squish
#'
#' @return a character vector of normalized names
#'
#' @examples
#'
#' normalize_name("Innovation, Science and Economic Development Canada")
#' # innovation science economic development
#'
#' normalize_name("Bibliothèque et Archives Canada")
#' # bibliotheque archives
#'
#' normalize_name("Femmes et Égalité des genres Canada")
#' # femmes egalite des genres
#'
#' normalize_name("Canada Revenue Agency / Agence du revenu du Canada")
#' # canada revenue agency agence revenu
#'
#' @export

normalize_name <- function(x) {

  o <- x
  o <- tolower(o)    # Convert to lower case
  o <- stringi::stri_trans_general(o, "Latin-ASCII")     # Remove diacritics
  o <- str_replace_all(o, "(of canada)|(au canada)|(du canada)|( canada )|( canada$)", " ")    # Remove trailing Canadas - this is greedy so the simplest must be at the end
  o <- str_remove_all(o, "(office of the)|(bureau du)|(bureau de la)|(bureau d')")  # Remove 'office of the', etc
  o <- str_remove_all(o, "( of canada$)|( au canada$)|( du canada$)|( canada$)")    # Do this step twice because removing (office of the) will reveal additional trailing Canadas

  prepositions <- c(" the ", " of ", " and ",
                    " du ", " de ", " d'", " des ",
                    " le ", " la ", " les ", " l'",
                    " et ", " aux ", " au ", " a ")

  prepositions <-  paste0("(", paste0(prepositions, collapse = ")|("), ")")  # Make our regex on the fly

  o <- str_replace_all(o, prepositions, " ")         # Remove prepositions/articles
  o <- str_replace_all(o, prepositions, " ")         # Take two passes to get combinations of prepositions/articles
  o <- str_replace_all(o, "[/\\(\\)&',\":]", " ")    # Replace punctuation with a space
  o <- str_squish(o)                                 # Remove unnecessary whitespace

  o
}

