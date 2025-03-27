library(tidyverse)
library(fuzzyjoin)

# There are lots of other sources of identifiers as well. Here, we pull in other
# "structured" identifiers (i.e., tables) are use them as a basis for more
# linking. We use the identifiers we've already calculated (from the `01` script)
# to do the easy linking, and do the harder linking manually.


# Names according to HR and Pay Systems -----------------------------------

orgs_pay_path <- "data-raw/organisation-resolution/data/orgs-pay.csv"

orgs_pay <- read_csv(
  orgs_pay_path,
  col_types = cols(
    cmt_code = col_character(),
    cmt_name = col_character(),
    phoenix_name = col_character(),
    official_en = col_character(),
    official_fr = col_character(),
  )
) %>%
  mutate(across(c(cmt_code, cmt_name, phoenix_name, official_en, official_fr), normalize_name))

# We use a fuzzy join to link the official names of an organization (determined
# 01_get_identifiers-CDS.R) and match those up with the official EN name

orgs_en <- filter(orgs, source == "CDS Names/EN")
orgs_fr <- filter(orgs, source == "CDS Names/FR")


# Match to the official English names
orgs_en_long <- stringdist_inner_join(
  orgs_pay,
  orgs_en,
  by = c("official_en" = "identifier"),
  method = "osa",
  max_dist = 2
) %>%
  select(cmt_code, cmt_name, phoenix_name, official_en, official_fr, identifier, resolves_to) %>%
  pivot_longer(cols = c(everything(), -resolves_to), values_to = "identifier") %>%
  rename(source = name)

# Match to the official French names
orgs_fr_long <- stringdist_inner_join(
  orgs_pay,
  orgs_fr,
  by = c("official_fr" = "identifier"),
  method = "osa",
  max_dist = 2
) %>%
  select(cmt_code, cmt_name, phoenix_name, official_en, official_fr, identifier, resolves_to) %>%
  pivot_longer(cols = c(everything(), -resolves_to), values_to = "identifier") %>%
  rename(source = name)


# Which ones haven't we matched yet?
havent_matched <- setdiff(orgs_pay$official_en, c(orgs_en_long$identifier, orgs_fr_long$identifier))

# Match the remaining rows manually - if they're not in the official CDS
# dataset, we use the "Department not listed" value
missing_identifier <- "001I9000005Ho3zIAC" # "Department not listed"


leftovers <- tribble(
  ~identifier, ~resolves_to,
  "Auditor General of Canada (Office of the)", "001I900000503zhIAA",
  "Law Commission of Canada", missing_identifier,
  "Canada Industrial Relations Board", missing_identifier,
  "Office of the Senate Ethics Officer", missing_identifier,
  "Conflict of Interest and Ethics Commissioner (Office of the)", missing_identifier,
  "Telefilm Canada", missing_identifier,
  "Finance Canada (Department of)", "001I9000004Vt5lIAC",
  "Commissioner for Federal Judicial Affairs Canada (Office of the)", missing_identifier,
  "Farm Products Council of Canada", missing_identifier,
  "Office of the Governor General's Secretary", missing_identifier,
  "Reg Specific Claims Tribunal", missing_identifier,
  "House of Commons", missing_identifier,
  "Canadian International Development Agency", missing_identifier,
  "International Joint Commission", missing_identifier,
  "Public Sector Integrity Commissioner of Canada (Office of the)", "001OO00000HzMoJYAV",
  "Indian Oil and Gas Canada", missing_identifier,
  "Information Commissioner (Office of the)",  missing_identifier,
  "Truth and Reconciliation Commission of Canada",  missing_identifier,
  "Justice Canada (Department of)", "001I9000004Vt5mIAC",
  "The Leaders' Debates Commission",  missing_identifier,
  "Library of Parliament",  missing_identifier,
  "House of Commons (Members)",  missing_identifier,
  "Northern Pipeline Agency",  missing_identifier,
  "National Security Intelligence Review Agency",  missing_identifier,
  "Natural Sciences and Engineering Research Canada",  "001I9000004Vt64IAC",
  "National Security and Intelligence Committee of Parliamentarians", "001OO00000GgHJNYA3",
  "Office of the Correctional Investigator",  missing_identifier,
  "Public Safety", "001I9000004Vt6CIAS",
  "Canadian Polar Commission", "001I9000005X2mZIAS",
  "Parliamentary Protective Service",  missing_identifier,
  "Public Servants Disclosure Protection Tribunal",  missing_identifier,
  "Canadian Human Rights Tribunal", "001I9000004Vt5eIAC",
  "Registry of the Competition Tribunal",  missing_identifier,
  "RCMP External Review Committee",  missing_identifier,
  "Federal Public Sector Labour Relations and Employment Board",  missing_identifier,
  "Senate of Canada",  missing_identifier,
  "Superintendent of Financial Institutions Canada (Office of the)",  missing_identifier,
  "Security Intelligence Review Committee",  missing_identifier,
  "Communications Security Establishment Commissioner (Office of the)", "001OO00000GgH3GYAV",
  "Supreme Court of Canada",  missing_identifier,
  "Statistical Survey Operations",  missing_identifier,
  "Transportation Appeal Tribunal of Canada",  missing_identifier,
  "Public Service Staffing Tribunal",  missing_identifier,
  "Western Economic Diversification Canada", missing_identifier
)

leftovers$identifier <- normalize_name(leftovers$identifier)

orgs_leftovers_long <- leftovers %>%
  left_join(orgs_pay, by = c("identifier" = "official_en")) %>%
  select(cmt_code, cmt_name, phoenix_name, identifier, official_fr, identifier, resolves_to) %>%
  pivot_longer(cols = c(everything(), -resolves_to), values_to = "identifier") %>%
  rename(source = name)
# Combine the three tables (EN matches, FR matches, and manual matches) and then
# only keep unique values for identifiers

orgs <- bind_rows(
  orgs,
  orgs_fr_long,
  orgs_en_long,
  orgs_leftovers_long
) %>%
  mutate(source = case_when(
    source == "cmt_code" ~ "Pay Names/CMT",
    source == "official_en" ~ "Pay Names/Official/EN",
    source == "official_fr" ~ "Pay Names/Official/FR",
    source == "identifier" ~ "Pay Names/Official/EN",
    source == "cmt_name" ~ "Pay Names/CMT",
    source == "phoenix_name" ~ "Pay Names/Phoenix",
    TRUE ~ source
  )) %>%
  distinct(identifier, .keep_all = TRUE)
