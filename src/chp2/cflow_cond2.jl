# A short-circuit evaluation
b= 10; c = 20;
println("SCE: b < c: ", b < c ? "less than" : "not less than")

# A short-circuit evaluation with nesting
d = 10; f = 10;
println("SCE: chained d vs e: ",
  d < f ? "less than " :
  d > f ? "greater than" : "equal")

# Note that we do not use e in the above example because it is a literal
# in Julia (the exponential function); while it can be overwritten, it is
# best practice to avoid doing so.
e
# ERROR: UndefVarError: e not defined
using Base.MathConstants
e
# e = 2.7182818284590...
