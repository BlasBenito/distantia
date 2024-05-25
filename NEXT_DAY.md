Start working on zoo_resample(), with same interface as zoo_aggregate()

Start working on tsl_resample() with same interface as tsl_aggregate() to facilitate lock_step analysis.

Start working on function to map dissimilarity scores as poly lines:

https://stackoverflow.com/questions/20531066/convert-begin-and-end-coordinates-into-spatial-lines-in-r

These days (2020) I would do this with sfheaders:

begin.coord <- data.frame(lon=c(-85.76,-85.46,-85.89), lat=c(38.34,38.76,38.31))
end.coord <- data.frame(lon=c(-85.72,-85.42,-85.85), lat=c(38.38,38.76,38.32))
begin.coord$linestring_id <- end.coord$linestring_id <- seq_len(nrow(begin.coord))
library(dplyr)

sfheaders::sf_linestring(bind_rows(begin.coord, end.coord) %>% arrange(linestring_id), 
                         x = "lon", y = "lat", linestring_id = "linestring_id")
#>   linestring_id                     geometry
#> 1             1 -85.76, -85.72, 38.34, 38.38
#> 2             2 -85.46, -85.42, 38.76, 38.76
#> 3             3 -85.89, -85.85, 38.31, 38.32


Why prepare_zoo_list() has the argument lock_step?

Add possibility of generating matrix of p-values?
