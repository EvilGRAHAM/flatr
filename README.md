<!-- README.md is generated from README.Rmd. Please edit that file -->
flatr <img src="man/figures/logo.png" align="right" />
======================================================

[![Travis-CI Build Status](https://travis-ci.org/EvilGRAHAM/flatr.svg?branch=master)](https://travis-ci.org/EvilGRAHAM/flatr)

Overview
--------

`flatr` is a package designed to make the analysis of contingency tables easier.

Contingency tables are a popular means of presenting categorical data in textbooks, as they take up very little space, while still allowing to present all the data. However, this means makes it tough to run analysis on them. `flatr` helps ease this pain by turning *i* × *j* × *k* contingency tables into "tidy" data.

Functions
---------

-   `flatten_ct()` takes an *i* × *j* × *k* contingency table, and turns it into a tibble.

-   `goodness_of_fit()` takes a logistic or probit regression model, and does a *χ*<sup>2</sup> Goodness of Fit Test. The test statistic is one of:

-   ![Chi Squared Equation](https://latex.codecogs.com/gif.latex?%5Cchi%5E%7B2%7D%20%3D%20%5Csum_%7B%5Cforall%20i%2Cj%7D%5Cfrac%7B%5Cleft%28%20O_%7Bi%2Cj%7D%20-%20E_%7Bi%2Cj%7D%20%5Cright%29%5E%7B2%7D%7D%7BE_%7Bi%2Cj%7D%7D)

-   ![G Squared Equation](https://latex.codecogs.com/gif.latex?G%5E%7B2%7D%20%3D%202%5Csum_%7B%5Cforall%20i%2Cj%7DO_%7Bi%2Ci%7D%20%5Cln%5Cleft%28%20%5Cfrac%7BO_%7Bi%2Ci%7D%7D%7BE_%7Bi%2Ci%7D%7D%20%5Cright%29)

Tidy Data
---------

`flatr` is designed to work with the [tidyverse](https://www.tidyverse.org/) series of packages. Tidy data is data in a "long" format, where each variable has its own column.

Usage
-----

|  Beijing| Lung |     |
|--------:|------|-----|
|  Smoking| Yes  | No  |
|      Yes| 126  | 100 |
|       No| 35   | 61  |

|  Shanghai| Lung |     |
|---------:|------|-----|
|   Smoking| Yes  | No  |
|       Yes| 908  | 688 |
|        No| 497  | 807 |

|  Shenyang| Lung |     |
|---------:|------|-----|
|   Smoking| Yes  | No  |
|       Yes| 913  | 747 |
|        No| 336  | 598 |

|  Nanjing| Lung |     |
|--------:|------|-----|
|  Smoking| Yes  | No  |
|      Yes| 235  | 172 |
|       No| 58   | 121 |

|   Harbin| Lung |     |
|--------:|------|-----|
|  Smoking| Yes  | No  |
|      Yes| 402  | 308 |
|       No| 121  | 215 |

|  Zhengzhou| Lung |     |
|----------:|------|-----|
|    Smoking| Yes  | No  |
|        Yes| 182  | 156 |
|         No| 72   | 98  |

|  Taiyuan| Lung |     |
|--------:|------|-----|
|  Smoking| Yes  | No  |
|      Yes| 60   | 99  |
|       No| 11   | 43  |

|  Nanchang| Lung |     |
|---------:|------|-----|
|   Smoking| Yes  | No  |
|       Yes| 104  | 89  |
|        No| 21   | 36  |

``` r
lung_tidy <- flatten_ct(lung_cancer)
lung_tidy
#> # A tibble: 8,419 x 3
#>    Smoking   Lung    City
#>     <fctr> <fctr>  <fctr>
#>  1       Y      Y Beijing
#>  2       Y      Y Beijing
#>  3       Y      Y Beijing
#>  4       Y      Y Beijing
#>  5       Y      Y Beijing
#>  6       Y      Y Beijing
#>  7       Y      Y Beijing
#>  8       Y      Y Beijing
#>  9       Y      Y Beijing
#> 10       Y      Y Beijing
#> # ... with 8,409 more rows

lung_logit <- glm(Lung ~ Smoking + City, family = binomial, data = lung_tidy)
goodness_of_fit(model = lung_logit, response = "Lung", type = "Chisq")
#> 
#> Chi-squared Goodness of Fit Test 
#> 
#> model: lung_logit 
#> Chi-squared = 5.19987, df = 7, p-value = 0.63559

lung_tidy %>% 
  glm(
    Lung ~ Smoking + City
    ,family = binomial(link = "probit")
    ,data = .
  ) %>% 
  goodness_of_fit(response = "Lung", type = "Gsq")
#> 
#> G-squared Goodness of Fit Test 
#> 
#> model: . 
#> G-squared = 5.15871, df = 7, p-value = 0.6406
```
