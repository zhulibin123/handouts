# rJava seems unable to find the Mac JVM library.
sysname <- Sys.info()['sysname']
if (sysname == 'Darwin') {
  JAVA_HOME <- system('/usr/libexec/java_home', intern=TRUE)
  dyn.load(paste0(JAVA_HOME, '/jre/lib/server/libjvm.dylib'))
  model_path <- file.path("..", "models", "Sample Models", "Biology", "Wolf Sheep Predation.nlogo")
} else {
  model_path <- file.path("models", "Sample Models", "Biology", "Wolf Sheep Predation.nlogo")
}

# Tests
library(rJava); .jinit()
library(RNetLogo)
library(ggplot2)

message("")
message("Find the 'netlogo-6.0.1.jar' file in your NetLogo installation.")
message("On a Mac, in might be within /Applications/NetLogo 6.0.1/.")
message("On Windows, it might be in C:\\Program Files\\NetLogo 6.0.1\\app\\.")
invisible(readline("Press return to continue ..."))

nl_jar <- file.choose()
nl_path <- dirname(nl_jar)
NLStart(nl_path, gui = FALSE, nl.jarname = basename(nl_jar))
NLLoadModel(file.path(nl_path, model_path))
NLCommand("setup")
NLReport("count sheep")

cat("Tests passed.")
