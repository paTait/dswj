reval("""source("./chp7_ranger.R")""")

## Prep data for R
## training data
y_tr = convert(Array{Float64}, df_train[:gpa])

sel_var = setdiff(names(df_train), [:gpa])
tmp = convert(Array, df_train[sel_var] )
x_tr =convert(Array{Float64}, collect(Missings.replace(tmp, 0)))
x_tr_df = convert(DataFrame, x_tr)
names!(x_tr_df, sel_var)

## testing data
y_tst = convert(Array{Float64}, df_test[:gpa])

sel_var = setdiff(names(df_test), [:gpa])
tmp = convert(Array, df_test[sel_var] )
x_tst =convert(Array{Float64}, collect(Missings.replace(tmp, 0)))
x_tst_df = convert(DataFrame, x_tst)
names!(x_tst_df, sel_var)
