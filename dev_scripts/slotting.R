library(distantia)

load("~/Dropbox/GITHUB/R_packages/distantia/data/mis.RData")

#data frame with grouping column
###################################
x <- prepare_sequences(
  x = mis,
  id_column = "MIS",
  time_column = NULL,
  paired_samples = FALSE,
  pseudo_zero =  0.001,
  na_action = "to_zero"
)



#experiment with vectors
load("~/Dropbox/GITHUB/R_packages/distantia/data/pollenGP.RData")

df <- pollenGP

df <- df[, "age"]

a <- df[seq(1, 200, by = 3)]
b <- df[seq(2, 200, by = 3)]
c <- df[seq(3, 200, by = 3)]

x <- list(
  a = a,
  b = b,
  c = c
)

x <- prepare_sequences(
  x = x
)




