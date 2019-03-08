## create data in R
reval("""data(crabs, package = "MASS")
  df.pca <- subset(crabs, select = -c(sp, sex, index))""")

## rcall() using both the var_str macro and Symbol constructor
prcomp_r = rcall(:prcomp, Symbol("df.pca"), center = true,
  var"scale." = true)
