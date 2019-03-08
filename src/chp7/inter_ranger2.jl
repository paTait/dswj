## train the ranger model using 5-fold CV and 1000 trees
rf_tr_j1 = rcopy(
  rcall(:train, x_tr_df, y_tr , method = "ranger",
        trControl = Symbol("trainParam"),
        tuneGrid = Symbol("rfParam"),
        var"num.trees" = 500)
  )[:results]

## add the standard errors for the CV error
## used in the plots
rf_tr_j1[:MedAE_se] =  map(x -> x / sqrt(5), rf_tr_j1[:MedAESD])
rf_tr_j1[:MedAE_min] = map(-, rf_tr_j1[:MedAE], rf_tr_j1[:MedAE_se])
rf_tr_j1[:MedAE_max] = map(+, rf_tr_j1[:MedAE], rf_tr_j1[:MedAE_se])

min_medae = minimum(rf_tr_j1[:MedAE])
min_err = filter(row -> row[:MedAE] == min_medae ,rf_tr_j1)

## apply the 1 SE method
one_se = min_err[1, :MedAE_max]
possible_models = filter(row -> row[:MedAE] <= one_se, rf_tr_j1)
