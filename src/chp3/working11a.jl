## keep the grouping variable X2  and Y
keep2 = setdiff(names(df1), [:X1, :X3])

## agg_res has the summary statistics by levels of X2
## MAD = median absolute deviation
agg_res = aggregate(df1[keep2], [:X2],[length, mean, std, median, mad])
rename!(agg_res, :Y_length => :Y_n)
agg_res

# 3x6 DataFrame
# | Row | X2     | Y_n   | Y_mean   | Y_std    | Y_median | Y_mad    |
# |     | String | Int64 | Float64  | Float64  | Float64  | Float64  |
# +-----+--------+-------+----------+----------+----------+----------+
# | 1   | Medium |  28   | 3.22175  | 1.70015  | 2.42171  | 0.473198 |
# | 2   | Low    |  11   | 0.692063 | 0.208037 | 0.596726 | 0.109055 |
# | 3   | High   |  11   | 8.01621  | 3.65864  | 7.28043  | 3.39415  |
