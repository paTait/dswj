## Returns an array of Float64 values
a1_obj = @from i in df_recipe begin
    @where i.y == 1 && i.color <= 5.0
    @select get(i.color) #Float64[1916]
    @collect
end

a1_obj
# 1898-element Array{Float64,1}:
#  3.3
#  2.83
#  2.1

## Returns a Named Tuple array. Each row is a NT with col and ibu values
a2_obj = @from i in df_recipe begin
    @where i.y == 1 && i.color <= 5.0
    @select {col = i.color, ibu = i.ibu}
    @collect
end

a2_obj
# 1898-element Array{NamedTuple{(:col, :ibu),Tuple{DataValues.DataValue{
#  Float64},DataValues.DataValue{Float64}}},1}:
#  (col = DataValue{Float64}(3.3), ibu = DataValue{Float64}(24.28))
#  (col = DataValue{Float64}(2.83), ibu = DataValue{Float64}(29.37))

## Additional processing to return an Array of floats
N = size(a2_obj)[1]
a2_array =zeros(N, 2)
for (i,v) in enumerate(a2_obj)
    a2_array[i, 1] = get(a2_obj[i][:col],0)
    a2_array[i, 2] = get(a2_obj[i][:ibu],0)
end

a2_array
# 1898x2 Array{Float64,2}:
#  3.3   24.28
#  2.83  29.37
