## EM Algorithm for PPCA -- Helper functions

function wbiinv(q, p, psi, L)
    ## Woodbury Indentity eq 6.13
    Lt = transpose(L)
    Iq = Matrix{Float64}(I, q, q)
    Ip = Matrix{Float64}(I, p, p)
    psi2 = /(1, psi)
    m1 = *(psi2, Ip)
    m2c = +( *(psi, Iq), *(Lt, L) )
    m2 = *(psi2, L, inv(m2c), Lt)
    return( -(m1, m2) )
end

function wbidet(q, p, psi, L)
  ## Woodbury Indentity eq 6.14
  Iq = Matrix{Float64}(I, q, q)
  num = psi^p
  den1 = *(transpose(L), wbiinv(q, p, psi, L), L)
  den = det(-(Iq, den1))
  return( /(num, den) )
end

function ppca_ll(n, q, p, psi, L, S)
    ## log likelihood eq 6.8
    n2 = /(n, 2)
    c = /( *(n, p, log(*(2, pi))), 2)
    l1 = *(n2, log(wbidet(q, p, psi, L)))
    l2 = *(n2, tr(*(S, wbiinv(q, p, psi, L))))
    return( *(-1, +(c, l1, l2)) )
end

function cov_mat(X)
    n,p = size(X)
    mux = mean(X, dims = 1)
    X_c = .-(X, mux)
    res =  *( /(1,n), *(transpose(X_c), X_c))
    return(res)
end

function aitkenaccel(l1, l2, l3, tol)
    ## l1 = l(k+1), l2 = l(k), l3 = l(k-1)
    conv = false
    num = -(l1, l2)
    den = -(l2, l3)
    ## eq 6.16
    ak = /(num, den)
    if ak <= 1.0
        c1 = -(l1, l2)
        c2 = -(1.0, ak)
        ## eq 6.17
        l_inf = +(l2, /(c2, c1))
        c3 = -(l_inf, l2)
        if  0.0 < c3 < tol
            conv = true
        end
    end
    return conv
end

function ppca_fparams(p, q)
    ## number of free parameters in the ppca model
    c1 = *(p, q)
    c2 = *(-1, q, -(q, 1), 0.5)
    return( +(c1, c2, 1) )
end

function BiC(ll, n, q, ρ)
    ## name does not conflict with StatsBase
    ## eq 6.19
    c1 = *(2, ll)
    c2 = *(ρ, log(n))
    return( -(c1, c2) )
end
