## Hexbin plot

p_hexb = plot(df_beer, x=:color, y=:pri_temp, Geom.hexbin,
    Guide.xlabel("Color"), Guide.ylabel("Primary Temperature"),
    Scale.color_continuous(colormap=Scale.lab_gradient("blue", "white",
      "orange")))
