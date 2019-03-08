## kernel density estimate
p_den = plot(df_1, x=:x1, Guide.ylabel("Density"),
  Geom.density(bandwidth=0.25), Guide.title("Bandwidth: 0.25"))

p_den2 = plot(df_1, x=:x1, Guide.ylabel("Density"),
  Geom.density(bandwidth=0.05), Guide.title("Bandwidth: 0.05"))

p_den3 = plot(df_1, x=:x1, Guide.ylabel("Density"),
  Geom.density(bandwidth=0.5), Guide.title("Bandwidth: 0.5"))
