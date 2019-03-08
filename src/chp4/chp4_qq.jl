p_qq1 = plot(df_1,  y=:x3,  x = rand(Pareto(2, 1), N), Stat.qq, Geom.point,
  Geom.abline(color="green", style=:dash), Guide.ylabel("Quantiles of X3"),
  Guide.xlabel("Quantiles of Pareto(2,1) Distribution"))

p_qq2 = plot(df_1, x=:x3, y = :x1, Stat.qq, Geom.point,
  Guide.xlabel("Quantiles of X3"),   Guide.ylabel("Quantiles of X1"))
