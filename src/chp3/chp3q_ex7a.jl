using DataValues

## group by beer type and summarise ibu
## filter out missing values
g1_obj = @from i in df_recipe begin
    @where !isna(i.ibu)
	@group i by i.y into grp
    @select {Group = key(grp), Mean_IBU = mean(grp.ibu),
             TrimM_IBU = mean(trim(grp.ibu, prop=0.2))}
    @collect DataFrame
end

# 2x3 DataFrame
# | Row | Group | Mean_IBU | TrimM_IBU |
# |     | Int64 | Float64  | Float64   |
# +-----+-------+----------+-----------+
# | 1   | 0     | 55.6269  | 47.8872   |
# | 2   | 1     | 33.9551  | 29.1036   |
