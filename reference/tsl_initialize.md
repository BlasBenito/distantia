# Transform Raw Time Series Data to Time Series List

Most functions in this package take a **time series list** (or **tsl**
for short) as main input. A `tsl` is a list of zoo time series objects
(see [`zoo::zoo()`](https://rdrr.io/pkg/zoo/man/zoo.html)). There is not
a formal class for `tsl` objects, but there are requirements these
objects must follow to ensure the stability of the package
functionalities (see
[`tsl_diagnose()`](https://blasbenito.github.io/distantia/reference/tsl_diagnose.md)).
These requirements are:

- There are no NA, Inf, -Inf, or NaN cases in the zoo objects (see
  [`tsl_count_NA()`](https://blasbenito.github.io/distantia/reference/tsl_count_NA.md)
  and
  [`tsl_handle_NA()`](https://blasbenito.github.io/distantia/reference/tsl_handle_NA.md)).

- All zoo objects must have at least one common column name to allow
  time series comparison (see
  [`tsl_colnames_get()`](https://blasbenito.github.io/distantia/reference/tsl_colnames_get.md)).

- All zoo objects have a character attribute "name" identifying the
  object. This attribute is not part of the zoo class, but the package
  ensures that this attribute is not lost during data manipulations.

- Each element of the time series list is named after the zoo object it
  contains (see
  [`tsl_names_get()`](https://blasbenito.github.io/distantia/reference/tsl_names_get.md),
  [`tsl_names_set()`](https://blasbenito.github.io/distantia/reference/tsl_names_set.md)
  and
  [`tsl_names_clean()`](https://blasbenito.github.io/distantia/reference/tsl_names_clean.md)).

- The time series list contains two zoo objects or more.

The function `tsl_initialize()` (and its alias `tsl_init()`) is designed
to convert the following data structures to a time series list:

- Long data frame: with an ID column to separate time series, and a time
  column that can be of the classes "Date", "POSIXct", "integer", or
  "numeric". The resulting zoo objects and list elements are named after
  the values in the ID column.

- Wide data frame: each column is a time series representing the same
  variable observed at the same time in different places. Each column is
  converted to a separate zoo object and renamed.

- List of vectors: an object like `list(a = runif(10), b = runif(10))`
  is converted to a time series list with as many zoo objects as vectors
  are defined in the original list.

- List of matrices: a list containing matrices, such as
  `list(a = matrix(runif(30), 10, 3), b = matrix(runif(36), 12, 3))`.

- List of zoo objects: a list with zoo objects, such as
  `list(a = zoo_simulate(), b = zoo_simulate())`

## Usage

``` r
tsl_initialize(
  x = NULL,
  name_column = NULL,
  time_column = NULL,
  lock_step = FALSE
)

tsl_init(x = NULL, name_column = NULL, time_column = NULL, lock_step = FALSE)
```

## Arguments

- x:

  (required, list or data frame) Matrix or data frame in long format,
  list of vectors, list of matrices, or list of zoo objects. Default:
  NULL.

- name_column:

  (optional, column name) Column naming individual time series. Numeric
  names are converted to character with the prefix "X". Default: NULL

- time_column:

  (optional if `lock_step = FALSE`, and required otherwise, character
  string) Name of the column representing time, if any. Default: NULL.

- lock_step:

  (optional, logical) If TRUE, all input sequences are subsetted to
  their common times according to the values in `time_column`.

## Value

list of matrices

## Examples

``` r
#long data frame
#---------------------
data("fagus_dynamics")

#name_column is name
#time column is time
str(fagus_dynamics)
#> 'data.frame':    648 obs. of  5 variables:
#>  $ name       : chr  "Spain" "Spain" "Spain" "Spain" ...
#>  $ time       : Date, format: "2001-01-01" "2001-02-01" ...
#>  $ evi        : num  0.193 0.242 0.276 0.396 0.445 ...
#>  $ rainfall   : num  199.8 50.6 170.9 62.7 52.7 ...
#>  $ temperature: num  8.1 7.8 11 10.4 14.1 17.6 18.3 19.6 16.3 16.1 ...

#to tsl
#each group in name_column is a different time series
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
)

#check validity (no messages or errors if valid)
tsl_diagnose(tsl)

#class of contained objects
lapply(X = tsl, FUN = class)
#> $Germany
#> [1] "zoo"
#> 
#> $Spain
#> [1] "zoo"
#> 
#> $Sweden
#> [1] "zoo"
#> 

#get list and zoo names (between double quotes)
tsl_names_get(
  tsl = tsl,
  zoo = TRUE
  )
#>   Germany     Spain    Sweden 
#> "Germany"   "Spain"  "Sweden" 

#plot tsl
if(interactive()){
  tsl_plot(tsl)
}

#list of zoo objects
#--------------------
x <- zoo_simulate()
y <- zoo_simulate()

tsl <- tsl_initialize(
  x = list(
    x = x,
    y = y
  )
)

#plot
if(interactive()){
  tsl_plot(tsl)
}


#wide data frame
#--------------------
#wide data frame
#each column is same variable in different places
df <- stats::reshape(
  data = fagus_dynamics[, c(
    "name",
    "time",
    "evi"
  )],
  timevar = "name",
  idvar = "time",
  direction = "wide",
  sep = "_"
)

str(df)
#> 'data.frame':    216 obs. of  4 variables:
#>  $ time       : Date, format: "2001-01-01" "2001-02-01" ...
#>  $ evi_Spain  : num  0.193 0.242 0.276 0.396 0.445 ...
#>  $ evi_Germany: num  0.354 0.294 0.345 0.392 0.688 ...
#>  $ evi_Sweden : num  0.183 0.182 0.215 0.237 0.519 ...
#>  - attr(*, "reshapeWide")=List of 5
#>   ..$ v.names: NULL
#>   ..$ timevar: chr "name"
#>   ..$ idvar  : chr "time"
#>   ..$ times  : chr [1:3] "Spain" "Germany" "Sweden"
#>   ..$ varying: chr [1, 1:3] "evi_Spain" "evi_Germany" "evi_Sweden"

#to tsl
#key assumptions:
#all columns but "time" represent
#the same variable in different places
#all time series are of the same length
tsl <- tsl_initialize(
  x = df,
  time_column = "time"
  )

#colnames are forced to be the same...
tsl_colnames_get(tsl)
#> $evi_Spain
#> [1] "x"
#> 
#> $evi_Germany
#> [1] "x"
#> 
#> $evi_Sweden
#> [1] "x"
#> 

#...but can be changed
tsl <- tsl_colnames_set(
  tsl = tsl,
  names = "evi"
)
tsl_colnames_get(tsl)
#> $evi_Spain
#> [1] "evi"
#> 
#> $evi_Germany
#> [1] "evi"
#> 
#> $evi_Sweden
#> [1] "evi"
#> 

#plot
if(interactive()){
  tsl_plot(tsl)
}


#list of vectors
#---------------------
#create list of vectors
vector_list <- list(
  a = cumsum(stats::rnorm(n = 50)),
  b = cumsum(stats::rnorm(n = 70)),
  c = cumsum(stats::rnorm(n = 20))
)

#to tsl
#key assumptions:
#all vectors represent the same variable
#in different places
#time series can be of different lengths
#no time column, integer indices are used as time
tsl <- tsl_initialize(
  x = vector_list
)

#plot
if(interactive()){
  tsl_plot(tsl)
}

#list of matrices
#-------------------------
#create list of matrices
matrix_list <- list(
  a = matrix(runif(30), nrow = 10, ncol = 3),
  b = matrix(runif(80), nrow = 20, ncol = 4)
)

#to tsl
#key assumptions:
#each matrix represents a multivariate time series
#in a different place
#all multivariate time series have the same columns
#no time column, integer indices are used as time
tsl <- tsl_initialize(
  x = matrix_list
)

#check column names
tsl_colnames_get(tsl = tsl)
#> $a
#> [1] "x1" "x2" "x3"
#> 
#> $b
#> [1] "x1" "x2" "x3" "x4"
#> 

#remove exclusive column
tsl <- tsl_subset(
  tsl = tsl,
  shared_cols = TRUE
  )
tsl_colnames_get(tsl = tsl)
#> $a
#> [1] "x1" "x2" "x3"
#> 
#> $b
#> [1] "x1" "x2" "x3"
#> 

#plot
if(interactive()){
  tsl_plot(tsl)
}

#list of zoo objects
#-------------------------
zoo_list <- list(
  a = zoo_simulate(),
  b = zoo_simulate()
)

#looks like a time series list! But...
tsl_diagnose(tsl = zoo_list)
#> distantia::tsl_diagnose(): issues in TSL structure:
#> ---------------------------------------------------
#> 
#>   - list and time series names must match and be unique: reset names with distantia::tsl_names_set().

#let's set the names
zoo_list <- tsl_names_set(tsl = zoo_list)

#check again: it's now a valid time series list
tsl_diagnose(tsl = zoo_list)

#to do all this in one go:
tsl <- tsl_initialize(
  x = list(
    a = zoo_simulate(),
    b = zoo_simulate()
  )
)

#plot
if(interactive()){
  tsl_plot(tsl)
}
```
