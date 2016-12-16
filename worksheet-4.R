#######################
#   Using RNetLogo    #
#######################

# if RNetLogo is not already installed
# install.packages("RNetLogo")

# Load the library
library(...)

# define where is NetLogo is
# installed on your computer

... <- ".../NetLogo 5.3.1/..."

# Start an instance of RNetLogo

...(nl_path, gui = TRUE)

# Load a model

... <- ...("models", "Sample Models", "Biology","Wolf Sheep Predation.nlogo")

...(file.path(nl_path, model_path))

#################
#   Commands    #
#################

# Execute commands

...("setup")

NLCommand(...)

# Repeat commands for multiple iterations

...(... = 50, "go")

# Use an R object in a command

init_sheep <- 50

NLCommand("set ...", ... , "setup")

################
#   Reporting  #
################

NLReport(...)

# Combine commands and reporting

...(iterations = ... , 
    ... = "go" , 
    ... = "count sheep")

# Return results as a data frame

NLCommand(...)

sheep_count <- ... (iterations = 100,
                    command = "go",
                    reporter = ... ,
                    ... = TRUE,
                    df.col.names = ...)


#########################
#   Use Conditionals   #
#########################

NLCommand(...) 

sim_results <- ... (... ,
                    command = "go", 
                    reporter = c("ticks", "count sheep", "count wolves"),
                    as.data.frame = TRUE,
                    df.col.names = c("tick", "sheep", "wolves"))

head(sim_results)


################################
#  Run and Repeat Simulations  #
################################

my_sim <- function(n_wolves){
  
  NLCommand("setup", ...)
  ... ( "... and ... and ...", ... )
  ret <- NLReport(...)
  
  return(...)
  
}

# Replicate

...(n = 5, expr = ...)

# Run over different parameters

n_wolves <- ...

res <- lapply(... , function(x) ...)

# Replicate using different parameters

rep_sim <- function(... , ...){
  
  results <- ... (... , function(x) ... )
  return(...)
  
}

sim_results <- ... (n_wolves, reps = 5)

###########################
#    Plot results         #
###########################

# prepare data for plotting

n_wolves_rep <- rep(..., each = ...)

df <- data.frame(as.factor(n_wolves_rep), unlist(...))

names(df) <- c("n_wolves", "time")

# plot using ggplot

# install.packages("ggplot2")
# library(ggplot2)

ggplot(df, aes(x = ..., y = ...)) + 
  ...()


#############
#   Agents  #
#############

...(... = c("pxcor", "pycor"), 
              ... = "wolves")

#############
#  Patches  #
#############

...(... = c("pxcor", "pycor", ...),
             ... = "patches with [...]")

... (patch.var = ..., 
     in.matrix = matrix(...))

################
#  Challenges  #
################

# 1. create a background landscape
# of grass and bare earth pathces
# using a probability distribution


# 2. create a function that runs 
# the simulation and records the 
# path of one or more agents


# 3. set the initial distribution of 
# agents based on a characteristic of
# the landscape 





