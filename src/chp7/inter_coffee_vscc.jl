## Clustering and (explicit) variable reduction for the coffee
## data with VSCC

# This builds on the previous code block and we expect certain objects
#  to be initialized, such as x_scaled

reval("library(vscc)")

## run vscc on the scaled data in R and copy the results into a Julia
## dictionary
vscc_j = rcopy(rcall(:vscc, x_scaled))

## Array containing the best data columns
## Fat and Free Acid were identified
vscc_ts = vscc_j[:topselected]

## MAP classifications from the best VSCC model
vscc_map = vscc_j[:bestmodel][:classification]
df_results[:vscc_MAP] = vscc_map

## classification table
ct2 = by(df_results, [:vscc_MAP, :Variety], nrow)
ct2
# 2x3 DataFrame
# | Row | vscc_MAP | Variety | x1    |
# |     | Float64  | Float64 | Int64 |
# +-----+----------+---------+-------+
# | 1   | 1.0      | 1.0     | 36    |
# | 2   | 2.0      | 2.0     | 7     |

## updating the analysis dataframe from pgmm with
## the missing variable selected by VSCC
df_results[:Free_Acid] = coffee_df[:Free_Acid]
