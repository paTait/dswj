using StatsBase, Random, Statistics
Random.seed!(46)

A1 = [10,27,31,40,46,50,52,104,146]
median(A1)
# 46.0

n = length(A1)
m = 100000
theta = zeros(m)

for i = 1:m
  theta[i] = median(sample(A1, n, replace=true))
end

mean(theta)
# 45.767
std(theta)
#12.918

## function to compute the bootstrap SE, i.e., an implementation of (5.11)
function boot_se(theta_h)
  m = length(theta_h)
  c1 = /(1, -(m,1))
  c2 = mean(theta_h)
  res = map(x -> (x-c2)^2, theta_h)
  return(sqrt(*(c1, sum(res))))
end

boot_se(theta)
## 12.918
