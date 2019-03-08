## Example of an infinite while loop (nothing inside the loop can falsify
## the condition x<10)
n=0
x=1
while x<10:
  global n
  n=n+1
end

## A while loop to estimate the median using an MM algorithm
  using Distributions, Random
  Random.seed!(1234)

  iter = 0
  N = 100
  x = rand(Normal(2,1), N)
  psi = fill!(Vector{Float64}(undef,2), 1e9)

  while(true)
	  global iter, x, psi
	  iter += 1
	  if iter == 25
		  println("Max iteration reached at iter=$iter")
          break
	  end
 	  num, den = (0,0)
	  ## elementwise operations in wgt
	  wgt = (abs.(x .- psi[2])).^-1
	  num = sum(wgt .* x)
	  den = sum(wgt)
	  psi = circshift(psi, 1)
	  psi[2] = num / den

	  dif = abs(psi[2] - psi[1])
	  if dif < 0.001
		  print("Converged at iteration $iter")
		  break
	  end
  end

  # gives an estimate of the median
  median(x)
  # 1.959

  psi[2]
  # 1.956
