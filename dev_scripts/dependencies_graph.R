#function dependencies
########################################
devtools::install_github("datastorm-open/DependenciesGraphs")
library(DependenciesGraphs)

#full package
dep <- DependenciesGraphs::envirDependencies('package:distantia')
plot(dep)

#a single function
dep <- DependenciesGraphs::funDependencies(
  envir = 'package:distantia',
  name.function = "momentum"
)
plot(dep)






