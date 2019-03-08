## Clustering the coffee data with PGMM
using DataFrames, RCall

## make a copy of the Julia coffee dataframe
## remove the Variety and Country columns before clustering
x = deepcopy(coffee_df)
delete!(x, [:Variety, :Country])
println("size(x): $(size(x))")
# size(x): (43, 12)

## Scale cols of x in R
x_scaled = rcall(:scale, x)

## load the pgmm library in R
reval("library(pgmm)")

## Run PGMM using pgmmEM() in R
## Note the parameter values are all defined in the Julia environment
pgmm_r = rcall(:pgmmEM, rG=2:3, rq=1:3, zstart=2, icl=true, x_scaled)

## change the RObject into a Julia dictionary
pgmm_j = rcopy(pgmm_r)
println("\n\ntypeof(pgmm_j): ", typeof(pgmm_j))
# typeof(pgmm_j): OrderedCollections.OrderedDict{Symbol,Any}

## print the dictionary keys
for (k,v) in pgmm_j
  println("pgmm_j: key: ", k)
end

##Make an new dataframe for the analysis
df_results = deepcopy(coffee_df[[:Variety, :Fat, :Caffine]])
df_results[:Map] = pgmm_j[:map]
println("names(df_results): $(names(df_results))")
# names(df_results): Symbol[:Variety, :Fat, :Caffine, :Map]

## classification table
ct1 = by(df_results, [:Map, :Variety], nrow)
ct1
# 2x3 DataFrame
# | Row | Map     | Variety | x1    |
# |     | Float64 | Float64 | Int64 |
# +-----+---------+---------+-------+
# | 1   | 1.0     | 1.0     | 36    |
# | 2   | 2.0     | 2.0     | 7     |
