# Occasionally, we run into a name that isn't able to be matched automatically.
# These are typically things like:
# * Non-standard acronyms (e.g., NRCan for Natural Resources Canada)
# * Common misspellings that are too distant for fuzzy matching
# * True mysteries where it just needs to work (e.g., 'treasy' for TBS??)

# In this script, we pull in a CSV of manual matches we want to make

# TO ADD TO THE CSV
# 1. Open the file `data-raw/organisation-resolution/data/manual-matches.csv` in the package directory
# 2. Add additional rows at the bottom.
#   - The first column `identifier` is what you want to match - it is normalized, so it is NOT case sensitive
#   - The second column `resolves_to` is a unique identifier from the `cds-snc/gc-organisations` repository
#     - Use "001I9000005Ho3zIAC" for departments not listed in the gc-organisations repo
#   - The third column `source` is where you first found this acronym
# 3. Run the script `data-raw/organisation-resolution/00_run-all.R` script to create the final table


# FOR EXAMPLE:
# Consider the top line of the CSV:
# "identifier","resolves_to","source"
# "AAFC","001I9000004pwojIAA","Airtable/GC Forms"


# This identifier was first observed in an Airtable published by GC Forms
# The line indications that the abbreviation "AAFC" matches the organisation ID "001I9000004pwojIAA"
# Looking this ID up in the `cds-snc/gc-organisations` repo shows that this ID means "Agriculture and Agri Food Canada"

manual_matches <- read_csv(
  "data-raw/organisation-resolution/data/manual-matches.csv",
  col_names = TRUE,
  cols(
    identifier = col_character(),
    resolves_to = col_character(),
    source = col_character()
  )) %>%
  mutate(identifier = normalize_name(identifier)) %>%
  replace_na(list(identifier = "001I9000005Ho3zIAC"))  # Replace missing identifiers with "Department not listed"

orgs <- bind_rows(orgs, manual_matches) %>%
  distinct(identifier, .keep_all = TRUE)

