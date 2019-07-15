optimal.costs <- seq(0, 1, by = 0.1)
autosums <- seq(0, 1, by = 0.1)


optimal.costs <- seq(0, 40, by = 1)
autosums <- seq(0, 20, by = 1)

optimal.cost.x <- vector()
autosum.y <- vector()
psi.z <- vector()

for(optimal.cost in optimal.costs){
  for(sum.autosum in autosums){
    optimal.cost.x <- c(optimal.cost.x, optimal.cost)
    autosum.y <- c(autosum.y, sum.autosum)


    #computing psi
    if(sum.autosum <= 0){
      psi.value <- NA
    } else {
      if(optimal.cost <= 0 | optimal.cost <= sum.autosum){
        psi.value <- 0
      } else {
        psi.value <- (optimal.cost - sum.autosum) / sum.autosum
      }
    }
    psi.z <- c(psi.z, psi.value)

  }
}

plot.df <- data.frame(optimal.cost.x, autosum.y, psi.z)

ggplot(data = plot.df, aes(x = optimal.cost.x, y = autosum.y, fill = psi.z)) + geom_tile() + scale_fill_viridis(direction = - 1)

# plot.df[which(plot.df$optimal.cost.x < plot.df$autosum.y), ]
