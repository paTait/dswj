using Random
Random.seed!(35)

## Partition the training data into K (roughly) equal parts
function cvind(N, k)
        gs = Int(floor(N/k))
        ## randomly shuffles the indices
	index = shuffle(collect(1:N))
	folds = collect(Iterators.partition(index, gs))
        ## combines and deletes array of indices outside of k
	if length(folds) > k
	   folds[k] = vcat(folds[k], folds[k+1])
	   deleteat!(folds, k+1)
	end
	return folds
end

## Subset data into k training/test splits based on indices
## from cvind
function kfolds(dat, ind, k)
    ## row indices for dat
    ind1 = collect(1:size(dat)[1])
    ## results to return
    res = Dict{Int, Dict}()
    for i = 1:k
        ## results for each loop iteration
        res2 = Dict{String, DataFrame}()
        ## indices not in test set
        tr = setdiff(ind1, ind[i])
        ## add results to dictionaries
        push!(res2, "tr"=>dat[tr,:])
        push!(res2, "tst"=>dat[ind[i],:])
        push!(res, i=>res2)
    end
    return res
end
