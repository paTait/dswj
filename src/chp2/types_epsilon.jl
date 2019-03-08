## Some examples of machine epsilon

eps()
# 2.220446049250313e-16

## spacing between a floating point number x and adjacent number is
## at most eps * abs(x)

n1 =[1e-25, 1e-5, 1., 1e5, 1e25]

for i in n1
  println( *(i, eps() ))
end
# 2.2204460492503132e-41
# 2.2204460492503133e-21
# 2.220446049250313e-16
# 2.220446049250313e-11
# 2.2204460492503133e9
