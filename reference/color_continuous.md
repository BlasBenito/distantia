# Default Continuous Color Palette

Uses the function
[`grDevices::hcl.colors()`](https://rdrr.io/r/grDevices/palettes.html)
to generate a continuous color palette.

## Usage

``` r
color_continuous(n = 5, palette = "Zissou 1", rev = FALSE)
```

## Arguments

- n:

  (required, integer) number of colors to generate. Default = NULL

- palette:

  (required, character string) Argument `palette` of
  [`grDevices::hcl.colors()`](https://rdrr.io/r/grDevices/palettes.html).
  Default: "Zissou 1"

- rev:

  (optional, logical) If TRUE, the color palette is reversed. Default:
  FALSE

## Value

color vector

## See also

Other internal_plotting:
[`color_discrete()`](https://blasbenito.github.io/distantia/reference/color_discrete.md),
[`utils_color_breaks()`](https://blasbenito.github.io/distantia/reference/utils_color_breaks.md),
[`utils_line_color()`](https://blasbenito.github.io/distantia/reference/utils_line_color.md),
[`utils_line_guide()`](https://blasbenito.github.io/distantia/reference/utils_line_guide.md),
[`utils_matrix_guide()`](https://blasbenito.github.io/distantia/reference/utils_matrix_guide.md),
[`utils_matrix_plot()`](https://blasbenito.github.io/distantia/reference/utils_matrix_plot.md)

## Examples

``` r
color_continuous(n = 20)
#>  [1] "#3B99B1" "#35A2AC" "#3FAAA6" "#52B19F" "#6AB699" "#81BB95" "#98BF95"
#>  [8] "#AAC392" "#BEC78D" "#D4CA84" "#EAC527" "#EAB821" "#E9AC1C" "#E89F16"
#> [15] "#E7920D" "#E78400" "#E87500" "#EB6200" "#EF4900" "#F5191C"
```
