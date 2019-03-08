using Query
## select lagers (y ==1) and pri_temp >20
x_obj = @from i in df_recipe begin
    @where i.y == 1 && i.pri_temp > 20
    @select {i.y, i.pri_temp, i.color}
    @collect DataFrame
end

typeof(x_obj)
# DataFrame

names(x_obj)
# Symbol[3]
# :y
# :pri_temp
# :color

size(x_obj)
# (333, 3)
