pkgname <- "flatr"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
base::assign(".ExTimings", "flatr-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('flatr')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
cleanEx()
nameEx("flatten_ct")
### * flatten_ct

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: flatten_ct
### Title: Flatten i*j*k contingency tables into tidy data.
### Aliases: flatten_ct

### ** Examples

flatten_ct(lung_cancer)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("flatten_ct", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("goodness_of_fit")
### * goodness_of_fit

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: goodness_of_fit
### Title: Calculate the Chi^2 and G^2 Statistics
### Aliases: goodness_of_fit

### ** Examples

lung_logit <-
  lung_cancer %>%
  flatten_ct() %>%
  glm(
    Lung ~ City + Smoking
    ,family = binomial
    ,data = .
  )

goodness_of_fit(model = lung_logit, response = "Lung", type = "Chisq")
lung_logit %>%
  goodness_of_fit(response = "Lung", type = "Gsq")
lung_cancer %>%
  flatten_ct() %>%
  glm(
    Lung ~ City + Smoking
    ,family = binomial
    ,data = .
  ) %>%
  goodness_of_fit(response = "Lung", type = "Chisq")




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("goodness_of_fit", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("lung_cancer")
### * lung_cancer

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: lung_cancer
### Title: Lung Cancer by whether or not a person smokes and City.
### Aliases: lung_cancer
### Keywords: datasets

### ** Examples

lung_cancer



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("lung_cancer", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
