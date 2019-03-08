## Number of entries for the categorical arrays
Nca = 10

## Empty array
v3 = Array{Union{String, Missing}}(undef, Nca)

## Array has string and missing values
v3 = [isodd(i) ? sample(["High", "Low"], pweights([0.35,0.65])) :
        missing for i = 1:Nca]

## v3c is of type CategoricalArray{Union{Missing, String},1,UInt32}
v3c = categorical(v3)

## Levels should be ["High", "Low"]
println("1. levels(v3c): ", levels(v3c))
# 1. levels(v3c): ["High", "Low"]

## Reordered levels - does not change the data
levels!(v3c, ["Low", "High"])
println("2. levels(v3c):", levels(v3c))
# 2. levels(v3c): ["Low", "High"]

println("2. v3c: ", v3c)
# 2. v3c: Union{Missing, CategoricalString{UInt32}}
# ["High", missing, "Low", missing, "Low", missing, "High", 
# missing, "Low", missing]
