## MPPCA helper functions
using LinearAlgebra

function sigmaG(mu, xmat, Z)
    res = Dict{Int, Array}()
    N,g = size(Z)
    c1 = ./(1, sum(Z, dims = 1))
    for i = 1:g
        xmu = .-(xmat, transpose(mu[:,i]))
        zxmu =  .*(Z[:,i], xmu)
        res_g = *(c1[i], *(transpose(zxmu), zxmu)) 
        push!(res, i=>res_g)
    end
    return res
end

function muG(g, xmat, Z)
    N, p = size(xmat)
    mu = zeros(p, g)
    for i in 1:g
        num = sum(.*(Z[:,i], xmat), dims = 1)
        den = sum(Z[:, i])
        mu[:, i] = /(num, den)
    end
    return mu
end

## initializations
function init_LambdaG(q, g, Sx)
    res = Dict{Int, Array}()
    for i = 1:g
        p = size(Sx[i], 1)
        ind = p:-1:(p-q+1)
        D = eigen(Sx[i])
        d = diagm(0 => map(sqrt, D.values[ind]))
        P = D.vectors[:, ind]
        L = *(P,d)
        push!(res, i => L)
    end
    return res
end

function init_psi(g, Sx, L)
    res = Dict{Int, Float64}()
    for i = 1:g
        p = size(Sx[i], 1)
        psi = *(/(1, p), tr(-(Sx[i], *(L[i], transpose(L[i])))))
        push!(res, i=>psi)
    end
    return res
end

function init_dict0(g, r, c)
    res = Dict{Int, Array}()
    for i = 1:g
        push!(res, i=> zeros(r, c))
    end
    return res
end

## Updates
function update_B(q, p, psig, Lg)
    res = Dict{Int, Array}()
    g = length(psig)
    for i=1:g
        B = *(transpose(Lg[i]), wbiinv(q, p, psig[i], Lg[i]))
        push!(res, i=>B)
    end
    return res
end

function update_T(q, Bg, Lg, Sg)
    res = Dict{Int, Array}()
    Iq = Matrix{Float64}(I, q, q)
    qI = *(q, Iq)
    g = length(Bg)
    for i =1:g
        T = -(qI, +(*(Bg[i], Lg[i]), *(Bg[i], Sg[i], transpose(Bg[i]))))
        push!(res, i=>T)
    end
    return res
end

function update_L(Sg, Bg, Tg)
    res = Dict{Int, Array}()
    g = length(Bg)
    for i = 1:g
        L = *(Sg[i], transpose(Bg[i]), inv(Tg[i]))
        push!(res, i=>L)
    end
    return res
end

function update_psi(p, Sg, Lg, Bg)
    res = Dict{Int, Float64}()
    g = length(Bg)
    for i = 1:g
        psi = *( /(1, p), tr( -(Sg[i], *(Lg[i], Bg[i], Sg[i]) ) ) )
        push!(res, i=>psi)
    end
    return res
end

function update_zmat(xmat, mug, Lg, psig, pig)
    N,p = size(xmat)
    g = length(Lg)
    res = Matrix{Float64}(undef, N, g)
    Ip = Matrix{Float64}(I, p, p)
    for i = 1:g
        pI = *(psig[i], Ip)
        mu = mug[:, i]
        cov = +( *( Lg[i], transpose(Lg[i]) ), pI)
        pi_den = *(pig[i], pdf(MvNormal(mu, cov), transpose(xmat)))
        res[:,i] = pi_den
    end
    return ./(res, sum(res, dims = 2))
end

function mapz(Z)
    N,g = size(Z)
    res = Vector{Int}(undef, N)
    for i = 1:N
        res[i] = findmax(Z[i,:])[2]
    end
    return res
end

function mppca_ll(N, p, pig, q, psig, Lg, Sg)
    g = length(Lg)
    l1,l2,l3 = (0,0,0)
    c1 = /(N,2)
    c2 = *(-1, c1, p, g, log( *(2,pi) ))
    for i = 1:g
        l1 += log(pig[i])
        l2 += log(wbidet(q, p, psig[i], Lg[i]))
        l3 += tr(*(Sg[i], wbiinv(q, p, psig[i], Lg[i])))
     end
     l1b = *(N, l1)
     l2b = *(-1, c1, l2)
     l3b = *(-1, c1, l3)
     return(+(c2, l1b, l2b, l3b))
end

function mppca_fparams(p, q, g)
    ## number of free parameters in the ppca model
    c1 = *(p, q)
    c2 = *(-1, q, -(q, 1), 0.5)
    return(+( *( +(c1, c2), g), g))
end

function mppca_proj(X, G, map, L)
    res = Dict{Int, Array}()
    for i in 1:G
        coef = svd(L[i]).U
        sel = map .== i
        proj = *(X[sel, :], coef)
        push!(res, i=>proj)
    end
    return(res)
end
