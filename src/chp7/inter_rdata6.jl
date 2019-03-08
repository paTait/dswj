## Here, the Julia variable is not used
## The data in the  index field is returned
index = [1,2,5]
print(R"MASS::crabs$index")
# RCall.RObject{RCall.IntSxp}
#  [1]  1  2  3  4  ..

## Here, the Julia variable is used
R"MASS::crabs[$index, ]"
# RCall.RObject{RCall.VecSxp}
#   sp sex index  FL  RW   CL   CW  BD
# 1  B   M     1 8.1 6.7 16.1 19.0 7.0
# 2  B   M     2 8.8 7.7 18.1 20.8 7.4
# 5  B   M     5 9.8 8.0 20.3 23.0 8.2
