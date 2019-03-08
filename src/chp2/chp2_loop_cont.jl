## continue keyword

for i in 1:5
    if i % 2 == 0
        continue
    end
    sq = i^2
    println("i: $i --- sq: $sq")
end

# i: 1 --- sq: 1
# i: 3 --- sq: 9
# i: 5 --- sq: 25