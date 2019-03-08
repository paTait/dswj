## dataframe of beer labels
beer_style = DataFrame(id = 0:1, beername = ["Ale","Lager"])

## inner join
j1_obj = @from i in df_recipe begin
    @join j in beer_style on i.y equals j.id
    @select {i.y, j.beername}
    @collect DataFrame
end

j1_obj
# 50562x2 DataFrame
# | Row   | y     | beername |
# |       | Int64 | String   |
# +-------+-------+----------+
# | 1     | 0     | Ale      |
# | 2     | 0     | Ale      |
# | 3     | 0     | Ale      |
# :
# | 50562 | 0     | Ale      |
