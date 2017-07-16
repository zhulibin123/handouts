## Tidy data concept

counts_df <- data.frame(
  day = c("Monday", "Tuesday", "Wednesday"),
  wolf = c(2, ...),
  hare = ...,
  ...
)

## Reshaping multiple columns in category/value pairs

library(tidyr)
counts_gather <- gather(counts_df,
                        ...,
                        ...,
                        ...)

counts_spread <- spread(counts_gather,
                        ...,
                        ...)

## Exercise 1

...

## Read comma-separated-value (CSV) files

animals <- ...

animals <- read.csv('data/animals.csv', )

library(dplyr)
library(...)

con <- ...(..., host = 'localhost', dbname = 'portal')
animals_db <- ...
animals <- ...
dbDisconnect(...)

## Subsetting and sorting

library(dplyr)
animals_1990_winter <- filter(...,
                              ...,
                              ...)

animals_1990_winter <- select(animals_1990_winter, ...)

sorted <- ...(animals_1990_winter,
              ...)

## Exercise 2

...

## Grouping and aggregation

animals_1990_winter_gb <- group_by(...)

counts_1990_winter <- summarize(..., count = n())

## Exercise 3

...

## Pivot tables through aggregate and spread

animals_1990_winter_gb <- group_by(animals_1990_winter, ...)
counts_by_month <- ...(animals_1990_winter_gb, ...)
pivot <- ...

## Transformation of variables

prop_1990_winter <- mutate(...,
                           ...)

## Exercise 4

...

## Chainning with pipes

prop_1990_winter_piped <- animals %>%
  filter(year == 1990, month %in% 1:3)
  ... # select all columns but year
  ... # group by species_id
  ... # summarize with counts
  ... # mutate into proportions
