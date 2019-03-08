## sort at dataframe by 2 variables, one in ascending order
sort_obj = @from i in df_recipe begin
    @orderby i.y, descending(i.color)
    @select {i.y, i.color, i.ibu}
    @collect DataFrame
end

sort_obj

# 50562x3 DataFrame
# | Row   | y     | color    | ibu     |
# |       | Int64 | Float64  | Float64 |
# +-------+-------+----------+---------+
# | 1     | 0     | missing  | missing |
# | 2     | 0     | missing  | missing |
# :
# | 8     | 0     | 186.0    | missing |
# :
# | 50561 | 1     | 0.11     | 91.14   |
# | 50562 | 1     | 0.03     | missing | 
