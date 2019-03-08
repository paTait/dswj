## map() applies a function to each element of an array and returns a new
## array containing the resulting values

a = [1,2,3,1,2,1]
mu = mean(a)
sd = std(a)

## centers and scales a
b = map(x -> (x-mu)/sd, a)
