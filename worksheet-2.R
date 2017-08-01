## The Editor

vals <- ...

vals <- seq(...,
            ...)

## Vectors

counts ...

## Exercise 1

...

## Factors

education <- ...(c("college", "highschool", "college", "middle"),
                 ... = c("middle", "highschool", ...))

education <- ...(c("college", "highschool", "college", "middle"),
                 levels = c("middle", "highschool", "college"),
                 ...)

## Data Frames

... data.frame(...)

## Exercise 2

...

## Load data into R

plots <- ...(...)
animals <- ...(...)

## Exercise 3

...

## Names

...(df) <- c(...)

## Subsetting ranges

days <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
weekdays <- ...
...

## Exercise 4

...

## Anatomy of a function

function(...) {
  ...
  return(...)
}

## Flow control

if (...) {
    ...
} else {
    ...
}

firts <- function(...) {
    if (...) {
        ...
    } else {
        ...
    }
}

## Linear models

animals <- read.csv(..., stringsAsFactors = FALSE, na.strings = '')
fit <- lm(
  ...,
  data = ...)

## Exercise 6

...

## Pay attention to factors

animals$species_id <- ...
fit <- lm(
  log(weight) ~ ...,
  data = animals)
