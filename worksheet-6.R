## lm

animals <- read.csv('data/animals.csv', stringsAsFactors = FALSE, na.strings = '')
fit <- lm(
  ...,
  data = animals)


animals$species_id <- ...
fit <- lm(
  ...,
  data = animals)

## glm

animals$sex <- ...
fit <- glm(sex ~ hindfoot_length,
           ...,
           data = animals)

## lme4

# install.packages('lme4')

library(lme4)
fit <- lmer(...,
            data = animals)

fit <- lmer(...,
            data = animals)

## RStan

library(dplyr)
library(rstan)
stanimals <- animals %>%
  select(weight, species_id, hindfoot_length) %>%
  na.omit() %>%
  mutate(log_weight = log(weight),
         species_idx = as.integer(factor(species_id))) %>%
  select(-weight, -species_id)
stanimals <- c(
  N = nrow(stanimals),
  M = max(stanimals$species_idx),
  as.list(stanimals))

samp <- stan(file = 'worksheet-6.stan',
             data = stanimals,
             iter = 1000, chains = 3)
saveRDS(samp, 'stanimals.RDS')
