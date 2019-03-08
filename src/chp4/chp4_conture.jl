## Multivariate Normal parameters
N=1000
S = [2.96626 1.91; 1.91  2.15085]
mu = [0,5]

## contour plot of MVN over grid -10 to 10
ct_p = plot(z=(x,y) ->  pdf(MvNormal(mu, S), [x, y]),
  x=range(-10, stop=10, length=N),
  y=range(-10, stop=10, length=N),
  Geom.contour)
