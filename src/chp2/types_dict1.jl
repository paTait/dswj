## Three dictionaries, D0 is empty, D1 and D2 are the same
D0 = Dict()
D1 = Dict(1 => "red", 2 => "white")
D2 = Dict{Integer, String}(1 => "red", 2 => "white")

## Dictionaries can be created using a loop
food = ["salmon", "maple syrup", "tourtiere"]
food_dict = Dict{Int, String}()

## keys are the foods index in the array
for (n, fd) in enumerate(food)
  food_dict[n] = fd
end

## Dictionaries can also be created using the generator syntax
wine = ["red", "white", "rose"]
wine_dict = Dict{Int,String}(i => wine[i] for i in 1:length(wine))