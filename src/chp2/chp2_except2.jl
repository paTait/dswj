## throw()

for i in [1, 2, -1, 3]
  if i < 0
    throw(DomainError())
  else
    println("i: $(log(i))")
  end
end

# i: 0.0
# i: 0.6931471805599453
# ERROR: MethodError: no method matching DomainError()
# Closest candidates are:
#   DomainError(::Any) at boot.jl:256
#   DomainError(::Any, ::Any) at boot.jl:257
# Stacktrace:
#  [1] top-level scope at ./none:3

## error
for i in [1, 2, -1, 3]
  if i < 0
    error("i is a negative number")
  else
    println("i: $(log(i))")
  end
end

# i: 0.0
# i: 0.6931471805599453
# ERROR: i is a negative number
# Stacktrace:
#   [1] top-level scope at ./none:3
