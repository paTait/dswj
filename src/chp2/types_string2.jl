## Some examples of strings
str = "Data science is fun!"
str[1]
# 'D'

str[end]
#'!'

## Slicing
str[4:7]
# "a sc"

str[end-3:end]
# "fun!"

## Concatenation
string(str, " Sure is :)")
#"Data science is fun! Sure is :)"

str * " Sure is :)"
# "Data science is fun! Sure is :)"

## Interpolation
"1 + 2 = $(1 + 2)"
#"1 + 2 = 3"

word1 = "Julia"
word2 = "data"
word3 = "science"
"$word1 is great for $word2 $word3"
#"Julia is great for data science"
