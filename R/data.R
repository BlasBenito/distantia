#' Distance Methods
#'
#' Data frame with the names, abbreviations, and expressions of the distance metrics implemented in the package.
#'
#'
#' @docType data
#' @keywords datasets
#' @name distances
#' @usage data(distances)
#' @format Dataframe with 5 columns and 10 rows
"distances"

#' Covid19 dataset.
#'
#' Dataset with Covid19 prevalence in California counties between 2020 and 2024. Downloaded from https://healthdata.gov/State/COVID-19-Time-Series-Metrics-by-County-and-State-A/cr6j-rwfz/about_data
#'
#'
#' @docType data
#' @keywords datasets
#' @name covid
#' @usage data(covid)
#' @format Dataframe with 3 columns and 51048 rows
"covid"

#' Pollen dataset.
#'
#' A subset of the Grande Pile dataset (\url{https://doi.pangaea.de/10.1594/PANGAEA.739275}). It contains a depth (cm) and age columns (ky BP), and 40 pollen types.
#'
#'
#' @docType data
#' @keywords datasets
#' @name gp
#' @usage data(sequenceA)
#' @format Dataframe with 42 columns and 200 rows
"gp"


#' Multivariate and irregular time series with pollen counts.
#'
#' A dataframe with 9 columns representing pollen types (betula, pinus, corylus, empetrum, cypera, artemisia, rumex) and 49 rows representing increasing depths with pollen counts taken from the Abernethy dataset (Birks and Mathewes (1978).
#'
#'
#' @docType data
#' @keywords datasets
#' @name abernethy_a
#' @usage data(sequenceA)
#' @references Birks, H.H. and Mathewes, R.W. (1978) Studies in the vegetational history of Scotland. \emph{New Phytologist} \strong{80}, 455-484.
#' @format Dataframe with 9 columns and 49 rows
"abernethy_a"

#' Multivariate and irregular time series with pollen counts.
#'
#' A dataframe with 8 columns (the column \code{empetr} is missing with respect to \code{\link{sequenceA}}) representing pollen types (betula, pinus, corylus, cypera, artemisia, rumex) and 41 rows representing increasing depths with pollen counts taken from the Abernethy dataset (Birks and Mathewes (1978). Several NA values have been introduced in the dataset to demonstrate the data-handling capabilities of \code{\link{prepareSequences}}.
#'
#'
#' @docType data
#' @keywords datasets
#' @name abernethy_b
#' @usage data(sequenceB)
#' @references Birks, H.H. and Mathewes, R.W. (1978) Studies in the vegetational history of Scotland. \emph{New Phytologist} \strong{80}, 455-484.
#' @format Dataframe with 9 columns and 41 rows
"abernethy_b"

#' Dataframe with pollen counts for different MIS stages.
#'
#' A dataframe with 427 rows representing pollen counts for 12 marine isotope stages and 6 pollen types
#'
#' @docType data
#' @keywords datasets
#' @name mis
#' @usage data(sequencesMIS)
#' @format dataframe with 7 columns and 427 rows.
"mis"

#' Dataframe with palaeoclimatic data.
#'
#' A dataframe containing palaeoclimate data at 1 ky temporal resolution with the following columns:
#'
#' \itemize{
#'   \item \emph{time} in kiloyears before present (ky BP).
#'   \item \emph{sequenceId} numeric identifier of sequences of 200ky within the main sequence, useful to test some functions of the package, such as \code{\link{distancePairedSamples}}
#'   \item \emph{temperatureAverage} average annual temperature in Celsius degrees.
#'   \item \emph{rainfallAverage} average annual precipitation in milimetres per day (mm/day).
#'   \item \emph{temperatureWarmestMonth} average temperature of the warmest month, in Celsius degrees.
#'   \item \emph{temperatureColdestMonth} average temperature of the coldest month, in Celsius degrees.
#' }
#' @author Blas M. Benito  <blasbenito@gmail.com>
#' @docType data
#' @keywords datasets
#' @name climate
#' @usage data(climate)
#' @format dataframe with 6 columns and 800 rows.
"climate"
