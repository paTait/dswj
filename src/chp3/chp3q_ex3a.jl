## data sink is dictionary
## select statement creates a Pair
dict_obj = @from i in df_recipe begin
    @where i.y == 1 && i.color <= 5.0
    @select i.id => get(i.color)
    @collect Dict
end

typeof(dict_obj)
# Dict{String,Float64}

dict_obj
# Dict String -> Float64 with 1898 entries
# "id16560" -> 3.53
# "id31806" -> 4.91
# "id32061" -> 3.66
