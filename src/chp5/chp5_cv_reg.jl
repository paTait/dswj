## CV Functions for Regression

function tunegrid_xgb_reg(eta, maxdepth, alpha)
    n_eta = size(eta)[1]
    md = collect(1:maxdepth)
    n_md = size(md)[1]
    n_a = size(alpha)[1]

    ## 2 cols to store the CV results
    res = zeros(*(maxdepth, n_eta, n_a), 5)
    n_res = size(res)[1]
    println("N:", n_res, " e: ", n_eta, " m: ", n_md, " a: ", n_a)
    ## populate the res matrix with the tuning parameters
    n_md_i = Int64(/(n_res, n_md))
    res[:,1] = repeat(md, outer=n_md_i)
    res[:,2] = repeat(eta, inner = Int64(/(n_res, n_eta)))
    res[:,3] = repeat(repeach(alpha, (n_md)), outer=n_a)

    return(res)
end

function medae(yp, ya)
    ## element wise operations
    res = map(yp, ya) do x,y
        dif = -(x, y)
        return(abs(dif))
    end
    return(median(res))
end

function rmse(yp, ya)
    ## element wise operations
    res = map(yp, ya) do x,y
        dif = -(x, y)
        return(dif^2)
    end
    return(sqrt(mean(res)))
end

function cvResult_xgb_reg(Xmat, Yvec, cvparam, tunegrid; k = 5, n = 50,
  trace = false )

    result = deepcopy(tunegrid)
    n_tg = size(result)[1]

    ## k-Fold CV for each combination of parameters
    for i = 1:n_tg
        scores = cross_validate(
            ## num_round investigate
            trind -> xgboost(Xmat[trind,:], 1000, label = Yvec[trind],
              param = cvparam, max_depth = Int(tunegrid[i,1]),
                eta = tunegrid[i,2], alpha = tunegrid[i,3]),
            (c, trind) -> cvERR_xgb(c, Xmat[trind,:], Yvec[trind], medae,
              trace = true),
            n, ## total number of samples
            Kfold(n, k)
          )
        if(trace)
            println("cvResult_xgb_reg: scores: ", scores)
            println("size(scores): ", size(scores))
        end
        result[i, 4] = mean(scores)
        result[i, 5] = std(scores)
    end

    return(result)
end
