## basic scatterplot
sp_1 = plot(df_1, x=:x4, y=:y, Geom.point )

## scatterplot with color coding and a non-linear smoother
sp_2 = plot(df_1, x=:x4, y=:y, color = :x2, Geom.point,
   Scale.color_discrete_manual("red","purple","blue"), 
   Geom.smooth(method=:loess,smoothing=0.5) )
