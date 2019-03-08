## single variable ecdf plot
ecdf_p1 = plot(df_ecdf, x = :color,
  y = ecdf(df_ecdf[:color])(df_ecdf[:color]),
   Geom.step,  yintercept=[0.5, 0.75, 0.95],
   Geom.hline(style = :dot, color = "gray"),
   Guide.yticks(ticks = [0,0.5, 0.75, 0.95, 1]),
   Guide.xlabel("Color"), Guide.ylabel("Fraction of Data"))

## ecdf plot by beer type
## dataframe of data and percentiles by labels
df_p = by(df_ecdf, :label, df -> DataFrame(
                  e_cdf = ecdf(df[:color])(df[:color]), col = df[:color]))

ecdf_p2 = plot(df_p, y = :e_cdf, x = :col, color = :label, Geom.step,
  yintercept=[0.5, 0.75, 0.95], Geom.hline(style = :dot, color = "gray"),
  Guide.yticks(ticks = [0,0.5, 0.75, 0.95, 1]), Guide.xlabel("Color"),
  Guide.ylabel("Fraction of Data"), Guide.colorkey(title = "Type of Beer"),
  Scale.color_discrete_manual("cyan", "darkorange", "magenta"))
