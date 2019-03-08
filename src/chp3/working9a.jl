## a count of the levels of X2
## the counts are in column x1 of the dataframe returned from by()
by(df1, :X2, nrow )

# 3x2 DataFrame
# | Row | X2     | x1    |
# |     | String | Int64 |
# +-----+--------+-------+
# | 1   | Medium | 28    |
# | 2   | Low    | 11    |
# | 3   | High   | 11    |

## median of X3 by the levels of X2
by(df1, :X2, df -> DataFrame(Median = median(df[:X3])))

# 3x2 DataFrame
# | Row | X2     | Median  |
# |     | String | Float64 |
# +-----+--------+---------+
# | 1   | Medium | 1.21086 |
# | 2   | Low    | 1.19345 |
# | 3   | High   | 1.82011 |
