using RCall

# Perform a Chi squared test using R fundtion chisq.test()
x = Int[10,39,50,24]
R"chisq.test($x)"

# RObject{VecSxp}
#
#     Chi-squared test for given probabilities
#
# data:  `#JL`$x
# X-squared = 29.748, df = 3, p-value = 1.559e-06
