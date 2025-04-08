# Here, we're inferring department domains based on the GEDS Open Data
# You can find the dataset here:
# https://open.canada.ca/data/en/dataset/8ec4a9df-b76b-4a67-8f93-cdbc2e040098

# If you want to run this script, you need to download the script and extract
# it into the data-raw/organisation-resolution/data/ subdirectory. We don't
# do it in the script because of the filesize.

geds_opendata <- read_csv(
  "data-raw/organisation-resolution/data/gedsOpenData.csv",
  locale = locale(encoding = "ISO-8859-1"),
  col_types = cols(
    Surname = col_skip(),
    GivenName = col_skip(),
    Initials =col_skip(),
    `Prefix (EN)` = col_skip(),
    `Prefix (FR)` = col_skip(),
    `Suffix (EN)` = col_skip(),
    `Suffix (FR)` = col_skip(),
    `Title (EN)` = col_skip(),
    `Title (FR)` = col_skip(),
    `Telephone Number` = col_skip(),
    `Fax Number` = col_skip(),
    `TDD Number` = col_skip(),
    `Secure Telephone Number` = col_skip(),
    `Secure Fax Number` = col_skip(),
    `Alternate Telephone Number` = col_skip(),
    Email = col_character(),
    `Street Address (EN)` = col_skip(),
    `Street Address (FR)` = col_skip(),
    `Country (EN)` = col_skip(),
    `Country (FR)` = col_skip(),
    `Province (EN)` = col_skip(),
    `Province (FR)` = col_skip(),
    `City (EN)` = col_skip(),
    `City (FR)` = col_skip(),
    `Postal Code` = col_skip(),
    `PO Box (EN)` = col_skip(),
    `PO Box (FR)` = col_skip(),
    Mailstop = col_skip(),
    `Building (EN)` = col_skip(),
    `Building (FR)` = col_skip(),
    Floor = col_skip(),
    Room = col_skip(),
    `Administrative Assistant` = col_skip(),
    `Administrative Assistant Telephone Number` = col_skip(),
    `Executive Assistant` = col_skip(),
    `Executive Assistant Telephone Number` = col_skip(),
    `Department Acronym` = col_skip(),
    `Department Name (EN)` = col_character(),
    `Department Name (FR)` = col_character(),
    `Organization Acronym` = col_skip(),
    `Organization Name (EN)` = col_skip(),
    `Organization Name (FR)` = col_skip(),
    `Organization Structure (EN)` = col_skip(),
    `Organization Structure (FR)` = col_skip()
  )) %>%
  rename(
    email = 1,
    dept_en = 2,
    dept_fr = 3
  ) %>%
  filter(
    !is.na(email),
    !is.na(dept_en),
    !is.na(dept_fr)
  )

missing_identifier <- "001I9000005Ho3zIAC" # "Department not listed"

# Extract the domains from the GEDS table and do some clean up to rule
# out things thta are likely to cause us trouble
domains <- geds_opendata %>%
  mutate(
    domain = tolower(str_extract(email, pattern = "(?<=@).+")),
    subdomain = tolower(str_extract(email, pattern = "(?<=@)[^.]+(?=\\.)"))
  ) %>%
  count(
    dept_en,
    dept_fr,
    domain,
    subdomain
  ) %>%
  group_by(domain) %>%
  filter(
    n == max(n), # Keep only the most common department for each domain
    n > 1, # Remove domains with only one entry (they're usually typos)
    !(domain %in% c("canada.ca","canada.gc.ca")),   # @canada.ca are broad emails that span departments
    # Only keep NRC domains that have gc.ca in them - otherwise, you get a bunch of University emails
    dept_en != "National Research Council Canada" | str_detect(domain, "gc\\.ca")
  )


# Some people have their departments listed incorrectly or have emails that
# don't match their departments - let's fix them
manual_fixes <- tribble(
  ~ identifier, ~ resolves_to,
  "justice.gc.ca", "001I9000004Vt5mIAC",
  "rcmp-grc.gc.ca", "001I9000004Vt6GIAS",
  "acoa-apeca.gc.ca", "001I9000004Vt5WIAS",
  "fin.gc.ca", "001I9000004Vt5lIAC",
  "forces.gc.ca", "001I9000004Vt61IAC",
  "ps-sp.gc.ca", "001I9000004Vt6CIAS",
  "servicecanada.gc.ca", "001I90000050aMNIAY",
  "cds-snc.ca", "001I90000050aMNIAY",
  "pco-bcp.gc.ca", "001I9000004Vt69IAC",
  "asc-nac.gc.ca", "001I9000004zOqhIAE",
  "cwa-aec.gc.ca", missing_identifier,
  "parl.gc.ca", "001I9000005DbCwIAK"
)

geds_domains <- tibble(
  identifier = normalize_name(domains$domain),
  resolves_to = cds::resolve_name(domains$dept_en, lang = "id"),
  source = "GEDS Extract/Email Domains"
) %>%
  filter(!(identifier %in% manual_fixes$identifier)) %>%
  bind_rows(manual_fixes)


# Missing domains ---------------------------------------------------------
# There are a bunch of departments that are not listed in GEDS
# Let's look them up on Wikipedia and see if we can figure out what
# their domain name is, based on the links on the page

# missing_department_ids <- setdiff(unique(orgs$resolves_to), domains$domain)
#
# missing_departments <- orgs_cds %>%
#   filter(ID %in% missing_department_ids) %>%
#   pull(2)
#
# wikipedia_domains <- tibble(name = NA_character_, domain = NA_character_)
#
# for (department in missing_departments) {
#
#   try({
#     wikitext <- WikipediR::page_content(
#       language = "en",
#       project = "wikipedia",
#       page_name = department,
#       as_wikitext = TRUE
#     )
#
#     # Assume the first domain you run into is the correct one
#     wikipedia_domains <- add_row(
#       wikipedia_domains,
#       name = department,
#       domain = unlist(str_extract(wikitext$parse$wikitext, "[A-Za-z\\-]+\\.gc\\.ca"))
#     )
#   })
#
#   Sys.sleep(1)
# }
#

# It takes too long to run this every time we want to update. Here's the list
# got from running it, you can use the commented script above to re-run if you
# need to update it.

wikipedia_domains <- tribble(
  ~identifier, ~resolves_to,
  "cbsa-asfc.gc.ca", "001I9000004Vt5XIAS",
  "dec-ced.gc.ca", "001I9000004Vt5YIAS",
  "cra-arc.gc.ca", "001I9000004Vt5ZIAS",
  "grainscanada.gc.ca", "001I9000004Vt5cIAC",
  "cse-cst.gc.ca", "001I9000004zLveIAE",
  "csc-scc.gc.ca", "001I900000503m9IAA",
  "dfo-mp.gc.ca", "001I9000004Vt5sIAC",
  "international.gc.ca", "001I9000004Vt5tIAC",
  "pacifican.gc.ca", "001I90000050ZenIAE",
  "tbs-sct.gc.ca", "001I9000004Vt6KIAS",
  "cmhc-schl.gc.ca", "001I9000005063XIAQ",
  "catsa-acsta.gc.ca", "001I90000050b2KIAQ",
  "chrc-ccdp.gc.ca", "001I9000004Vt5eIAC",
  "cannor.gc.ca", "001I9000004Vt5fIAC",
  "crtc.gc.ca", "001I9000004Vt5hIAC",
  "asc-csa.gc.ca", "001I9000004Vt5iIAC",
  "cb-cda.gc.ca", "001I900000503tPIAQ",
  "pc.gc.ca", "001I9000004Vt67IAC",
  "pbc-clcc.gc.ca", "001I900000504ZTIAY",
  "pmprb-cepmb.gc.ca", "001OO000006vSnJYAU",
  "polar-polaire.gc.ca", "001I9000005X2mZIAS",
  "prairiescan.gc.ca", "001I9000004Vt68IAC",
  "pco-bcp.gc.ca", "001I9000004Vt69IAC",
  "sst-tss.gc.ca", "001I90000057LCEIA2",
  "scc-ccn.ca", "001I90000050b2ZIAQ",
  "ccbn-nbc.gc.ca", "001I9000005X2DjIAK",
  "vrab-tacra.gc.ca", "001I900000505KfIAI",
) %>%
  mutate(source = "Wikipedia/Email Domains")


# Missing domains ---------------------------------------------------------
# Some organisations are not listed in GEDS - the list below is maintained
# manually. Mostly, I looked for a media contact email on Google and used
# the domain from that.


missing_domains <- tribble(
  ~ identifier, ~ resolves_to,
  "agr.gc.ca", "001I9000004pwojIAA",
  "elections.ca", "001I9000004Vt5nIAC",
  "fintrac-canafe.canada.ca", "001I9000004Vt5rIAC",  # Fintrac uses both
  "fintrac-canafe.gc.ca", "001I9000004Vt5rIAC",
  "cic.gc.ca", "001I9000004Vt5wIAC",
  "mgerc-ceegm.gc.ca", "001I9000005PIWlIAO",
  "cfp-psc.gc.ca", "001I9000004Vt6DIAS",
  "veterans.gc.ca", "001I9000004Vt6LIAS",
  "tribunal.gc.ca", "001I9000005DbtMIAS",
  "bdc.ca", "001I900000505QTIAY",
  "canadapost.ca", "001I900000505hvIAA",
  "ccohs.ca", "001I900000503ncIAA",
  "cchst.ca", "001I900000503ncIAA",
  "scics.ca", "001OO00000IclDKYAZ",
  "citt-tcce.gc.ca", "001I9000005SgSOIA0",
  "humanrights.ca", "001I900000504boIAA",
  "historymuseum.ca", "001I90000050662IAA",
  "pier21.ca", "001I9000005066MIAQ",
  "nature.ca", "001I900000505NBIAY",
  "edc.ca", "001I900000503nDIAQ",
  "fcc-fac.ca", "001I900000505P7IAI",
  "acfc-fcac.gc.ca", "001I900000503tyIAA",
  "irb-cisr.gc.ca", "001I9000004Vt5vIAC",
  "nfb.ca", "001I900000503gTIAQ",
  "technomuseum.ca", "001OO00000Gg4J0YAJ",
  "nsira-ossnr.gc.ca", "001OO00000GgHJNYA3",
  "oag-bvg.gc.ca", "001I900000503zhIAA",
  "clo-ocol.gc.ca", "001I9000004Vt66IAC",
  "oic-ci.gc.ca", "001OO00000GgH3GYAV",
  "psic-ispc.gc.ca", "001OO00000HzMoJYAV",
  "gg.ca", "001OO00000AhiwAYAR",
  "cas-satj.gc.ca", "001I9000004Vt5kIAC",
  "osfi-bsif.gc.ca", "001I9000005DXSKIA4",
  "oto-boc.gc.ca", "001OO00000Ct4gqYAB",
  "priv.gc.ca", "001I900000504b0IAA",
  "ppsc-sppc.gc.ca", "001I9000004Vt6BIAS",
  "oci-bec.gc.ca", "001OO00000HzZtYYAV",
  "viarail.ca", "001I90000050aLyIAI"
) %>%
  mutate(source = "Manual/Email Domains")



# Combine what we've got so far -------------------------------------------

domains_combined <- bind_rows(
  geds_domains,
  wikipedia_domains,
  missing_domains
)



# Switch language order ---------------------------------------------------
# Many GC domains are in the format of (EN Abbr)-(FR Abbr).gc.ca
# (e.g., tpsgc-pwgsc.gc.ca). In these cases, the reverse,
# (FR Abbr)-(EN Abbr).gc.ca (e.g., pwgsc-tpsgc.gc.ca) may also be a valid
# email. Here, we figure out which ones meet the pattern and swap the order.

domains_swapped <- domains_combined %>%
  filter(str_detect(identifier, "[A-Za-z]+\\-[A-Za-z]+\\.gc\\.ca")) %>%
  mutate(identifier = str_remove(identifier, "\\.gc\\.ca")) %>%
  separate(identifier, into = c("first", "second"), sep = "-") %>%
  mutate(
    identifier = normalize_name(paste0(second, "-", first, ".gc.ca")),
    source = paste0(source, "/Swapped"),
    .keep = "unused",
    )



# Bind it all together ----------------------------------------------------

orgs <- bind_rows(orgs, domains_combined, domains_swapped) %>%
  distinct(identifier, .keep_all = TRUE)

orgs %>%
  filter(str_detect(source, "Email Domain")) %>%
  left_join(orgs_cds, by = c("resolves_to" = "ID")) %>%
  select(-Notify_Organisation_ID) %>%
  arrange(identifier) %>%
  write_excel_csv("org-domains.csv")
