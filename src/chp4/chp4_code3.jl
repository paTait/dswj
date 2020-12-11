using Gadfly, Cairo

## adds the dark theme to the top of themes stack
Gadfly.push_theme(:dark)

## create a df of means of each level of x2.
df_bc = by(df_1, :x2, nrow)
rename!(df_bc, :nrow => :count)

## Geom.bar to draw the bars
## Guide.ylabel to rename the Y label
p_bar = plot(df_bc, x=:x2, y=:count, Guide.ylabel("Count"), Geom.bar,
  style(bar_spacing=1mm))

## Dot plot
## same data different Geom
p_dot = plot(df_bc, y=:x2, x=:count, Guide.xlabel("Count"), Geom.point,
  Coord.cartesian(yflip = true))
