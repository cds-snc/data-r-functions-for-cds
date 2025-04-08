library(cds)
library(tidyverse)
library(fuzzyjoin)

source("data-raw/organisation-resolution/01_get-identifiers-CDS.R")
source("data-raw/organisation-resolution/02_get-identifiers-other.R")
source("data-raw/organisation-resolution/03_get-email-domains.R")
source("data-raw/organisation-resolution/04_set-identifiers-manual.R")

source("data-raw/organisation-resolution/99_package-data.R")
