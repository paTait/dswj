## Lexicographical comparison
s1 = "abcd"
s2 = "abce"

s1 == s2
# false

s1 < s2
# true

s1 > s2
#false

## String functions
str = "Data science is fun!"

findfirst("Data", str)
# 1:4

occursin("ata", str )
# true

replace(str, "fun" => "great")
# "Data science is great!"

## Regular expressions
## match alpha-numeric characters at the start of the str
occursin(r"^[a-zA-Z0-9]", str)
# true

## match alpha-numeric characters at the end of the str
occursin(r"[a-zA-Z0-9]$", str)
# false

## matches the first non-alpha-numeric character in the string
 match(r"[^a-zA-Z0-9]", str)
#RegexMatch(" ")

## matches all the non-alpha-numeric characters in the string
collect(eachmatch(r"[^a-zA-Z0-9]", str))
#4-element Array{RegexMatch,1}:
# RegexMatch(" ")
# RegexMatch(" ")
# RegexMatch(" ")
# RegexMatch("!")
