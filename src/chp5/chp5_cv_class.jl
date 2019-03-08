## CV functions for classification
using Statistics, StatsBase

## Array of parameters to train models on
## Includes two columns for the error mean and sd
function tunegrid_xgb(eta, maxdepth)
    n_eta = size(eta)[1]
    md = collect(1:maxdepth)
    n_md = size(md)[1]

    ## 2 cols to store the CV results
    res = zeros(*(maxdepth, n_eta), 4)
    n_res = size(res)[1]

    ## populate the res matrix with the tuning parameters
    res[:,1] = repeat(md, inner = Int64(/(n_res, n_md)))
    res[:,2] = repeat(eta, outer = Int64(/(n_res, n_eta)))

    return(res)
end

## MCR
function binary_mcr(yp, ya; trace = false)
    yl = Array{Int8}(yp .> 0.5)
    disagree = Array{Int8}(ya .!= yl)
    mcr = mean(disagree)
    if trace
        #print(countmap(yl))
        println("yl: ", yl[1:4])
        println("ya: ", ya[1:4])
        println("disagree: ", disagree[1:4])
        println("mcr: ", mcr)
    end
    return( mcr )
end

## Used by binomial_dev
## works element wise on vectors
function bd_helper(yp, ya)
    e_const = 1e-16
    pneg_const = 1.0 - yp
    if yp < e_const
        res = +(*(ya, log(e_const)), *( -(1.0, ya), log(-(1.0, e_const))))
    elseif pneg_const < e_const
        res = +(*(ya, log(-(1.0, e_const))), *( -(1.0, ya), log(e_const)))
    else
        res = +(*(ya, log(yp)), *( -(1.0, ya), log(pneg_const)))
    end
    return res
end

## Binomial Deviance
function binomial_dev(yp, ya) #::Vector{T}) where {T <: Number}
    res = map(bd_helper, yp, ya)
    dev = *(-2, sum(res))
    return(dev)
end

## functions used with MLBase.jl
function cvERR_xgb(model, Xtst, Ytst, error_fun; trace = false)
    y_p = XGBoost.predict(model, Xtst)
    if(trace)
        println("cvERR: y_p[1:5] ", y_p[1:5])
        println("cvERR: Ytst[1:5] ", Ytst[1:5])
        println("cvERR: error_fun(y_p, Ytst) ", error_fun(y_p, Ytst))
    end
    return(error_fun(y_p, Ytst))
end

function cvResult_xgb(Xmat, Yvec, cvparam, tunegrid; k = 5, n = 50,
  trace = false )

    result = deepcopy(tunegrid) ## tunegrid could have two columns on input
    n_tg = size(result)[1]

    ## k-Fold CV for each combination of parameters
    for i = 1:n_tg
        scores = cross_validate(
            trind -> xgboost(Xmat[trind,:], 1000, label = Yvec[trind],
              param = cvparam, max_depth = Int(tunegrid[i,1]),
                eta = tunegrid[i,2]),
            (c, trind) -> cvERR_xgb(c, Xmat[trind,:], Yvec[trind],
              binomial_dev, trace = true),
             ## total number of samples
            n,
            ## Stratified CV on the outcome
            StratifiedKfold(Yvec, k)
          )
        if(trace)
            println("cvResult_xgb: scores: ", scores)
            println("size(scores): ", size(scores))
        end
        result[i, 3] = mean(scores)
        result[i, 4] = std(scores)
    end

    return(result)
end
