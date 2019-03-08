## A three-element row "vector"
a4 = [1,2,3]

## A 1x3 column vector -- a two-dimensional array
a5 = [1 2 3]

## A 2x3 matrix, where ; is used to separate rows
a6 = [80 81 82 ; 90 91 92]

## Notice that the array a4 does not have a second dimension, i.e., it is
## neither a 1x3 vector nor a 3x1 vector. In other words, Julia makes a
## distinction between Array{T,1} and Array{T,2}.
a4
# 3-element Array{Int64,1}:
# 1
# 2
# 3

## Arrays containing elements of a specific type can be constructed like:
a7 = Float64[3.0 5.0 ; 1.1 3.5]

## Arrays can be explicitly created like this:
Vector(undef, 3)
# 3-element Array{Any,1}:
# #undef
# #undef
# #undef

Matrix(undef, 2,2)
#  2x2 Array{Any,2}:
#  #undef  #undef
#  #undef  #undef

## A 3-element Float array
a3 = collect(Float64, 3:-1:1)
# 3-element Array{Float64,1}:
# 3.0
# 2.0
# 1.0
