## boxplot
p_bp = plot(df_beer1,  x=:c3,  y =:color,  Geom.boxplot(),
  Guide.xlabel("Type of Beer"), Guide.ylabel("Color"))

p_bp2 = plot(df_beer,  x=:c3,  y =:color, Geom.boxplot(),
  Guide.xlabel("Type of Beer"), Guide.ylabel("Color"))

p_bp3 = plot(df_beer,  x=:c6,  y =:color, Geom.boxplot(),
  Guide.xlabel("Type of Beer"), Guide.ylabel("Color"))
