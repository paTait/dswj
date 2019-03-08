## Create a 2x2 identity matrix
using LinearAlgebra
imat = Matrix{Int8}(I, (2,2))

## return random numbers between 0 and 1
rand(2)
#2-element Array{Float64,1}:
# 0.86398
# 0.491484

B = [80 81 82 ; 90 91 92]
# 2x3 Array{Int64,2}:
# 80  81  82
# 90  91  92

## return random elements of B
rand(B,2)
#2-element Array{Int64,1}:
# 80
# 91

## The number of elements in B
length(B)
# 6

## The dimensions of B
size(B)
# (2, 3)

## The number of dimensions of B
ndims(B)
# 2

## A new array with the same elements (data) as B but different dimensions
reshape(B, (3, 2))
# 3x2 Array{Int64,2}:
#  80  91
#  90  82
#  81  92

## A copy of B, where elements are recursively copied
B2 = deepcopy(B)

## When slicing, a slice is specified for each dimension
## The first two rows of the first column done two ways
B[1:2, ]
# 2-element Array{Int64,1}:
#  80
#  90

B[1:2,1]

## The first two rows of the second column
B[1:2,2]
# 2-element Array{Int64,1}:
# 81
#  91

## The first row
B[1,:]
# 3-element Array{Int64,1}:
#  80
#  81
#  82

## The third element
B[3]
#81

# Another way to build an array is using comprehensions
A1 = [sqrt(i) for i in [16,25,64]]
# 3-element Array{Float64,1}:
# 4.0
# 5.0
# 8.0

A2 = [i^2 for i in [1,2,3]]
# 3-element Array{Int64,1}:
#  1
#  4
#  9
