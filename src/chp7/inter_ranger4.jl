## Test set performance

## ranger predict() needs one DF with outcome and predictors
ranger_tr = deepcopy(x_tr_df)
ranger_tr[:gpa] = y_tr
ranger_tst = deepcopy(x_tst_df)
ranger_tst[:gpa] = y_tst

## empty df to hold results
tst_results = DataFrame(
  mtry = Float64[],
  min_node_size = Float64[],
  splitrule = String[],
  medae = Float64[],
  rmse = Float64[])

## call ranger and make the predictions
tmp_ranger =  rcall(:ranger, "gpa ~ .", data = ranger_tr, mtry= 15,
  var"num.trees" = 5000, var"min.node.size" = 10,
  splitrule = "extratrees")
tmp_pred = rcopy(rcall(:predict, tmp_ranger, ranger_tst))[:predictions]

## consolidate the results
tmp_array = [15, 10, "extratrees",
             medae(tmp_pred, y_tst), rmse(tmp_pred, y_tst)]
push!(tst_results, tmp_array)
