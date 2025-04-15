library(tidyverse)

# This script assumes you've already run scripts 01-04 to create the `orgs` table.

# This script creates a table to help resolve arbitrary identifiers into
# official "CDS-style" names. It creates a table with the following columns:
#  * identifier - the string identifying an organisation. This is what you're joining on
#  * resolves_to - the unique ID that identifies the organisation, as per the CDS repo `gc-organisations`
#  * source - where the identifier was first spotted
#  * name_en - the official English name for the organisation, as per the CDS repo `gc-organisations`
#  * name_fr - the official French name for the organisation, as per the CDS repo `gc-organisations`
#  * type - the class of organisation, one of :
#       Crown Corp - a Crown Corporation
#       GC Department - a department or agency of the Government of Canada
#       PTM - a provincial, territorial, or municipal government
#       Other - everything else

org_resolver <- left_join(orgs, org_names, by = c("resolves_to" = "id"))


usethis::use_data(org_resolver, overwrite = TRUE)

