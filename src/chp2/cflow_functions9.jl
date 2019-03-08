## A function with a keyword argument
## Arguments after the ; are keyword arguments
## The default values are evaluated from left-to-right.
## This allows keyword arguments to refer to previously defined keywords
## Keyword arguments can have explicit types

## estimate the median of a 1D array  using an MM algorithm
## for clarity (too many m's!) we use an _ in the function name
function mm_median(x, eps = 0.001; maxit = 25, iter::Int64=Int(floor(eps)))

  ## initalizations
  psi = fill!(Vector{Float64}(undef,2), 1e2)

  while(true)
  	iter += 1
  	if iter == maxit
  		println("Max iteration reached at iter=$iter")
  		break
  	end
  	num, den = (0,0)
  	## use map() to do elementwise operations in wgt
    wgt = map(d -> (abs(d - psi[2]))^(-1), x)
	num = sum(map(*, wgt, x))
  	den = sum(wgt)
  	psi = circshift(psi, 1)
  	psi[2] = num / den

  	dif = abs(psi[2] - psi[1])
  	if dif < eps
  		print("Converged at iteration $iter")
  		break
  	end
  end

  return(Dict(
    "psi_vec" => psi,
	  "median" => psi[2]
  ))

end

## Run on simulated data
using Distributions, Random
Random.seed!(1234)

N = Int(1e3)
dat = rand(Normal(0,6), N)

## Function calls using different types of arguments
median(dat)
# 0.279

mm_median(dat, 1e-9)["median"]
# Max iteration reached at iter=25

mm_median(dat, maxit=50)["median"]
# Converged at iteration 26
# 0.296

mm_median(dat, 1e-9, maxit=100)["median"]
# Converged at iteration 36
# 0.288
