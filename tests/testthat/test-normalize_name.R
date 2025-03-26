suppressWarnings(library(testthat))
suppressWarnings(library(cds))


# Setup -------------------------------------------------------------------

# Nothing here!

# Tests -------------------------------------------------------------------

test_that("Strings are converted to lowercase", {

  expect_equal(
    normalize_name(
      c("Department of Canadian Heritage / Patrimoine canadien",
        "Canadian Space Agency / Agence spatiale canadienne",
        "Public Safety"
      )),

    c("department canadian heritage patrimoine canadien",
      "canadian space agency agence spatiale canadienne",
      "public safety"
    ))
})


test_that("Diacritics are removed", {
  expect_equal(
    normalize_name(
      c("Sécurité publique Canada",
        "Pêches et Océans Canada",
        "Agence de la consommation en matière financière du Canada"
      )),

    c("securite publique",
      "peches oceans",
      "agence consommation en matiere financiere"
    ))
})

test_that("Common preposition, articles and conjunctions are removed correctly", {

  # These are POSITIVES - they should be removed
  expect_equal(
    normalize_name(
      c("Office of the Correctional Investigator",               # the
        "Library of Parliament",                                 # of
        "Social Sciences and Humanities Research Council",       # and
        "Agence canadienne de développement international",      # de
        "Agence canadienne d'inspection des aliments",           # des, d'
        "Bibliothèque du Parlement",                             # du
        "Diversification de l'économie de l'Ouest Canada" ,      # l'
        "Tribunal de la dotation de la fonction publique",       # la
        "Agence fédérale de développement économique pour le Sud de l’Ontario",  # le
        "Développement économique Canada pour les régions du Québec",  # les
        "Immigration, Réfugiés et Citoyenneté Canada",           # et
        "Service canadien d’appui aux tribunaux administratifs", # aux
        "Commissariat à l'information au Canada",                # à
        "Commissariat au lobbying du Canada"                     # au
      )),

    c("correctional investigator",
      "library parliament",
      "social sciences humanities research council",
      "agence canadienne developpement international",
      "agence canadienne inspection aliments",
      "bibliotheque parlement",
      "diversification economie ouest",
      "tribunal dotation fonction publique",
      "agence federale developpement economique pour sud ontario",
      "developpement economique pour regions quebec",
      "immigration refugies citoyennete",
      "service canadien appui tribunaux administratifs",
      "commissariat information",
      "commissariat lobbying")
  )

  # These are NEGATIVES - they should left alone and not removed
  expect_equal(
    normalize_name(
      c("There are five lights",                         # the
        "Official Name",                                 # of
        "Bland food",                                    # and
        "Department of defense",                         # de
        "Set the destination to home",                   # des
        "Heavy duty construction paper",                 # du
        "a large landlady",                              # la
        "Lead the future",                               # le
        "Lester B. Pearson",                             # les
        "ET: The Extraterrestrial",                      # et
        "Taux de stationnement",                         # aux
        "Ce département là",                             # à
        "Bureau"                                         # au
      )),

    c("there are five lights",
      "official name",
      "bland food",
      "department defense",
      "set destination to home",
      "heavy duty construction paper",
      "a large landlady",
      "lead future",
      "lester b. pearson",
      "et extraterrestrial",
      "taux stationnement",
      "ce departement la",
      "bureau")
  )
})

test_that("Punction is removed correctly", {
  expect_equal(
    normalize_name(c(
      "Forward \ and Back / Slash",
      "Ampersand & Apostrophe'",
      "Comma, \"Double\" and 'Single' Quotes"
    )),

    c("forward back slash",
      "ampersand apostrophe",
      "comma double single quotes"
    )
  )
})

test_that("Whitespace is normalized", {
  expect_equal(
    normalize_name(c(
      " Leading whitespace",
      "Lagging whitespace ",
      "Double  whitespace",
      "Whitespace: created in situ"
    )),
    c("leading whitespace",
      "lagging whitespace",
      "double whitespace",
      "whitespace created in situ"
      )
  )
})


test_that("Different forms of 'Of Canada' are removed correctly", {
  expect_equal(
    normalize_name(c(
      "Shared Services Canada",
      "Transport Canada",
      "Canadian Heritage",
      "Commissioner of Lobbying of Canada (Office of the)",
      "Public Prosecution Service of Canada",
      "Service des poursuites pénales du Canada",
      "Commissariat à l'information au Canada"
    )),

    c("shared services",
      "transport",
      "canadian heritage",
      "commissioner lobbying",
      "public prosecution service",
      "service poursuites penales",
      "commissariat information"
    )
  )
})

test_that("Different forms of 'Office of the' are removed correctly", {
  expect_equal(
    normalize_name(c(
      "Commissioner of Lobbying of Canada (Office of the)",
      "Office of the Commissioner of Lobbying of Canada",
      "Bureau du commissaire au renseignement",
      "Commissaire au renseignement (Bureau d')"
    )),

    c("commissioner lobbying",
      "commissioner lobbying",
      "commissaire renseignement",
      "commissaire renseignement")
  )
})
