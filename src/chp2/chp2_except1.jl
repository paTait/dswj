## Generate an exception
log(-1)

# ERROR: DomainError with -1.0:
# log will only return a complex result if called with a complex argument. 
#  Try log(Complex(x)).
# Stacktrace:
#  [1] throw_complex_domainerror(::Symbol, ::Float64) at ./math.jl:31
#  [2] log(::Float64) at ./special/log.jl:285
#  [3] log(::Int64) at ./special/log.jl:395
#  [4] top-level scope at none:0
