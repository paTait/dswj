## A function with an optional argument. This is a recursive function,
## i.e., a function that calls itself, for computing the sum of the first n
## elements of the Fibonacci sequence: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55,...

function fibonacci(n=20)
  if (n<=1)
    return 1
  else
    return fibonacci(n-1)+fibonacci(n-2)
  end
end

## Sum the first 12 elements of the Fibonacci sequence
fibonacci(12)
# 233

## Because the optional argument defaults to 20, these are equivalent
fibonacci()
fibonacci(20)
