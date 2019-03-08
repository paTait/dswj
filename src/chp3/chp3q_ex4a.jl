## Flattening a dictionary
df_obj = @from i in dict_obj begin
    @from j in i.second
    @select {ID = i.first, Color = j}
    @collect DataFrame
end

df_obj
# 8739x2 DataFrames.DataFrame
# | Row  | ID      | Color |
# +------+---------+-------+
# | 1    | id23618 | 3.86  |
# | 2    | id10393 | 3.41  |
# | 3    | id6094  | 3.79  |

## flattening a tuple
tup_obj = @from i in df_recipe begin
    @select (get(i.size), get(i.ibu))
    @collect
end

tup_obj
# 50562-element Array{Tuple{Float64,Float64},1}:
#  (21.77, 17.65)
#  (18.93, 59.25)
#  (22.71, 54.48)

df2_obj = @from i in tup_obj begin
    @from j in i[2]
    @select {Size = i[1], IBU = j}
    @collect DataFrame
end

df2_obj
# 50562x2 DataFrames.DataFrame
# | Row | Size  | IBU   |
# +-----+-------+-------+
# | 1   | 21.77 | 17.65 |
# | 2   | 18.93 | 59.25 |
# | 3   | 22.71 | 54.48 |
