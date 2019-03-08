## Overall data
df_oa = append!(ranger_tr, ranger_tst)

## best test set parameterization
best_ranger_r = rcall(:ranger, "gpa ~ .", data = df_oa, mtry= 15,
  var"num.trees" = 5000, var"min.node.size" = 10,
  splitrule = "extratrees", importance = "impurity")

## Variable Importance
br_imp_r = rcall(:importance, best_ranger_r)

## rcopy does not preserve the names
br_imp_j = DataFrame(varname =  map(x -> string(x), names(br_imp_r)),
    vi = rcopy(br_imp_r) )

## sort by variable importance
sort!(br_imp_j, :vi, rev=true)
