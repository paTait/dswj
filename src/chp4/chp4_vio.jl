## Violin plots
p_vio = plot(df_beer1,  x=:c3,  y =:pri_temp, Geom.violin,
  Guide.xlabel("Type of Beer"), Guide.ylabel("Primary Temperature"))

p_vio2 = plot(df_beer1,  x=:c3,  y =:color, Geom.violin,
  Guide.xlabel("Type of Beer"),  Guide.ylabel("Color"))

p_vio3 = plot(df_beer,  x=:c3,  y =:color, Geom.violin,
  Guide.xlabel("Type of Beer"),  Guide.ylabel("Color"))

p_vio4 = plot(df_beer,  x=:c6,  y =:color, Geom.violin,
  Guide.xlabel("Type of Beer"),  Guide.ylabel("Color"))
