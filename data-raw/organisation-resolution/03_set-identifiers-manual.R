library(tidyverse)

# Occasionally, we run into a name that isn't able to be matched automatically.
# These are typically things like:
# * Non-standard acronyms (e.g., NRCan for Natural Resources Canada)
# * Common misspellings that are too distant for fuzzy matching
# * True mysteries where it just needs to work (e.g., 'treasy' for TBS??)

# In this script, we just manually set them, without much worry about whether
# it will be reproducible.


missing_identifier <- "001I9000005Ho3zIAC" # "Department not listed"

# GC Forms ----------------------------------------------------------------

# From GC Forms Demos table
leftovers_gcforms_demos <- tribble(
  ~ identifier, ~ resolves_to,
  "AAFC", "001I9000004pwojIAA",
  "CATSA", "001I90000050b2KIAQ",
  "CBSA", "001I9000004Vt5XIAS",
  "CIPO", "001I90000050aK9IAI",
  "CRA", "001I9000004Vt5ZIAS",
  "CRTC", "001I9000004Vt5hIAC",
  "ECCC", "001I9000004Vt5pIAC",
  "ESDC", "001I9000004Vt5oIAC",
  "FCAC", "001I900000503tyIAA",
  "GAC", "001I9000004Vt5tIAC",
  "HC", "001I9000004Vt5uIAC",
  "IRCC", "001I9000004Vt5wIAC",
  "ISC", "001I9000005HqRoIAK",
  "ISED", "001I9000004Vt5zIAC",
  "LAC", "001I9000004Vt60IAC",
  "NRCan", "001I9000004Vt63IAC",
  "OSB", missing_identifier,
  "PBC", "001I900000504ZTIAY",
  "PC", "001I9000004Vt69IAC",
  "PHAC", "001I9000004Vt6AIAS",
  "PS", "001I9000004Vt6CIAS",
  "PSPC", "001I9000004Vt6EIAS",
  "RCMP", "001I9000004Vt6GIAS",
  "StatCan", "001I9000004Vt6IIAS",
  "TBS", "001I9000004Vt6KIAS",
  "TC", "001I9000004Vt6JIAS",
  "VAC", "001I9000004Vt6LIAS"
) %>%
  mutate(
    source = "Airtable/GC Forms",
    identifier = normalize_name(identifier)
  )


# From the organisations assigned as owners of certain Forms
leftovers_gcforms_forms <- tribble(
  ~ identifier, ~ resolves_to,
  "Canadian Digital Service / Service numérique canadien", "001I9000004Vt5oIAC",
  "Copyright Board Canada / Commission du droit d'auteur Canada", "001I900000503tPIAQ",
  "National Defence / Défense nationale", "001I9000004Vt61IAC",
  "Veterans Affairs Canada / Anciens Combattants Canada", "001I9000004Vt6LIAS",
  "Superintendent of Financial Institutions Canada (Office of the) / Bureau du surintendant des institutions financières Canada", "001I9000005DXSKIA4",
  "Refugees and Citizenship Canada / Immigration", "001I9000004Vt5wIAC",
  "Science and Economic Development Canada / Innovation", "001I9000004Vt5zIAC",
  "Innovation, Science and Economic Development Canada", "001I9000004Vt5zIAC",
  "Innovation, Science, and Economic Development Canada", "001I9000004Vt5zIAC",
  '"Innovation, Science and Economic Development Canada"', "001I9000004Vt5zIAC",
  '"Innovation, Science, and Economic Development Canada"', "001I9000004Vt5zIAC",
  "National Battlefields Commission / Commission des champs de bataille nationaux", "001I9000005X2DjIAK",
  "Health Canada / Santé Canada,Public Health Agency of Canada / Agence de la santé publique du Canada", "001I9000004Vt5uIAC",
  "Office of the Federal Ombudsperson for Victims of Crime", missing_identifier,
  "Taxpayers' Ombudsperson (Office of the) / Bureau de l'ombudsman des contribuables", "001OO00000Ct4gqYAB",
  "treasy", "001I9000004Vt6KIAS",
  "Canadian Forces Morale and Welfare Services", missing_identifier,
  "Competition Bureau Canada", missing_identifier,
  "Canada Border Services Agency / Agence des services frontaliers du Canada,Treasury Board of Canada Secretariat / Secrétariat du Conseil du Trésor du Canada", "001I9000004Vt5XIAS",
) %>%
  mutate(
    source = "Airtable/GC Forms",
    identifier = normalize_name(identifier)
  )

orgs <- bind_rows(orgs, leftovers_gcforms_demos, leftovers_gcforms_forms)


# GC Design System --------------------------------------------------------

# From GCDS's CRM
leftovers_gcds <- tribble(
  ~ identifier, ~ resolves_to,
  "Ship-source Oil Pollution Fund", missing_identifier,
  "City of Vancouver", missing_identifier,
  "\"Innovation, Science and Economic Development Canada\"", "001I9000004Vt5zIAC",
  "\"Immigration, Refugees and Citizenship Canada\"", "001I9000004Vt5wIAC",
  "External to government", missing_identifier,
  "Windsor-Detroit Bridge Authority,External to government", missing_identifier,
  "Taxpayers' Ombudsperson (Office of the)", "001OO00000Ct4gqYAB",
  "Canadian Digital Service,Employment and Social Development Canada", "001I9000004Vt5oIAC",
  "Canada Revenue Agency,External to government", "001I9000004Vt5ZIAS",
  "Employment and Social Development Canada,Canadian Digital Service", "001I9000004Vt5oIAC",
  "External to government", missing_identifier,
  "Canadian Digital Service", "001I9000004Vt5oIAC"
) %>%
  mutate(
    source = "Airtable/GC Design System",
    identifier = normalize_name(identifier)
  )

orgs <- bind_rows(orgs, leftovers_gcds)


# Enterprise --------------------------------------------------------------

leftovers_enterprise <- tribble(
  ~ identifier, ~ resolves_to,
  "CAS", "001I9000004Vt5kIAC",
  "ACOA", "001I9000004Vt5WIAS",
  "CAF", "001I9000004Vt61IAC",
  "CCCS", "001I9000004zLveIAE", # Cyber Security
  "CCOHS", "001I900000503ncIAA",
  "CEDQ", "001I9000004Vt5YIAS",
  "CER", "001I9000005tFjAIAU",
  "CFIA", "001I9000004Vt5bIAC",
  "CHRC", "001I9000004Vt5eIAC",
  "CICS", "001OO00000IclDKYAZ",
  "CIHR", "001I900000503mHIAQ",
  "CIRNAC", "001I9000004Vt5xIAC",
  "CJC", missing_identifier,
  "Competition Tribunal", missing_identifier,
  "Copyright Board", "001I900000503tPIAQ",
  "CSC, PBC", "001I900000503m9IAA",
  "CSPS", "001I9000004Vt5aIAC",
  "EDC", "001I900000503nDIAQ",
  "EI BOA", missing_identifier,
  "FBCL", "001I9000004Vt6JIAS",
  "FCAS", "001I900000503tyIAA",
  "Federal Court", missing_identifier,
  "Federal Court of Appeal", missing_identifier,
  "FINTRAC", "001I9000004Vt5rIAC",
  "FPSLREB", missing_identifier,
  "IAAC", "001I9000005DbFCIA0",
  "IDRC", missing_identifier,
  "IOGC", missing_identifier,
  "Justice", "001I9000004Vt5mIAC",
  "NCC Ombudsman", "001I9000004Vt5mIAC",
  "NSERC", "001I9000004Vt64IAC",
  "Office of the Commissioner of Lobbying", "001I9000004Vt65IAC",
  "Office of the Public Sector Integrity Commissioner", "001OO00000HzMoJYAV",
  "OPC", "001I900000504b0IAA",
  "OSFI", "001I9000005DXSKIA4",
  "PCA", "001I9000004Vt67IAC",
  "PrairiesCan", "001I9000004Vt68IAC",
  "PrairiesCan and PacifiCan", "001I9000004Vt68IAC",
  "RMC", "001I9000004Vt61IAC",
  "Specific Claims Tribunal", missing_identifier,
  "SSC", "001I9000004Vt6HIAS",
  "SSHRC", "001I900000503tgIAA",
  "Tax Court of Canada", missing_identifier,
  "Veterans Ombud", "001I900000505KfIAI",
  "WGEC", "001I9000004zOAzIAM",
  "OSGG", "001OO00000AhiwAYAR"
) %>%
  mutate(
    source = "Airtable/Enterprise",
    identifier = normalize_name(identifier)
  )


orgs <- bind_rows(
  orgs,
  leftovers_gcforms_demos,
  leftovers_gcforms_forms,
  leftovers_gcds,
  leftovers_enterprise
) %>%
  distinct(identifier, .keep_all = TRUE)

