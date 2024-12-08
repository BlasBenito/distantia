install.packages("av")
library(av)


# https://ropensci.org/blog/2020/02/03/av-audio/

mp3 <- "data_full/waxwings/XC83651 - Ampelis europeo - Bombycilla garrulus.mp3"

pcm_data <- read_audio_bin(wonderland, channels = 1, end_time = 2.0)


mp3_to_zoo <- function(mp3 = NULL){

  wave <- mp3 |>
    tuneR::readMP3() |>
    tuneR::normalize()

  spectrogram <- signal::specgram(
    x = wave@left,
    Fs = wave@samp.rate
    )

  m <- abs(spectrogram$S)

  t <- spectrogram$t

  x <- zoo::zoo(
    x = m,
    order.by = t
  )

  x <- distantia::zoo_name_set(
    x = x,
    name = "a"
  )

}



# Step 4: Divide into bandwidths and create time series
freqs <- spectrogram$freq  # Frequency bins
times <- spectrogram$time  # Time bins
amplitudes <- spectrogram$S  # Spectrogram matrix

# Define bandwidths (example: Low, Mid, High)
low_band <- freqs[freqs < 500]
mid_band <- freqs[freqs >= 500 & freqs < 2000]
high_band <- freqs[freqs >= 2000]

# Compute mean amplitude for each bandwidth over time
low_amplitude <- rowMeans(amplitudes[freqs < 500, ])
mid_amplitude <- rowMeans(amplitudes[freqs >= 500 & freqs < 2000, ])
high_amplitude <- rowMeans(amplitudes[freqs >= 2000, ])

# Combine into a data frame
time_series <- data.frame(
  time = times,
  low_band = low_amplitude,
  mid_band = mid_amplitude,
  high_band = high_amplitude
)

# View time series
head(time_series)
