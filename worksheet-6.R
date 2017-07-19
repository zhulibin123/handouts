library(dplyr)
library(rstan)

animals <- read.csv('data/animals.csv', na.strings = "", stringsAsFactors = FALSE)
species <- read.csv('data/species.csv', na.strings = "", stringsAsFactors = FALSE)

stanimals <- animals %>%
  filter(year == 1980) %>%
  inner_join(species, c('species_id' = 'id')) %>%
  select(weight, genus, hindfoot_length) %>%
  na.omit() %>%
  mutate(
    log_weight = log(weight),
    genus = as.integer(factor(genus))) %>%
  select(-weight) %>%
  as.list() %>%
  c(N = length(.[[1]]), M = max(.[['genus']]))

fit <- stan(file = 'worksheet.stan', data = stanimals,
            iter = 100, chains = 1)
