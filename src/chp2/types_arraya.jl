## A vector of length 5 containing integers
a1 = Array{Int64}(undef, 5)

## A 2x2 matrix containing integers
a2 = Array{Int64}(undef, (2,2))
#2x2 Array{Int64,2}:
#493921239145  425201762420
#416611827821           104

## A 2x2 matrix containing Any type
a2 = Array{Any}(undef, (2,2))
#2x2 Array{Any,2}:
# #undef  #undef
# #undef  #undef
