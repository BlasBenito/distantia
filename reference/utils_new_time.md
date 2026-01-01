# New Time for Time Series Aggregation

Internal function called by
[`tsl_aggregate()`](https://blasbenito.github.io/distantia/reference/tsl_aggregate.md)
and
[`tsl_resample()`](https://blasbenito.github.io/distantia/reference/tsl_resample.md)
to help transform the input argument `new_time` into the proper format
for time series aggregation or resampling.

## Usage

``` r
utils_new_time(tsl = NULL, new_time = NULL, keywords = "aggregate")

utils_new_time_type(
  tsl = NULL,
  new_time = NULL,
  keywords = c("resample", "aggregate")
)
```

## Arguments

- tsl:

  (required, list) Time series list. Default: NULL

- new_time:

  (required, zoo object, numeric, numeric vector, Date vector, POSIXct
  vector, or keyword) breakpoints defining aggregation groups. Options
  are:

  - numeric vector: only for the "numeric" time class, defines the
    breakpoints for time series aggregation.

  - "Date" or "POSIXct" vector: as above, but for the time classes
    "Date" and "POSIXct." In any case, the input vector is coerced to
    the time class of the `tsl` argument.

  - numeric: defines fixed with time intervals for time series
    aggregation. Used as is when the time class is "numeric", and
    coerced to integer and interpreted as days for the time classes
    "Date" and "POSIXct".

  - keyword (see
    [`utils_time_units()`](https://blasbenito.github.io/distantia/reference/utils_time_units.md)
    and
    [`tsl_time_summary()`](https://blasbenito.github.io/distantia/reference/tsl_time.md)):
    the common options for the time classes "Date" and "POSIXct" are:
    "millennia", "centuries", "decades", "years", "quarters", "months",
    and "weeks". Exclusive keywords for the "POSIXct" time class are:
    "days", "hours", "minutes", and "seconds". The time class "numeric"
    accepts keywords coded as scientific numbers, from "1e8" to "1e-8".

- keywords:

  (optional, character string or vector) Defines what keywords are
  returned. If "aggregate", returns valid keywords for
  [`zoo_aggregate()`](https://blasbenito.github.io/distantia/reference/zoo_aggregate.md).
  If "resample", returns valid keywords for
  [`zoo_resample()`](https://blasbenito.github.io/distantia/reference/zoo_resample.md).
  Default: "aggregate".

## Value

Vector of class numeric, Date, or POSIXct

## See also

Other internal_time_handling:
[`utils_as_time()`](https://blasbenito.github.io/distantia/reference/utils_as_time.md),
[`utils_coerce_time_class()`](https://blasbenito.github.io/distantia/reference/utils_coerce_time_class.md),
[`utils_is_time()`](https://blasbenito.github.io/distantia/reference/utils_is_time.md),
[`utils_time_keywords()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords.md),
[`utils_time_keywords_dictionary()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_dictionary.md),
[`utils_time_keywords_translate()`](https://blasbenito.github.io/distantia/reference/utils_time_keywords_translate.md),
[`utils_time_units()`](https://blasbenito.github.io/distantia/reference/utils_time_units.md)

## Examples

``` r
#three time series
#climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
tsl <- tsl_initialize(
  x = fagus_dynamics,
  name_column = "name",
  time_column = "time"
)

# new time for aggregation using keywords
#-----------------------------------

#get valid keywords for aggregation
tsl_time_summary(
  tsl = tsl,
  keywords = "aggregate"
)$keywords
#> [1] "decades"  "years"    "quarters"

#if no keyword is used, for aggregation the highest resolution keyword is selected automatically
new_time <- utils_new_time(
  tsl = tsl,
  new_time = NULL,
  keywords = "aggregate"
)
#> distantia::utils_new_time(): aggregating 'tsl' with keyword 'quarters'.

new_time
#>  [1] "2001-01-01" "2001-04-01" "2001-07-01" "2001-10-01" "2002-01-01"
#>  [6] "2002-04-01" "2002-07-01" "2002-10-01" "2003-01-01" "2003-04-01"
#> [11] "2003-07-01" "2003-10-01" "2004-01-01" "2004-04-01" "2004-07-01"
#> [16] "2004-10-01" "2005-01-01" "2005-04-01" "2005-07-01" "2005-10-01"
#> [21] "2006-01-01" "2006-04-01" "2006-07-01" "2006-10-01" "2007-01-01"
#> [26] "2007-04-01" "2007-07-01" "2007-10-01" "2008-01-01" "2008-04-01"
#> [31] "2008-07-01" "2008-10-01" "2009-01-01" "2009-04-01" "2009-07-01"
#> [36] "2009-10-01" "2010-01-01" "2010-04-01" "2010-07-01" "2010-10-01"
#> [41] "2011-01-01" "2011-04-01" "2011-07-01" "2011-10-01" "2012-01-01"
#> [46] "2012-04-01" "2012-07-01" "2012-10-01" "2013-01-01" "2013-04-01"
#> [51] "2013-07-01" "2013-10-01" "2014-01-01" "2014-04-01" "2014-07-01"
#> [56] "2014-10-01" "2015-01-01" "2015-04-01" "2015-07-01" "2015-10-01"
#> [61] "2016-01-01" "2016-04-01" "2016-07-01" "2016-10-01" "2017-01-01"
#> [66] "2017-04-01" "2017-07-01" "2017-10-01" "2018-01-01" "2018-04-01"
#> [71] "2018-07-01" "2018-10-01" "2019-01-01"

#if no keyword is used
#for resampling a regular version
#of the original time based on the
#average resolution is used instead
new_time <- utils_new_time(
  tsl = tsl,
  new_time = NULL,
  keywords = "resample"
)
#> distantia::utils_new_time(): resampling 'tsl' to its average resolution.

new_time
#>   [1] "2001-01-01" "2001-01-31" "2001-03-02" "2001-04-02" "2001-05-02"
#>   [6] "2001-06-02" "2001-07-02" "2001-08-02" "2001-09-01" "2001-10-01"
#>  [11] "2001-11-01" "2001-12-01" "2002-01-01" "2002-01-31" "2002-03-03"
#>  [16] "2002-04-02" "2002-05-02" "2002-06-02" "2002-07-02" "2002-08-02"
#>  [21] "2002-09-01" "2002-10-02" "2002-11-01" "2002-12-01" "2003-01-01"
#>  [26] "2003-01-31" "2003-03-03" "2003-04-02" "2003-05-03" "2003-06-02"
#>  [31] "2003-07-02" "2003-08-02" "2003-09-01" "2003-10-02" "2003-11-01"
#>  [36] "2003-12-02" "2004-01-01" "2004-02-01" "2004-03-02" "2004-04-01"
#>  [41] "2004-05-02" "2004-06-01" "2004-07-02" "2004-08-01" "2004-09-01"
#>  [46] "2004-10-01" "2004-10-31" "2004-12-01" "2004-12-31" "2005-01-31"
#>  [51] "2005-03-02" "2005-04-02" "2005-05-02" "2005-06-01" "2005-07-02"
#>  [56] "2005-08-01" "2005-09-01" "2005-10-01" "2005-11-01" "2005-12-01"
#>  [61] "2005-12-31" "2006-01-31" "2006-03-02" "2006-04-02" "2006-05-02"
#>  [66] "2006-06-02" "2006-07-02" "2006-08-01" "2006-09-01" "2006-10-01"
#>  [71] "2006-11-01" "2006-12-01" "2007-01-01" "2007-01-31" "2007-03-03"
#>  [76] "2007-04-02" "2007-05-02" "2007-06-02" "2007-07-02" "2007-08-02"
#>  [81] "2007-09-01" "2007-10-02" "2007-11-01" "2007-12-01" "2008-01-01"
#>  [86] "2008-01-31" "2008-03-02" "2008-04-01" "2008-05-02" "2008-06-01"
#>  [91] "2008-07-01" "2008-08-01" "2008-08-31" "2008-10-01" "2008-10-31"
#>  [96] "2008-12-01" "2008-12-31" "2009-01-30" "2009-03-02" "2009-04-01"
#> [101] "2009-05-02" "2009-06-01" "2009-07-02" "2009-08-01" "2009-08-31"
#> [106] "2009-10-01" "2009-10-31" "2009-12-01" "2009-12-31" "2010-01-31"
#> [111] "2010-03-02" "2010-04-02" "2010-05-02" "2010-06-01" "2010-07-02"
#> [116] "2010-08-01" "2010-09-01" "2010-10-01" "2010-11-01" "2010-12-01"
#> [121] "2010-12-31" "2011-01-31" "2011-03-02" "2011-04-02" "2011-05-02"
#> [126] "2011-06-02" "2011-07-02" "2011-08-01" "2011-09-01" "2011-10-01"
#> [131] "2011-11-01" "2011-12-01" "2012-01-01" "2012-01-31" "2012-03-01"
#> [136] "2012-04-01" "2012-05-01" "2012-06-01" "2012-07-01" "2012-08-01"
#> [141] "2012-08-31" "2012-09-30" "2012-10-31" "2012-11-30" "2012-12-31"
#> [146] "2013-01-30" "2013-03-02" "2013-04-01" "2013-05-02" "2013-06-01"
#> [151] "2013-07-01" "2013-08-01" "2013-08-31" "2013-10-01" "2013-10-31"
#> [156] "2013-12-01" "2013-12-31" "2014-01-30" "2014-03-02" "2014-04-01"
#> [161] "2014-05-02" "2014-06-01" "2014-07-02" "2014-08-01" "2014-08-31"
#> [166] "2014-10-01" "2014-10-31" "2014-12-01" "2014-12-31" "2015-01-31"
#> [171] "2015-03-02" "2015-04-01" "2015-05-02" "2015-06-01" "2015-07-02"
#> [176] "2015-08-01" "2015-09-01" "2015-10-01" "2015-10-31" "2015-12-01"
#> [181] "2015-12-31" "2016-01-31" "2016-03-01" "2016-04-01" "2016-05-01"
#> [186] "2016-06-01" "2016-07-01" "2016-07-31" "2016-08-31" "2016-09-30"
#> [191] "2016-10-31" "2016-11-30" "2016-12-31" "2017-01-30" "2017-03-01"
#> [196] "2017-04-01" "2017-05-01" "2017-06-01" "2017-07-01" "2017-08-01"
#> [201] "2017-08-31" "2017-09-30" "2017-10-31" "2017-11-30" "2017-12-31"
#> [206] "2018-01-30" "2018-03-02" "2018-04-01" "2018-05-01" "2018-06-01"
#> [211] "2018-07-01" "2018-08-01" "2018-08-31" "2018-10-01" "2018-10-31"
#> [216] "2018-12-01"

#aggregation time vector form keyword "years"
new_time <- utils_new_time(
  tsl = tsl,
  new_time = "years",
  keywords = "aggregate"
)

new_time
#>  [1] "2001-01-01" "2002-01-01" "2003-01-01" "2004-01-01" "2005-01-01"
#>  [6] "2006-01-01" "2007-01-01" "2008-01-01" "2009-01-01" "2010-01-01"
#> [11] "2011-01-01" "2012-01-01" "2013-01-01" "2014-01-01" "2015-01-01"
#> [16] "2016-01-01" "2017-01-01" "2018-01-01" "2019-01-01"

#same from shortened keyword
#see utils_time_keywords_dictionary()
utils_new_time(
  tsl = tsl,
  new_time = "year",
  keywords = "aggregate"
)
#>  [1] "2001-01-01" "2002-01-01" "2003-01-01" "2004-01-01" "2005-01-01"
#>  [6] "2006-01-01" "2007-01-01" "2008-01-01" "2009-01-01" "2010-01-01"
#> [11] "2011-01-01" "2012-01-01" "2013-01-01" "2014-01-01" "2015-01-01"
#> [16] "2016-01-01" "2017-01-01" "2018-01-01" "2019-01-01"

#same for abbreviated keyword
utils_new_time(
  tsl = tsl,
  new_time = "y",
  keywords = "aggregate"
)
#>  [1] "2001-01-01" "2002-01-01" "2003-01-01" "2004-01-01" "2005-01-01"
#>  [6] "2006-01-01" "2007-01-01" "2008-01-01" "2009-01-01" "2010-01-01"
#> [11] "2011-01-01" "2012-01-01" "2013-01-01" "2014-01-01" "2015-01-01"
#> [16] "2016-01-01" "2017-01-01" "2018-01-01" "2019-01-01"

#from a integer defining a time interval in days
utils_new_time(
  tsl = tsl,
  new_time = 365,
  keywords = "aggregate"
)
#>  [1] "2001-01-01" "2002-01-01" "2003-01-01" "2004-01-01" "2004-12-31"
#>  [6] "2005-12-31" "2006-12-31" "2007-12-31" "2008-12-30" "2009-12-30"
#> [11] "2010-12-30" "2011-12-30" "2012-12-29" "2013-12-29" "2014-12-29"
#> [16] "2015-12-29" "2016-12-28" "2017-12-28"

#using this vector as input for aggregation
tsl_aggregated <- tsl_aggregate(
  tsl = tsl,
  new_time = new_time
)
```
