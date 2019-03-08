# Heuristic conversion examples
d1 = rcopy(R"""data.frame(v1 = 1:2, v2=c("Data", "Science"))""")
println("type d1: ", typeof(d1))
# type d1: DataFrames.DataFrame

l1 = rcopy(R"list(2.3, 'red') ")
println("type l1: ", typeof(l1))
# type l1: Array{Any,1}

l2 = rcopy(R"list(v1=2.3, v2='red')")
println("type l2: ", typeof(l2))
# type l2: DataStructures.OrderedDict{Symbol,Any}

# Note that rcopy() will force an exact conversion if the type is
# specified as the first argument
l3 = rcopy(Array{String,1}, R"""c("Data","Science")""")
println("type l3: ", typeof(l3))
# type l3: Array{String,1}