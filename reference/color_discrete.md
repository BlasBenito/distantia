# Default Discrete Color Palettes

Uses the function
[`grDevices::palette.colors()`](https://rdrr.io/r/grDevices/palette.html)
to generate discrete color palettes using the following rules:

- `n <= 9`: "Okabe-Ito".

- `n == 10`: "Tableau 10"

- `n > 10 && n <= 12`: "Paired"

- `n > 12 && n <= 26`: "Alphabet"

- `n > 26 && n <= 36`: "Polychrome 36"

## Usage

``` r
color_discrete(n = NULL, rev = FALSE)
```

## Arguments

- n:

  (required, integer) number of colors to generate. Default = NULL

- rev:

  (optional, logical) If TRUE, the color palette is reversed. Default:
  FALSE

## Value

color vector

## See also

Other internal_plotting:
[`color_continuous()`](https://blasbenito.github.io/distantia/reference/color_continuous.md),
[`utils_color_breaks()`](https://blasbenito.github.io/distantia/reference/utils_color_breaks.md),
[`utils_line_color()`](https://blasbenito.github.io/distantia/reference/utils_line_color.md),
[`utils_line_guide()`](https://blasbenito.github.io/distantia/reference/utils_line_guide.md),
[`utils_matrix_guide()`](https://blasbenito.github.io/distantia/reference/utils_matrix_guide.md),
[`utils_matrix_plot()`](https://blasbenito.github.io/distantia/reference/utils_matrix_plot.md)

## Examples

``` r
color_discrete(n = 9)
#> [1] "#000000" "#E69F00" "#56B4E9" "#009E73" "#F0E442" "#0072B2" "#D55E00"
#> [8] "#CC79A7" "#999999"
```
