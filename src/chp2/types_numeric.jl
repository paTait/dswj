## Some examples of the Int type

# Integers
literal_int = 1
println("typeof(literal_int): ", typeof(literal_int))
# typeof(literal_int): Int64

# Boolean values
x = Bool(0)
y = Bool(1)

## Integer overflow error
x = typemax(Int64)
# 9223372036854775808
x += 1
# -9223372036854775807
x == typemax(Int64)
#false

## Integer underflow error
x = typemin(Int64)
# -9223372036854775808
x -= 1
# 9223372036854775807
x == typemin(Int64)
#false
