using DataFrames, Query, CSV, JLD2, StatsBase, MLLabelUtils, Random
include("chp3_functions.jl")
Random.seed!(24908)

## Types for the file columns
IntOrMiss = Union{Int64,Missing}
FltOrMiss = Union{Float64,Missing}
StrOrMiss = Union{String,Missing}

## define variable names for each column
food_header =
  ["gpa", "gender", "breakfast", "cal_ckn", "cal_day",
   "cal_scone", "coffee", "comfort_food", "comfort_food_reason",
   "comfoodr_code1", "cook", "comfoodr_code2", "cuisine", "diet_current",
   "diet_current_code", "drink", "eating_changes", "eating_changes_coded",
   "eating_changes_coded1", "eating_out", "employment", "ethnic_food",
   "exercise", "father_educ", "father_prof", "fav_cuisine",
   "fav_cuisine_code", "fav_food", "food_child", "fries", "fruit_day",
   "grade_level", "greek_food", "healthy_feeling", "healthy_meal",
   "ideal_diet", "ideal_diet_coded", "income", "indian_food",
   "italian_food", "life_reward", "marital_status", "meals_friend",
   "mom_educ", "mom_prof", "nut_check", "on_campus", "parents_cook",
   "pay_meal_out", "persian_food","self_perception_wgt", "soup", "sports",
   "thai_food", "tortilla_cal", "turkey_cal", "sports_type", "veggies_day",
   "vitamins", "waffle_cal", "wgt"]

## dictionary of types for each column
food_types = Dict{String, Union}(
  "gpa" => FltOrMiss,
  "gender" => IntOrMiss,
  "breakfast" => IntOrMiss,
  "cal_ckn" => IntOrMiss,
  "cal_day" => IntOrMiss,
  "cal_scone" => IntOrMiss,
  "coffee" => IntOrMiss,
  "comfort_food" => StrOrMiss,
  "comfort_food_reason" => StrOrMiss,
  "comfoodr_code1" => IntOrMiss,
  "cook" => IntOrMiss,
  "comfoodr_code2" => IntOrMiss,
  "cuisine" => IntOrMiss,
  "diet_current" => StrOrMiss,
  "diet_current_code" => IntOrMiss,
  "drink" => IntOrMiss,
  "eating_changes" => StrOrMiss,
  "eating_changes_coded" => IntOrMiss,
  "eating_changes_coded1" => IntOrMiss,
  "eating_out" => IntOrMiss,
  "employment" => IntOrMiss,
  "ethnic_food" => IntOrMiss,
  "exercise" => IntOrMiss,
  "father_educ" => IntOrMiss,
  "father_prof" => StrOrMiss,
  "fav_cuisine" => StrOrMiss,
  "fav_cuisine_code" => IntOrMiss,
  "fav_food" => IntOrMiss,
  "food_child" => StrOrMiss,
  "fries" =>  IntOrMiss,
  "fruit_day" =>  IntOrMiss,
  "grade_level" =>  IntOrMiss,
  "greek_food" =>  IntOrMiss,
  "healthy_feeling" =>  IntOrMiss,
  "healthy_meal" => StrOrMiss,
  "ideal_diet" => StrOrMiss,
  "ideal_diet_coded" => IntOrMiss,
  "income" => IntOrMiss,
  "indian_food" => IntOrMiss,
  "italian_food" => IntOrMiss,
  "life_reward" => IntOrMiss,
  "marital_status" => IntOrMiss,
  "meals_friend" => StrOrMiss,
  "mom_educ" => IntOrMiss,
  "mom_prof" => StrOrMiss,
  "nut_check" => IntOrMiss,
  "on_campus" => IntOrMiss,
  "parents_cook" => IntOrMiss,
  "pay_meal_out" => IntOrMiss,
  "persian_food" => IntOrMiss,
  "self_perception_wgt" => IntOrMiss,
  "soup" => IntOrMiss,
  "sports" => IntOrMiss,
  "thai_food" => IntOrMiss,
  "tortilla_cal" => IntOrMiss,
  "turkey_cal" => IntOrMiss,
  "sports_type" => StrOrMiss,
  "veggies_day" => IntOrMiss,
  "vitamins" => IntOrMiss,
  "waffle_cal" => IntOrMiss,
  "wgt" => FltOrMiss
)

## read csv file
df_food_raw = CSV.read("food_coded.csv",
  DataFrame;
  delim = ',' ,
  quotechar = '"',
  missingstrings = ["nan", "NA", "na", ""],
  datarow = 2,
  header = food_header,
  types = food_types,
  allowmissing=:all
)

## drop text fields which are not coded fields
delete!(df_food_raw, [:comfort_food, :comfort_food_reason, :comfoodr_code2,
  :diet_current, :eating_changes, :father_prof, :fav_cuisine, :food_child,
  :healthy_meal, :ideal_diet, :meals_friend, :mom_prof, :sports_type
])

## Change 1/2 coding to 0/1 coding
df_food_raw[:gender] = map(x -> x - 1, df_food_raw[:gender])
df_food_raw[:breakfast] = map(x -> x - 1, df_food_raw[:breakfast])
df_food_raw[:coffee] = map(x -> x - 1, df_food_raw[:coffee])
df_food_raw[:drink] = map(x -> x - 1, df_food_raw[:drink])
df_food_raw[:fries] = map(x -> x - 1, df_food_raw[:fries])
df_food_raw[:soup] = map(x -> x - 1, df_food_raw[:soup])
df_food_raw[:sports] = map(x -> x - 1, df_food_raw[:sports])
df_food_raw[:vitamins] = map(x -> x - 1, df_food_raw[:vitamins])

JLD2.@save "food_raw.jld2"  df_food_raw

###########################
## Create  cleaned version

## Create a copy of the DF
df_food = deepcopy(df_food_raw)
println("- df_food size: ", size(df_food))
# - df_food size: (125, 48)

## generate dummy variables
## used string array bc onehot_encoding!() takes a string
change2_dv = ["cal_ckn", "cal_day", "cal_scone", "comfoodr_code1",
  "cook", "cuisine", "diet_current_code", "eating_changes_coded",
  "eating_changes_coded1", "eating_out", "employment", "ethnic_food",
  "exercise", "father_educ", "fav_cuisine_code", "fav_food", "fruit_day",
  "grade_level", "greek_food", "healthy_feeling", "ideal_diet_coded",
  "income", "indian_food", "italian_food", "life_reward", "marital_status",
  "mom_educ", "nut_check", "on_campus", "parents_cook", "pay_meal_out",
  "persian_food", "self_perception_wgt", "thai_food", "tortilla_cal",
  "turkey_cal", "veggies_day", "waffle_cal"]

println("-- onehotencoding()")
for i in change2_dv
   println("i: ", i)
   onehot_encoding!(df_food, i)
   delete!(df_food, Symbol(i))
end

## remove NaNs
df_food[:gpa] =
  collect(FltOrMiss, map(x -> isnan(x)?missing:x, df_food[:gpa]))
df_food[:wgt] =
  collect(FltOrMiss, map(x -> isnan(x)?missing:x, df_food[:wgt]))

## remove missing gpa
filter!(row -> !ismissing(row[:gpa]), df_food)

println("--- df_food: ", size(df_food))
# --- df_food: (121, 214)

JLD2.@save "food.jld2"  df_food
