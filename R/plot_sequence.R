library(distantia)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

#data frame with grouping column
###################################
data(sequencesMIS)

#prepare list of sequences
x <- prepare_sequences(
  x = sequencesMIS,
  id_column = "MIS",
  time_column = NULL,
  paired_samples = FALSE,
  pseudo_zero =  0.001,
  na_action = "to_zero"
)

x <- x[[1]]

colors = grDevices::hcl.colors(
  n = 6,
  palette = "Zissou 1"
)

plot_sequence(
  x,
  vertical = FALSE,
  center = FALSE,
  scale = FALSE,
  colors = colors
){

  #x to data frame
  if(any(c(center, scale))){

    df <- scale(
      x = x,
      scale = scale,
      center = center,
    ) |>
      as.data.frame()

  } else {
    #to data frame
    df <- as.data.frame(x)
  }

  #time column
  df.time <- as.numeric(attributes(x)$time)

  #name
  df.name <- attributes(x)$sequence_name

  #names of columns to plot
  df.columns <- colnames(df)

  #first plot
  if(vertical == FALSE){

    plot(
      x = df.time,
      y = df[, df.columns[1]],
      xlab = df.name,
      type = "l",
      ylab = "",
      ylim = range(df, na.rm = TRUE),
      col = colors[1]
    )

    for(i in seq(2, length(df.columns))){
      lines(
        x = df.time,
        y = df[, df.columns[i]],
        col = colors[i]
      )
    }

  } else {

    plot(
      y = df.time,
      x = df[, df.columns[1]],
      ylab = df.name,
      type = "l",
      xlab = "",
      xlim = rev(range(df, na.rm = TRUE)),
      col = colors[1]
    )

    for(i in seq(2, length(df.columns))){
      lines(
        y = df.time,
        x = df[, df.columns[i]],
        col = colors[i]
      )
    }


  }





}
