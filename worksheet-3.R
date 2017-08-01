# Installations
## apt-get install libssl-dev
## install.packages('acs')

# load httr namespace

library(httr)

# define the api host, path and query

host <- ...
path <- '/data/2015/acs5'
query <- list(...,
              ...,
              ...)
response <- ...(url = host, path = path, query = query)

# get a household income variable for tracts in MD
## http://api.census.gov/data/2015/acs5/variables/B19001_001E.json

query <- list(...,
              ...,
              'in' = 'state:24')
response <- GET(url = host, path = path, query = query)

# check the status

...(response)

# wrestle into a data frame

parsed <- ...(response, 'parsed')
content <- matrix(unlist(parsed), ncol = 5, byrow = TRUE)
df <- ...
names(df) <- ...
df$B19001_001E <- ...(df$B19001_001E)

# the "acs" package for R

library(acs)
api.key.install(key = ...)

geo <- ...(state='MD', county = '*', tract = '*')
result <- acs.fetch(endyear = 2015, ..., ...)

# wrestle response into a data frame

df_geo <- data.frame(...)
df_est <- data.frame(...)
df <- ...(df_geo, df_est)

# visualize data
library(ggplot2)

ggplot(df, aes(x = factor(county), y = B19001_001)) +
  geom_boxplot()
