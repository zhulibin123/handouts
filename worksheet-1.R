## The Editor

vals <- ...

vals <- seq(...,
            ...)

## Vectors

counts ...

## Lists

... <- list(...)
... <- ...(list(1, 2), c(3, 4))

## Factors

education <- ...(c("college", "highschool", "college", "middle"),
                 ... = c("middle", "highschool", ...))

education <- ...(c("college", "highschool", "college", "middle"),
                 levels = c("middle", "highschool", "college"),
                 ...)

## Data Frames

... data.frame(...)

## Exercise 1

...

## Read CSV

surveys <- ...(...)

## Plots

plot(..., ...)

## Histograms

...(surveys$...)

## Boxplots

boxplot(...)

## Names

names(...) <- ...

## Subsetting ranges

days <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
weekdays <- ...
...

## Exercise 2

...

## Anatomy of a function

function(...) {
  ...
  return(...)
}

## Exercise 3

...

## Distributions and statistics

x <- rnorm(..., mean = .., sd = ...)
y <- r...(n = 100, size = 50, ...)

fit <- ...

## Exercise 4

...

## Install missing packages

requirements <- c(...)
installed <- rownames(installed.packages())
missing <- setdiff(..., ...)
                   
if (...) {
  install.packages(missing)
}
