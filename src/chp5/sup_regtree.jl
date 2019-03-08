using DecisionTree, Random
Random.seed!(35)

## food training data from chapter 3
y = df_food[:gpa]
tmp = convert(Array, df_food[setdiff(names(df_food), [:gpa])] )
xmat = convert(Array{Float64}, collect(Missings.replace(tmp, 0)))
names_food = setdiff(names(df_food), [:gpa])

# defaults to regression tree if y is a Float array
model = build_tree(y, xmat)

# prune tree: merge leaves having >= 85% combined purity (default: 100%)
modelp = prune_tree(model, 0.85)

# tree depth is 9
depth(modelp)

# print the tree to depth 3
print_tree(modelp, 3)
#=
Feature 183, Threshold 0.5
L-> Feature 15, Threshold 0.5
    L-> Feature 209, Threshold 0.5
        L->
        R->
    R-> Feature 209, Threshold 0.5
        L->
        R->
R-> Feature 15, Threshold 0.5
    L-> Feature 8, Threshold 0.5
        L->
        R->
    R-> Feature 23, Threshold 0.5
        L->
        R->
=#

# print the variables in the tree
for i in [183, 15, 209, 8, 23]
  println("Variable number: ", i, " name: ", names_food[i])
end

#=
Variable number: 183 name: self_perception_wgt3
Variable number: 15 name: cal_day3
Variable number: 209 name: waffle_cal1315
Variable number: 8 name: vitamins
Variable number: 23 name: comfoodr_code11
=#
