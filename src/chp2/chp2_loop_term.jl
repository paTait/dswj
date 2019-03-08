## break keyword

i = 0
while  true
    global i
    sq = i^2
    println("i: $i --- sq: = $sq")
    if sq > 16
        break
    end
    i += 1
 end

# i: 0 --- sq: = 0
# i: 1 --- sq: = 1
# i: 2 --- sq: = 4
# i: 3 --- sq: = 9
# i: 4 --- sq: = 16
# i: 5 --- sq: = 25

 for i = 1:10
     sq = i^2
     println("i: $i --- sq: = $sq")
     if sq > 16
         break
     end
 end       
