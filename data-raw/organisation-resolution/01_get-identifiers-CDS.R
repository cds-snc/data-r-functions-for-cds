# List of organization identifiers and how to resolve them
# id: canonical CDS unique ID for an organization
# identifier: the name or string we want to resolve to an ID
# source: where the identifier was found originally
orgs <- tibble()

# Read canonical CDS dataset from Github ----------------------------------
# These are the list of "official names" that CDS maintains in a repo
orgs_cds_url <- "https://github.com/cds-snc/gc-organisations/raw/refs/heads/main/data/all.csv"

orgs_cds <- read_csv(
  orgs_cds_url,
  col_types = cols(
    ID = col_character(),
    `English/Anglais` = col_character(),
    `French/Français` = col_character(),
    Type = col_character(),
    Notify_Organisation_ID = col_character()
  ))


# Create canonical list of CDS organization names -------------------------
org_names <- select(
  orgs_cds,
  id = 1,
  name_en = 2,
  name_fr = 3,
  type = 4)



# Map identifiers to name -------------------------------------------------

# English names as per CDS
orgs <- org_names %>%
  select(
    resolves_to = 1,
    identifier = 2
  ) %>%
  mutate(source = "CDS Names/EN") %>%
  bind_rows(orgs)

# French names as per CDS
orgs <- org_names %>%
  select(
    resolves_to = 1,
    identifier = 3
  ) %>%
  mutate(source = "CDS Names/FR") %>%
  bind_rows(orgs)

# Bilingual names as per CDS, EN first
orgs <- org_names %>%
  mutate(identifier = paste0(name_en, " / ", name_fr)) %>%
  select(
    resolves_to = 1,
    identifier
  ) %>%
  mutate(source = "CDS Names/EN+FR") %>%
  bind_rows(orgs)

# Bilingual names as per CDS, FR first
orgs <- org_names %>%
  mutate(identifier = paste0(name_fr, " / ", name_en)) %>%
  select(
    resolves_to = 1,
    identifier
  ) %>%
  mutate(source = "CDS Names/FR+EN") %>%
  bind_rows(orgs)


# GC Notify Identifiers --------------------------------------------------

orgs <- orgs_cds %>%
  select(
    identifier = 5,
    resolves_to = 1) %>%
  mutate(source = "Notify Organisation ID") %>%
  filter(!is.na(identifier)) %>%
  bind_rows(orgs)


orgs$identifier <- normalize_name(orgs$identifier)
orgs <- distinct(orgs)
