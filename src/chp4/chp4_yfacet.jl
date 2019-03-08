p_hexb2 = plot(df_beer1, x=:color, y=:pri_temp,  ygroup =:c3,
   Geom.subplot_grid(Geom.hexbin),
   Guide.xlabel("Color"), Guide.ylabel("Primary Temperature"),
   Scale.color_continuous(
      colormap=Scale.lab_gradient("blue", "white", "orange")
   )
)
