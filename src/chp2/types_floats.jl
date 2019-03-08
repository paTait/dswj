## Some examples of floats

x1 = 1.0
x64 = 15e-5
x32 = 2.5f-4

typeof(x32)
# Float32

## digit separation using an _
9.2_4 == 9.24
# true

isnan(0/0)
# true
isinf(1/0)
# true
isinf(-11/0)
# true

y1 = 2*3
# 6
isnan(y1)
# false
isinf(y1)
# false

y2 = 2/0
# Inf
isnan(y2)
# false
isinf(y2)
# true
