# Momentum Data Frame to Wide Format

Transforms a data frame returned by
[`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md)
to wide format with the following columns:

- `most_similar`: name of the variable with the highest contribution to
  similarity (most negative value in the `importance` column) for each
  pair of time series.

- `most_dissimilar`: name of the variable with the highest contribution
  to dissimilarity (most positive value in the `importance` column) for
  each pair of time series.

- `importance__variable_name`: contribution to similarity (negative
  values) or dissimilarity (positive values) of the given variable.

- `psi_only_with__variable_name`: dissimilarity of the two time series
  when only using the given variable.

- `psi_without__variable_name`: dissimilarity of the two time series
  when removing the given variable.

## Usage

``` r
momentum_to_wide(df = NULL, sep = "__")
```

## Arguments

- df:

  (required, data frame) Output of
  [`momentum()`](https://blasbenito.github.io/distantia/reference/momentum.md),
  [`momentum_ls()`](https://blasbenito.github.io/distantia/reference/momentum_ls.md),
  or
  [`momentum_dtw()`](https://blasbenito.github.io/distantia/reference/momentum_dtw.md).
  Default: NULL

- sep:

  (required, character string) Separator between the name of the
  importance metric and the time series variable. Default: "\_\_".

## Value

data frame

## See also

Other momentum_support:
[`momentum_aggregate()`](https://blasbenito.github.io/distantia/reference/momentum_aggregate.md),
[`momentum_boxplot()`](https://blasbenito.github.io/distantia/reference/momentum_boxplot.md),
[`momentum_model_frame()`](https://blasbenito.github.io/distantia/reference/momentum_model_frame.md),
[`momentum_spatial()`](https://blasbenito.github.io/distantia/reference/momentum_spatial.md),
[`momentum_stats()`](https://blasbenito.github.io/distantia/reference/momentum_stats.md)

## Examples

``` r
tsl <- tsl_initialize(
  x = distantia::albatross,
  name_column = "name",
  time_column = "time"
) |>
  tsl_transform(
    f = f_scale_global
  )

#importance data frame
df <- momentum(
  tsl = tsl
)

df
#>       x    y      psi    variable  importance               effect
#> 1  X132 X134 1.163499           x   89.721187 decreases similarity
#> 2  X132 X134 1.163499           y  101.305396 decreases similarity
#> 3  X132 X134 1.163499       speed  -28.286386 increases similarity
#> 4  X132 X134 1.163499 temperature   78.130508 decreases similarity
#> 5  X132 X134 1.163499     heading  -43.644053 increases similarity
#> 6  X132 X136 2.307844           x   15.687570 decreases similarity
#> 7  X132 X136 2.307844           y   82.867368 decreases similarity
#> 8  X132 X136 2.307844       speed  -67.196851 increases similarity
#> 9  X132 X136 2.307844 temperature  382.039900 decreases similarity
#> 10 X132 X136 2.307844     heading -104.245839 increases similarity
#> 11 X132 X153 2.306471           x  467.261463 decreases similarity
#> 12 X132 X153 2.306471           y  159.727491 decreases similarity
#> 13 X132 X153 2.306471       speed  -44.549191 increases similarity
#> 14 X132 X153 2.306471 temperature   -4.016121 increases similarity
#> 15 X132 X153 2.306471     heading  -88.852346 increases similarity
#> 16 X134 X136 2.206298           x   36.205194 decreases similarity
#> 17 X134 X136 2.206298           y   90.757712 decreases similarity
#> 18 X134 X136 2.206298       speed  -61.923595 increases similarity
#> 19 X134 X136 2.206298 temperature  348.244258 decreases similarity
#> 20 X134 X136 2.206298     heading  -96.737145 increases similarity
#> 21 X134 X153 2.115504           x  761.132445 decreases similarity
#> 22 X134 X153 2.115504           y   26.329542 decreases similarity
#> 23 X134 X153 2.115504       speed  -62.801312 increases similarity
#> 24 X134 X153 2.115504 temperature  -23.264433 increases similarity
#> 25 X134 X153 2.115504     heading  -76.874072 increases similarity
#> 26 X136 X153 2.686551           x  530.402462 decreases similarity
#> 27 X136 X153 2.686551           y   24.217594 decreases similarity
#> 28 X136 X153 2.686551       speed  -67.659029 increases similarity
#> 29 X136 X153 2.686551 temperature  255.711643 decreases similarity
#> 30 X136 X153 2.686551     heading -119.877355 increases similarity
#>    psi_difference psi_without psi_only_with  distance diagonal bandwidth
#> 1      1.04390518    1.111188     2.1550935 euclidean     TRUE         1
#> 2      1.17868735    1.092833     2.2715204 euclidean     TRUE         1
#> 3     -0.32911184    1.284514     0.9554020 euclidean     TRUE         1
#> 4      0.90904774    1.099009     2.0080565 euclidean     TRUE         1
#> 5     -0.50779815    1.437155     0.9293573 euclidean     TRUE         1
#> 6      0.36204459    2.311210     2.6732545 euclidean     TRUE         1
#> 7      1.91244927    2.224086     4.1365352 euclidean     TRUE         1
#> 8     -1.55079824    2.760115     1.2093171 euclidean     TRUE         1
#> 9      8.81688350    1.406874    10.2237578 euclidean     TRUE         1
#> 10    -2.40583096    3.521415     1.1155843 euclidean     TRUE         1
#> 11    10.77725027    1.804499    12.5817493 euclidean     TRUE         1
#> 12     3.68406831    2.009827     5.6938953 euclidean     TRUE         1
#> 13    -1.02751418    2.625354     1.5978393 euclidean     TRUE         1
#> 14    -0.09263067    2.327298     2.2346670 euclidean     TRUE         1
#> 15    -2.04935361    3.405979     1.3566257 euclidean     TRUE         1
#> 16     0.79879461    2.207099     3.0058938 euclidean     TRUE         1
#> 17     2.00238595    2.142738     4.1451235 euclidean     TRUE         1
#> 18    -1.36621929    2.664565     1.2983462 euclidean     TRUE         1
#> 19     7.68330753    1.397224     9.0805312 euclidean     TRUE         1
#> 20    -2.13431009    3.282323     1.1480127 euclidean     TRUE         1
#> 21    16.10178922    1.392314    17.4941037 euclidean     TRUE         1
#> 22     0.55700259    2.064727     2.6217298 euclidean     TRUE         1
#> 23    -1.32856443    2.504608     1.1760437 euclidean     TRUE         1
#> 24    -0.49216006    2.155119     1.6629588 euclidean     TRUE         1
#> 25    -1.62627425    3.037239     1.4109647 euclidean     TRUE         1
#> 26    14.24953216    2.359901    16.6094327 euclidean     TRUE         1
#> 27     0.65061800    2.672038     3.3226560 euclidean     TRUE         1
#> 28    -1.81769426    3.166674     1.3489801 euclidean     TRUE         1
#> 29     6.86982348    1.968105     8.8379282 euclidean     TRUE         1
#> 30    -3.22056616    4.409902     1.1893363 euclidean     TRUE         1
#>    lock_step robust
#> 1      FALSE   TRUE
#> 2      FALSE   TRUE
#> 3      FALSE   TRUE
#> 4      FALSE   TRUE
#> 5      FALSE   TRUE
#> 6      FALSE   TRUE
#> 7      FALSE   TRUE
#> 8      FALSE   TRUE
#> 9      FALSE   TRUE
#> 10     FALSE   TRUE
#> 11     FALSE   TRUE
#> 12     FALSE   TRUE
#> 13     FALSE   TRUE
#> 14     FALSE   TRUE
#> 15     FALSE   TRUE
#> 16     FALSE   TRUE
#> 17     FALSE   TRUE
#> 18     FALSE   TRUE
#> 19     FALSE   TRUE
#> 20     FALSE   TRUE
#> 21     FALSE   TRUE
#> 22     FALSE   TRUE
#> 23     FALSE   TRUE
#> 24     FALSE   TRUE
#> 25     FALSE   TRUE
#> 26     FALSE   TRUE
#> 27     FALSE   TRUE
#> 28     FALSE   TRUE
#> 29     FALSE   TRUE
#> 30     FALSE   TRUE

#to wide format
df_wide <- momentum_to_wide(
  df = df
)

df_wide
#>      x    y      psi most_similarity most_dissimilarity importance__heading
#> 1 X132 X134 1.163499         heading                  y           -43.64405
#> 2 X132 X136 2.307844         heading        temperature          -104.24584
#> 3 X132 X153 2.306471         heading                  x           -88.85235
#> 4 X134 X136 2.206298         heading        temperature           -96.73714
#> 5 X134 X153 2.115504         heading                  x           -76.87407
#> 6 X136 X153 2.686551         heading                  x          -119.87735
#>   importance__speed importance__temperature importance__x importance__y
#> 1         -28.28639               78.130508      89.72119     101.30540
#> 2         -67.19685              382.039900      15.68757      82.86737
#> 3         -44.54919               -4.016121     467.26146     159.72749
#> 4         -61.92359              348.244258      36.20519      90.75771
#> 5         -62.80131              -23.264433     761.13244      26.32954
#> 6         -67.65903              255.711643     530.40246      24.21759
#>   psi_difference__heading psi_difference__speed psi_difference__temperature
#> 1              -0.5077982            -0.3291118                  0.90904774
#> 2              -2.4058310            -1.5507982                  8.81688350
#> 3              -2.0493536            -1.0275142                 -0.09263067
#> 4              -2.1343101            -1.3662193                  7.68330753
#> 5              -1.6262742            -1.3285644                 -0.49216006
#> 6              -3.2205662            -1.8176943                  6.86982348
#>   psi_difference__x psi_difference__y psi_only_with__heading
#> 1         1.0439052         1.1786874              0.9293573
#> 2         0.3620446         1.9124493              1.1155843
#> 3        10.7772503         3.6840683              1.3566257
#> 4         0.7987946         2.0023859              1.1480127
#> 5        16.1017892         0.5570026              1.4109647
#> 6        14.2495322         0.6506180              1.1893363
#>   psi_only_with__speed psi_only_with__temperature psi_only_with__x
#> 1             0.955402                   2.008057         2.155094
#> 2             1.209317                  10.223758         2.673254
#> 3             1.597839                   2.234667        12.581749
#> 4             1.298346                   9.080531         3.005894
#> 5             1.176044                   1.662959        17.494104
#> 6             1.348980                   8.837928        16.609433
#>   psi_only_with__y psi_without__heading psi_without__speed
#> 1         2.271520             1.437155           1.284514
#> 2         4.136535             3.521415           2.760115
#> 3         5.693895             3.405979           2.625354
#> 4         4.145123             3.282323           2.664565
#> 5         2.621730             3.037239           2.504608
#> 6         3.322656             4.409902           3.166674
#>   psi_without__temperature psi_without__x psi_without__y
#> 1                 1.099009       1.111188       1.092833
#> 2                 1.406874       2.311210       2.224086
#> 3                 2.327298       1.804499       2.009827
#> 4                 1.397224       2.207099       2.142738
#> 5                 2.155119       1.392314       2.064727
#> 6                 1.968105       2.359901       2.672038
```
