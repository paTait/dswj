## Tip3: Function with a ! in the name
a1 = [2,3,1,6,2,8]
sort!(a1)
a1
#6-element Array{Int64,1}:
# 1
# 2
# 2
# 3
# 6
# 8

## Tip 4
## Do not wrap abs() in an anonymous function
A = [1, -0.5, -2, 0.5]
map(x -> abs(x), A)

# Rather, do this
## abs() is not wrapped in an anonymous function
map(abs, A)

##Tip 5:  Type promotion
times1a(y) = *(y, 1)
times1b(y) = *(y, 1.0)
println("times1a(1/2): ", times1a(1/2))
println("times1a(2): ", times1a(2)) ## preserves type
println("times1a(2.0): ", times1a(2.0))
println("times1b(1/2): ", times1b(1/2))
println("times1b(2): ", times1b(2)) ## changes type
println("times1b(2.0): ", times1b(2.0))

## Tip6:  Function with typed arguments
times1c(y::Float64) = *(y, 1)
times1c(float(23))
