## Values can be accessed similarly to an array, but by key:
food_dict[1]

## The get() function can also be used; note that "unknown" is the
## value returned here if the key is not in the dictionary
get(food_dict, 1, "unknown")
get(food_dict, 7, "unknown")

## We can also check directly for the presence of a particular key
haskey(food_dict, 2)
haskey(food_dict, 9)

## The getkey() function can also be used; note that 999 is the
## value returned here if the key is not in the dictionary
getkey(food_dict, 1, 999)

## A new value can be associated with an existing key
food_dict
food_dict[1] = "lobster"

## Two common ways to add new entries:
food_dict[4] = "bannock"
get!(food_dict, 4, "bannock")

## The advantage of get!() is that is will not add the new entry if
## a value is already associated with the the key
get!(food_dict, 4, "toutiere")

## Just deleting entries by key is straightforward
delete!(food_dict,4)

## But we can also delete by key and return the value associated with
## the key; note that 999 is returned here if the key is not present
deleted_fd_value = pop!(food_dict,3, 999)

# Keys can be coerced into arrays
collect(keys(food_dict))

# Values can also be coerced into arrays
collect(values(food_dict))

# We can iterate over both keys and values
for (k, v) in food_dict
  println("food_dict: key: ", k, " value: ", v)
end

# We could also just loop over keys
for k in keys(food_dict)
  println("food_dict: key: ", k)
end

# Or could also just loop over values
for v in values(food_dict)
  println("food_dict: value: ", v)
end
