using RData

# Read in wine data (in two steps)
wine = RData.load("wine.rda")
wine_df = wine["wine"]
println("wine_df: ", typeof(wine_df))

# Read in coffee data (in two steps)
coffee_df = RData.load("coffee.rda")["coffee"]
print("coffee_df[1:5,:]:\n", coffee_df[1:5,:])
