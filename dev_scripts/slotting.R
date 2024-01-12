library(distantia)

load("~/Dropbox/GITHUB/R_packages/distantia/data/pollenGP.RData")

df <- pollenGP

df <- df[, "age"]

a <- df[seq(1, 199, by = 2)]
b <- df[seq(2, 200, by = 2)]

ab <- slotting(a, b)




a <- sequenceA |>
  na.omit()

b <- sequenceB |>
  na.omit()

ab <- slotting(a, b)
