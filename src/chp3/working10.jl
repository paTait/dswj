## print the summary stats for x3 in each partition
for part in groupby(df1, :X2, sort=true)
  println(unique(part[:X2]))
  println(summarystats(part[:X3]))
end

# ["High"]
# Summary Stats:
# Mean:           2.004051
# Minimum:        1.011101
# 1st Quartile:   1.361863
# Median:         1.820108
# 3rd Quartile:   2.383068
# Maximum:        4.116220
#
# ["Low"]
# ...
