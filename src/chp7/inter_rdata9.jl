# Use reval() to pull the simulated data into Julia
# df is the R dataframe used to produce the glm object fit1
# df contains the data we simulated in Julia and sent to R via the R""
# string macro

df_r = reval("df")

# Then, use rcall() to run the lm() function in R
# note that df_r is in the Julia environment and is being passed back to R
lm_r = rcall(:lm, "x.1 ~ y", df_r)
# or
lm_r = rcall(:lm, "as.formula('x.1~y')", df_r)

# Rather than using reval() followed by rcopy(), they can be used
# in conjuction
lm_df = rcopy(reval("summary(lm(x.1 ~ y, df))\$coefficients"))

print("typeof(lm_df): $(typeof(lm_df))")
# typeof(lm_df): Array{Float64,2}
