## An integer array with three values
v5 = [sample([0,1,2], pweights([0.2,0.6,0.2])) for i=1:Nca]

## An empty string array
v5b = Array{String}(undef, Nca)

## Recode the integer array values and save them to v5b
recode!(v5b, v5, 0 => "Apple", 1 => "Orange", 2=> "Pear")
v5c = categorical(v5b)

print(typeof(v5c))
# CategoricalArray{String,1,UInt32,String,CategoricalString{UInt32},
# Union{}}

print(levels(v5c))
# ["Apple", "Orange", "Pear"]
