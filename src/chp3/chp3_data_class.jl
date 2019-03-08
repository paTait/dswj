using DataFrames, Query, CSV, JLD2, StatsBase, MLLabelUtils, Random
include("chp3_functions.jl")
Random.seed!(24908)

## Types for the files columns
IntOrMiss = Union{Int64,Missing}
FltOrMiss = Union{Float64,Missing}
StrOrMiss = Union{String,Missing}

## define variable names for each column
recipe_header = ["beer_id", "name", "url", "style", "style_id", "size",
  "og", "fg", "abv", "ibu", "color", "boil_size", "boil_time", "biol_grav",
  "efficiency", "mash_thick", "sugar_scale", "brew_method", "pitch_rate",
  "pri_temp", "prime_method", "prime_am"]

## dictionary of types for each column
recipe_types2 = Dict{String, Union}(
  "beer_id" => IntOrMiss,
  "name" => StrOrMiss,
  "url" => StrOrMiss,
  "style" => StrOrMiss,
  "style_id" => IntOrMiss,
  "size" => FltOrMiss,
  "og" => FltOrMiss,
  "fg" => FltOrMiss,
  "abv" => FltOrMiss,
  "ibu" => FltOrMiss,
  "color" => FltOrMiss,
  "boil_size" => FltOrMiss,
  "boil_time" => FltOrMiss,
  "biol_grav" => FltOrMiss,
  "efficiency" => FltOrMiss,
  "mash_thick" => FltOrMiss,
  "sugar_scale" => StrOrMiss,
  "brew_method" => StrOrMiss,
  "pitch_rate" => FltOrMiss,
  "pri_temp" => FltOrMiss,
  "prime_method" => StrOrMiss,
  "prime_am" => StrOrMiss
)

## read csv file
df_recipe_raw = CSV.read("recipeData.csv",
  DataFrame;
  delim = ',' ,
  quotechar = '"',
  missingstring = "N/A",
  datarow = 2,
  header = recipe_header,
  types = recipe_types2,
  allowmissing=:all
)

## Drop columns
delete!(df_recipe_raw, [:prime_method, :prime_am, :url])

#####
## Write the raw data dataframe
JLD2.@save "recipeRaw.jld2"  df_recipe_raw

###########################
## Create  cleaned version

## Create a copy of the DF
df_recipe = deepcopy(df_recipe_raw)

## exclude missing styles
filter!(row -> !ismissing(row[:style]), df_recipe)

println("-- df_recipe: ",size(df_recipe))
#  df_recipe: (73861, 19)

## Make beer categories
df_recipe[:y] = map(x ->
occursin(r"ALE"i, x) || occursin(r"IPA"i, x) || occursin(r"Porter"i, x) 
   || occursin(r"stout"i, x) ? 0 :
occursin(r"lager"i, x) || occursin(r"pilsner"i, x) || occursin(r"bock"i, x) 
   || occursin(r"okto"i, x) ? 1 : 99 ,
df_recipe[:style])

## remove styles that are not lagers or ales
filter!(row -> row[:y] != 99, df_recipe)

## remove extraneous columns
delete!(df_recipe, [:beer_id, :name, :style, :style_id])

## create dummy variables - one-hot-encoding
onehot_encoding!(df_recipe, "brew_method" , trace = true)
onehot_encoding!(df_recipe, "sugar_scale")

describe(df_recipe, stats=[:eltype, :nmissing])

delete!(df_recipe, [:brew_method,:sugar_scale])

JLD2.@save "recipe.jld2"  df_recipe
