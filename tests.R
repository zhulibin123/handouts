# rJava seems unable to find the Mac JVM library.
sysname <- Sys.info()['sysname']
if (sysname == 'Darwin') {
  JAVA_HOME <- system('/usr/libexec/java_home', intern=TRUE)
  dyn.load(paste0(JAVA_HOME, '/jre/lib/server/libjvm.dylib'))
  model.path <- file.path("..", "models", "Sample Models", "Biology", "Wolf Sheep Predation.nlogo")
} else {
  model.path <- file.path("models", "Sample Models", "Biology", "Wolf Sheep Predation.nlogo")
}

# Tests
library(RNetLogo)
library(ggplot2)

message("Find the NetLogo.jar file in your NetLogo installation.")
message("On a Mac, in might be within /Applications/NetLogo 5.3.1/.")
message("On Windows, it might be in C:\\Program Files\\NetLogo 5.3.1\\app\\.")
invisible(readline("Press return to continue ..."))

nl.path <- dirname(file.choose())
NLStart(nl.path, gui=FALSE)
NLLoadModel(file.path(nl.path, model.path))
NLCommand("setup")
NLReport("count sheep")

cat("Tests passed.")
