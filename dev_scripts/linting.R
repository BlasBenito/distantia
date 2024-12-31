# install.packages("lintr")
library(lintr)
lintr::use_lintr(type = "tidyverse")
lintr::lint_package()
