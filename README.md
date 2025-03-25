# lmPrettyPlot
Tiny R package for nice regression plots

## Installation
Version 0.1 of this package is currently available here on GitHub and may be installed by:

```r
library(remotes)
install_github("hgreatrex/lmPrettyPlot")
```

Or by using

```r
library(devtools)
install_github("hgreatrex/lmPrettyPlot")
```

## Functions

### Studentized residual vs fits, lmplot_student_fits()

#### Example 1: Using the built-in mtcars dataset

```r
data(mtcars)
model_mtcars <- lm(mpg ~ wt, data = mtcars)
lmplot_student_fits(model_mtcars)
```
