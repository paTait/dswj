using Statistics, StatsBase

## all missing values are skipped in the calculations
## Use a typed const to ensure type inference occurs correctly
const cs_dict = Dict{String, Float64}()
push!(cs_dict, "m_color" =>  mean(skipmissing(df_recipe[:color])))
push!(cs_dict, "m_ibu" =>  mean(skipmissing(df_recipe[:ibu])))
push!(cs_dict, "sd_color" =>  std(skipmissing(df_recipe[:color])))
push!(cs_dict, "sd_ibu" => std(skipmissing(df_recipe[:ibu])))

## mean center and scale a column and return as array
s1_obj = @from i in df_recipe begin
    @let ibu_cs = (i.ibu - cs_dict["m_ibu"]) / cs_dict["sd_ibu"]
    @select  get(ibu_cs, missing)
    @collect
end
s1_obj
# 50562-element Array{Union{Missing, Float64},1}:
# -0.8151417763351124
# 0.1281156968892236
# 0.01995852988729847
# :
# -0.6337461084073555
# 0.07913886654872931

mean(skipmissing(s1_obj))
# 1.1198281324600945e-14
std(skipmissing(s1_obj))
# 1.00000000000000000000

## use named tuples
s2_obj = @from i in df_recipe begin
    @let ibu_cs = (i.ibu - cs_dict["m_ibu"]) / cs_dict["sd_ibu"]
    @let color_cs = (i.color - cs_dict["m_color"]) / cs_dict["sd_color"]
    @select {id = i.id, ibu = ibu_cs, color = color_cs}
    @collect DataFrame
end

s2_obj
# 50562x3 DataFrame
# | Row   | id      | ibu       | color      |
# |       | String  | Float64   | Float64    |
# +-------+---------+-----------+------------+
# | 1     | id1     | -0.815142 | -0.773402  |
# | 2     | id2     | 0.128116  | -0.453797  |
# | 3     | id3     | 0.0199585 | -0.490763  |
# :
# | 50560 | id50560 | 0.127209  | -0.536971  |
# | 50561 | id50561 | -0.633746 | -0.0579493 |
# | 50562 | id50562 | 0.0791389 | -0.479211  |

mean(skipmissing(s2_obj[:color]))
# -5.692740670427803e-15
std(skipmissing(s2_obj[:color]))
# 0.9999999999999948
