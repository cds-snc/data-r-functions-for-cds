% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/normalize-name.R
\name{normalize_name}
\alias{normalize_name}
\title{Normalize Name}
\usage{
normalize_name(x)
}
\arguments{
\item{x}{a character vector of organisation names}
}
\value{
a character vector of normalized names
}
\description{
Takes a vector of organisation names and normalizes them to be more friendly
for joins. The steps it takes, in order, are:
}
\details{
1. Convert the string to lower case
2. Remove all diacritics (i.e., convert to the Latin-ASCII charset)
3. Remove all trailing instances of "of Canada" or "du Canada"
4. Remove prepositions and articles (e.g., the, of, and, du, le, et, and, etc)
5. Replace non-critical punctuation with a space, as per the regex [/\(\)&',\"]
6. Normalize whitespace to remove double, leading or trailing whitespace
}
\examples{

normalize_name("Innovation, Science and Economic Development Canada")
# innovation science economic development

normalize_name("Bibliothèque et Archives Canada")
# bibliotheque archives

normalize_name("Femmes et Égalité des genres Canada")
# femmes egalite des genres

normalize_name("Canada Revenue Agency / Agence du revenu du Canada")
# canada revenue agency agence revenu

}
