## Some examples with DataFrames

using DataFrames, Distributions, StatsBase, Random

Random.seed!(825)

N = 50

## Create a sample dataframe
## Initially the DataFrame has N rows and 3 columns
df1 = DataFrame(
  x1 = rand(Normal(2,1), N),
  x2 = [sample(["High", "Medium", "Low"],
              pweights([0.25,0.45,0.30])) for i=1:N],
  x3 = rand(Pareto(2, 1), N)
 )

## Add a 4th column, y, which is dependent on x3 and the level of x2
df1[:y] = [df1[i,:x2] == "High" ? *(4, df1[i, :x3]) :
               df1[i,:x2] == "Medium" ? *(2, df1[i, :x3]) :
                  *(0.5, df1[i, :x3])  for i=1:N]
