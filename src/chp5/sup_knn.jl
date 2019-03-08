## majority vote
function maj_vote(yn)
   ## majority vote
    cm = countmap(yn)
    mv = -999
    lab = nothing
    tot = 1e-8
    for (k,v) in cm
        tot += v
        if v > mv
            mv = v
            lab = k
        end
    end
    prop = /(mv, tot)
    return [lab, prop]
end

## KNN label prediction
function knn(x, y, x_new, k)
    n,p = size(x)
    n2,p2 = size(x_new)
    ynew = zeros(n2,2)

    for i in 1:n2 ## over new x_new
        res = zeros(n,2)
        for j in 1:n ## over x
            ## manhattan distance between rows - each row is a subject
            res[j,:] = [j , cityblock(x[j,:], x_new[i,:])] #cityblock
        end
        ## sort rows by distance and index - smallest distances
        res2 = sortslices(res, dims = 1, by = x -> (x[2], x[1]))
        ## get indices for the largest k distances
        ind = convert(Array{Int}, res2[1:k, 1])
        ## take majority vote for the associated indices
        ynew[i,:] = maj_vote(y[ind])
    end
    ## return the predicted labels
    return ynew
end

## Returns the missclassification rate
function knnmcr(yp, ya)
    disagree = Array{Int8}(ya .!= yp)
    mcr = mean(disagree)
    return mcr
end
