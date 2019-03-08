## Symbol versus String
fruit = "apple"

println("eval(:fruit): ", eval(:fruit))
# eval(:fruit): apple

println("""eval("apple"): """, eval("apple"))
# eval("apple"): apple