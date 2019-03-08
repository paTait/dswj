using LinearAlgebra, Random
Random.seed!(429)
include("chp6_ppca_functions.jl")

## EM Function for PPCA
function ppca(X; q = 2, thresh = 1e-5, maxit = 1e5)

     Iq = Matrix{Float64}(I, q, q)
     qI = *(q, Iq)
     n,p = size(X)
     ## eigfact has eval/evec smallest to largest
     ind = p:-1:(p-q+1)
     Sx = cov_mat(X)
     D = eigen(Sx)
     d = diagm(0 => map(sqrt, D.values[ind]))
     P = D.vectors[:, ind]

     ## initialize parameters
     L = *(P, d) ## pxq
     psi = *( /(1, p), tr( -( Sx, *(L, transpose(L)) ) ) )
     B = zeros(q,p)
     T = zeros(q,q)
     conv = true
     iter = 1
     ll = zeros(100)
     ll[1] = 1e4

    ## while not converged
    while(conv)
      ## above eq 6.12
      B = *(transpose(L), wbiinv(q, p, psi, L))  ## qxp
      T = -(qI, +( *(B,L), *(B, Sx, transpose(B)) ) ) ## qxq
      ## sec 6.4.3 - update Lambda_new
      L_new = *(Sx, transpose(B), inv(T)) ## pxq
      ## update psi_new
      psi_new = *( /(1, p), tr( -(Sx, *(L_new, B, Sx) ) )) #num

      iter += 1

      if iter > maxit
          conv = false
          println("ppca() while loop went over maxit parameter. iter = 
            $iter")
      else
        ## stores at most the 100 most recent ll values
        if iter <= 100
          ll[iter]=ppca_ll(n, q, p, psi_new, L_new, Sx)
        else
          ll = circshift(ll, -1)
          ll[100] = ppca_ll(n, q, p, psi_new, L_new, Sx)
        end
        if 2 < iter < 101
              ## scales the threshold by the latest ll value
              thresh2 = *(-1, ll[iter], thresh)
              if aitkenaccel(ll[iter], ll[(iter-1)], ll[(iter-2)], thresh2)
               conv = false
              end
        else
          thresh2 = *(-1, ll[100], thresh)
          if aitkenaccel(ll[100], ll[(99)], ll[(98)], thresh2)
            conv = false
          end
        end
      end ## if maxit
      L = L_new
      psi = psi_new
    end ## while

    ## orthonormal coefficients
    coef = svd(L).U
    ## projections
    proj = *(X, coef)

    if iter <= 100
      resize!(ll, iter)
    end
    fp = ppca_fparams(p, q)

    bic_res = BiC(ll[end], n, q, fp)

    return(Dict(
        "iter" => iter,
        "ll" => ll,
        "beta" => B,
        "theta" => T,
        "lambda" => L,
        "psi" => psi,
        "q" => q,
        "sd" => diag(d),
        "coef" => coef,
        "proj" => proj,
        "bic" => bic_res
      ))
end

ppca1 = ppca(crab_mat_c, q=3, maxit = 1e3)
