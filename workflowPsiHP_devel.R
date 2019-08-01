
library(distantia)
library(raster)
library(profvis)#R profiler
load("/home/blas/Dropbox/RESEARCH/PROJECTS/MAIN_PROJECTS/IGNEX/GITHUB/sequence_slotting_paper/suppplementary_material/data/functional_classification.RData")
rm(lai.raster, pixel.coordinates, elevation)


#getting the right columns
modis <- data.modis[, c("pixel", "lai", "fpar", "gross.p")]
rm(data.modis)

#preparing the sequence
modis <- prepareSequences(
  sequences = modis,
  grouping.column = "pixel",
  transformation = "scale"
)

modis <- modis[modis$pixel %in% unique(modis$pixel)[1:10], ]

#new version
system.time(
psi.new <- workflowPsiHP(
  sequences = modis,
  grouping.column = "pixel",
  parallel.execution = FALSE
)
)


#old version
system.time(
psi.old <- workflowPsi(
  sequences = modis,
  grouping.column = "pixel",
  time.column = NULL,
  exclude.columns = NULL,
  parallel.execution = TRUE,
  diagonal = TRUE,
  ignore.blocks = TRUE,
  method = "euclidean"
)
)

#size of permutations matrix
m <- arrangements::permutations(1:35000, k = 2)
dim(m)
format(object.size(m), units = "MB")
