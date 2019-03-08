## lower triangular correlation matrix
using LinearAlgebra

cor_mat = LowerTriangular(cor(
  convert(Array{Float64}, df_1[[:x1, :x3, :x4, :y]])
))

## convert cor_mat into a dataframe for GadFly
df_cor = DataFrame(cor_mat)
rename!(df_cor, [:x4 => :y, :x3 => :x4, :x2 => :x3])
df_cor = stack(df_cor)
df_cor[:variable2] = repeat(["x1", "x3", "x4", "y"], outer=4)

## plot the heatmap
p_hm = plot(df_cor, x=:variable2, y = :variable, color=:value,
  Geom.rectbin, Guide.colorkey(title = "Correlation"),
  Scale.color_continuous(colormap=Scale.lab_gradient("blue", "white",
  "orange"), minvalue=-1, maxvalue=1) )
