## remove rows where the style column is missing.
filter!(row -> !ismissing(row[:style]), df_recipe)
