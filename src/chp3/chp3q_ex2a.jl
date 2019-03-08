## named tuple - reference property by its symbol
named_tup = (x = 45, y =90)

typeof(named_tup)
# NamedTuple{(:x, :y),Tuple{Int64,Int64}}

named_tup[:y]
# 90
