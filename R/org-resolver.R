#' Organisation resolver
#'
#' A list of identifiers that will help you resolve an organisation into
#' its formal CDS identifier
#'
#' @format ## `org_resolver`
#' A data frame with 789 rows and 6 columns:
#' \describe{
#'   \item{identifier}{string identifying an organisation. This is what you're joining on}
#'   \item{resolvers_to}{unique ID that identifies the organisation, as per the CDS repo `gc-organisations`}
#'   \item{source}{where the identifier was first spotted}
#'   \item{name_en}{official English name for the organisation, as per the CDS repo `gc-organisations`}
#'   \item{name_fr}{official French name for the organisation, as per the CDS repo `gc-organisations`}
#'   \item{type}{class of organisation, one of 'Crown Corp', 'GC Department', 'PTM' (provincial, territorial or municipal) or 'Other'}
#' }
#' @source <https://github.com/cds-snc/gc-organisations/>
"org_resolver"
