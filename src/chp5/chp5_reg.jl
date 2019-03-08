## 80/20 train test split
splt = 0.8

tr_index = sample(N_array, Int64(floor(*(N, splt))), replace = false)
tst_index = setdiff(N_array, tr_index)

df_train = df_food[tr_index, :]
df_test = df_food[tst_index, :]

## train data: predictors are sparse matrix
y_tr = convert(Array{Float64}, df_train[:gpa])
tmp = convert(Array, df_train[setdiff(names(df_train), [:gpa])] )
xmat_tr = convert(SparseMatrixCSC{Float64,Int64}, 
 collect(Missings.replace(tmp, 0)))

## Static boosting parameters
param_cv_reg = [
 "silent" => 1,
 "verbose" => 0,
 "booster" => "gbtree",
 "objective" => "reg:linear",
 "save_period" => 0,
 "subsample" => 0.75,
 "colsample_bytree" => 0.75,
 "lambda" => 1,
 "gamma" => 0
]

## CV Results

## eta shrinks the feature weights to help prevent overfilling by making
## the boosting process more conservative
## max_depth is the maximum depth of a tree; increasing this value makes
## the boosting process more complex
## alpha is an L1 regularization term on the weights; increasing this value 
## makes the boosting process more conservative
tunegrid = tunegrid_xgb_reg([0.1, 0.3, 0.5], 5, [0.1, 0.3, 0.5])
N_tr = size(xmat_tr)[1]

cv_res_reg = cvResult_xgb_reg(xmat_tr, y_tr, param_cv_reg, tunegrid,
 k = 5, n = N_tr, trace = true )

## add the standard error
cv_res_reg = hcat(cv_res_reg, ./(cv_res_reg[:,5], sqrt(5)))

## dataframe for plotting
cv_df_r = DataFrame(tree_depth = cv_res_reg[:, 1],
  eta = cv_res_reg[:, 2],
  alpha = cv_res_reg[:, 3],
  medae = cv_res_reg[:, 4],
  medae_sd = cv_res_reg[:, 5]
)
cv_df_r[:medae_se] = map(x -> /(x , sqrt(5)), cv_df_r[:medae_sd])
cv_df_r[:medae_min] = map(-, cv_df_r[:medae], cv_df_r[:medae_se])
cv_df_r[:medae_max] = map(+, cv_df_r[:medae], cv_df_r[:medae_se])

min_medae = minimum(cv_df_r[:medae])
min_err = filter(row -> row[:medae] == min_medae, cv_df_r)
one_se = min_err[1, :medae_max]

#######
## Test Set Predictions

tst_results = DataFrame(
  eta = Float64[],
  alpha = Float64[],
  tree_depth = Int64[],
  medae = Float64[],
  rmse = Float64[])

## using configuration chosen above
pred_tmp = XGBoost.predict(xgboost(xmat_tr, 1000, label = y_tr,
  param = param_cv_reg, eta =0.1 , max_depth = 1, alpha = 0.1), xmat_tst)
tmp = [0.1, 0.1, 1, medae(pred_tmp, y_tst), rmse(pred_tmp, y_tst)]
push!(tst_results, tmp)

#####
## Variable Importance from the overall data

fit_oa = xgboost(xmat_oa, 1000, label = y_oa, param = param_cv_reg,
  eta = 0.1, max_depth = 1, alpha = 0.1)

## names of features
# names_oa = convert(Array{String,1}, names(df_food))
names_oa = map(string, setdiff(names(df_train), [:gpa]))
fit_oa_imp = importance(fit_oa, names_oa)

## DF for plotting
N_fi = length(fit_oa_imp)

imp_df = DataFrame(fname = String[], gain = Float64[], cover = Float64[])

for i = 1:N_fi
    tmp = [fit_oa_imp[i].fname, fit_oa_imp[i].gain, fit_oa_imp[i].cover]
    push!(imp_df, tmp)
end

sort!(imp_df, :gain, rev=true)
