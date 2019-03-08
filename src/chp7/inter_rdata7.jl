using RCall, Distributions, StatsBase, Random
Random.seed!(636)

# Simulate data for logistic regression
N = 1000
x1 = randn(N)
x2 = randn(N)
x0 = fill(1.0, N)

# A linear function of x1 and x2
lf = x0 + 0.5*x1 + 2*x2

# The inv-logit function of lf
prob =  1 ./ ( x0+ exp.(-lf))

# Generate y
y = zeros(Int64, N)
for i = 1:N
  y[i] = rand(Binomial(1, prob[i]), 1)[1]
end

# Run code in R
# Note that x3 is generated in R (randomly from a normal distribution) but
# x1 and x2 are sent from Julia to R
R"""
set.seed(39)
n <- length($x1)
df <- data.frame(x.1 = $x1, x.2 = $x2, y = $y, x.3 = rnorm(n))
fit1 <- glm(y ~ x.1 + x.2 + x.3, data = df, family = "binomial")
summary(fit1)
"""
# Coefficients:
#             Estimate Std. Error z value Pr(>|z|)
# (Intercept)  0.86586    0.09077   9.540  < 2e-16 ***
# x.1          0.46455    0.08640   5.377 7.57e-08 ***
# x.2          1.86382    0.12481  14.934  < 2e-16 ***
# x.3          0.14940    0.08521   1.753   0.0795 .


# Odds ratios for x1 and x2, respectively
exp(0.46455)
# 1.592
exp(1.86382)
# 6.448
