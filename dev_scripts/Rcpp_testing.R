# http://adv-r.had.co.nz/Rcpp.html
# http://adv-r.had.co.nz/Rcpp.html#rcpp-package
# https://gallery.rcpp.org/articles/parallel-distance-matrix/

library(Rcpp)
library(distantia)
library(microbenchmark)

sourceCpp("src/distance.cpp")
Rcpp::compileAttributes()

#data for testing
x <- runif(10000)
y <- runif(10000)
#>
#> Attaching package: 'Rcpp'
#> The following object is masked from 'package:inline':
#>
#>     registerPlugin
#>

#MANHATTAN
#################################################################
cppFunction('double manhattan(NumericVector x, NumericVector y) {
  int length = x.size();
  double dist;
  for (int j = 0; j < length; j++) {
    double dev = std::fabs(x[j] - y[j]);
    dist += dev;
  }
  return dist;
}')

manhattan(x, y)
distance_manhattan(x, y)

microbenchmark(
  manhattan(x, y),
  distance_manhattan(x, y)
  )


#euclidean
###################################################################
cppFunction('double euclidean(NumericVector x, NumericVector y) {
  int length = x.size();
  double dist = 0;
  for (int j = 0; j < length; j++) {
    double dev = std::pow(x[j] - y[j], 2);
    dist += dev;
  }
  return std::sqrt(dist);
}')

euclidean(x, y)
distance_euclidean(x, y)

microbenchmark(
  euclidean(x, y),
  distance_euclidean(x, y)
)


#hellinger
#####################################
#####################################
cppFunction('double hellinger(NumericVector x, NumericVector y) {
  int length = x.size();
  double dist = 0;

  for (int j = 0; j < length; j++) {
    double dev = std::pow(std::sqrt(x[j]) - std::sqrt(y[j]), 2);
    dist += dev;
  }

  return std::sqrt(0.5 * dist);
}')


hellinger(x, y)
distance_hellinger(x, y)

microbenchmark(
  hellinger(x, y),
  distance_hellinger(x, y)
)


#CHI
##############################################################
cppFunction('double chi(NumericVector x, NumericVector y) {
  int length = x.size();
  double dist = 0;

  double x_sum = sum(x);
  double y_sum = sum(y);
  double xy_sum = x_sum + y_sum;

  for (int j = 0; j < length; j++) {

    double x_norm = x[j] / x_sum;
    double y_norm = y[j] / y_sum;

    double dev = std::pow(x_norm - y_norm, 2);
    dist += dev / ((x[j] + y[j])/xy_sum);
  }

  return std::sqrt(dist);

}')


chi(x, y)
distance_chi(x, y)

microbenchmark(
  chi(x, y),
  distance_chi(x, y)
)


#distance_matrix
#IT WORKS
############################################
cppFunction('
            NumericMatrix distance_matrix_c(NumericMatrix a, NumericMatrix b) {

  int an = a.nrow();
  int bn = b.nrow();
  NumericMatrix D(an, bn);

  Environment env = Environment::namespace_env("distantia");
  Function f_distance = env["euclidean"];

  for (int i = 0; i < an; i++) {
    for (int j = 0; j < bn; j++) {
      NumericVector row1 = a.row(i);
      NumericVector row2 = b.row(j);
      double dist = as<double>(f_distance(a.row(i), b.row(j)));
      D(i, j) = dist;
    }
  }

  return D;
}')



a <- data.frame(
  x = runif(100),
  y = runif(100),
  z = runif(100)
) |>
  as.matrix()

b <- data.frame(
  x = runif(100),
  y = runif(100),
  z = runif(100)
) |>
  as.matrix()

distance_matrix_c(a, b)

out <- microbenchmark(
  distance_matrix_c(a, b),
  distance_matrix_r(a, b, method = "euclidean"),
  times = 10
)

D1 <- d(a, b)
D2 <- distance_matrix(a, b)

D1[1:5, 1:5]
D2[1:5, 1:5]

