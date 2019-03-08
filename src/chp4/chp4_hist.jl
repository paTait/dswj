## histogram
p_hist = plot(df_1, x=:x1, Guide.ylabel("Count"),
  Geom.histogram(bincount=10), style(bar_spacing=1mm))
