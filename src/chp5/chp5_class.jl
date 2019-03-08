## 80/20 split
splt = 0.8
y_1_ind = N_array[df_recipe[:y] .== 1]
y_0_ind = N_array[df_recipe[:y] .== 0]

tr_index = sort(
  vcat(
    sample(y_1_ind, Int64(floor(*(N_y_1, splt))), replace = false),
    sample(y_0_ind, Int64(floor(*(N_y_0, splt))), replace = false)
  )
)
tst_index = setdiff(N_array, tr_index)

df_train = df_recipe[tr_index, :]
df_test = df_recipe[tst_index, :]

## Check proportions
println("train: n y: $(sum(df_train[:y]))")
println("train: % y: $(mean(df_train[:y]))")
println("test: n y: $(sum(df_test[:y]))")
println("test: % y: $(mean(df_test[:y]))")

## Static boosting parameters

param_cv = [
  "silent" => 1,
  "verbose" => 0,
  "booster" => "gbtree",
  "objective" => "binary:logistic",
  "save_period" => 0,
  "subsample" => 0.75,
  "colsample_bytree" => 0.75,
  "alpha" => 0,
  "lambda" => 1,
  "gamma" => 0
 ]

## training data: predictors are sparse matrix
tmp = convert(Array, df_train[setdiff(names(df_train), [:y])] )
xmat_tr = convert(SparseMatrixCSC{Float64,Int64},
                      collect(Missings.replace(tmp, 0)))

## CV Results

## eta shrinks the feature weights to help prevent overfilling by making
## the boosting process more conservative
## max_depth is the maximum depth of a tree; increasing this value makes
## the boosting process more complex
tunegrid = tunegrid_xgb([0.1, 0.25, 0.5, 0.75, 1], 5)
N_tr = size(xmat_tr)[1]

cv_res = cvResult_xgb(xmat_tr, y_tr, param_cv, tunegrid,
  k = 5, n = N_tr, trace = true )

## dataframe for plotting
cv_df = DataFrame(tree_depth = cv_res[:, 1],
  eta = cv_res[:, 2],
  mean_error = cv_res[:, 3],
  sd_error = cv_res[:, 4],
)
cv_df[:se_error] = map(x -> x / sqrt(5), cv_df[:sd_error])
cv_df[:mean_min] = map(-, cv_df[:mean_error], cv_df[:se_error])
cv_df[:mean_max] = map(+, cv_df[:mean_error], cv_df[:se_error])

## configurations within 1 se
min_dev = minimum(cv_df[:mean_error])
min_err = filter(row -> row[:mean_error] == min_dev, cv_df)
one_se = min_err[1, :mean_max]
possible_models = filter(row -> row[:mean_error] <= one_se, cv_df)

#####
## Test Set Predictions

tst_results = DataFrame(
 eta = Float64[],
 tree_depth = Int64[],
 mcr = Float64[],
 dev = Float64[])

## using model configuration selected above
pred_tmp = XGBoost.predict(xgboost(xmat_tr, 1000, label = y_tr,
  param = param_cv, eta =0.1 , max_depth = 2), xmat_tst)
tmp = [0.1, 2, binary_mcr(pred_tmp, y_tst), binomial_dev(pred_tmp, y_tst)]
push!(tst_results, tmp)

#####
## Variable importance from the overall data

fit_oa = xgboost(xmat_oa, 1000, label = y_oa, param = param_cv, eta = 0.1,
  max_depth = 2)

## names of features
names_oa =  map(string, setdiff(names(df_recipe), [:y]))
fit_oa_imp = importance(fit_oa, names_oa)

## DF for plotting
N_fi = length(fit_oa_imp)

imp_df = DataFrame(fname = String[], gain = Float64[], cover = Float64[])

for i = 1:N_fi
    tmp = [fit_oa_imp[i].fname, fit_oa_imp[i].gain, fit_oa_imp[i].cover]
    push!(imp_df, tmp)
end

sort!(imp_df, :gain, rev=true)
