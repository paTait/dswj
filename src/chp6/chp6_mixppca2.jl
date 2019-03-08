using Clustering
include("chp6_ppca_functions.jl")
include("chp6_mixppca_functions.jl")

## MPPCA function
function mixppca(X; q = 2, G = 2, thresh = 1e-5, maxit = 1e5, init = 1))
   ## initializations
   N, p = size(X)
   ## z_ig
   if init == 1
     ## random
     zmat = rand(Uniform(0,1), N, G)
     ## row sum to 1
     zmat = ./(zmat, sum(zmat, dims = 2))
   elseif init == 2
     # k-means
     kma = kmeans(permutedims(X), G; init=:rand).assignments
     zmat = zeros(N,G)
     for i in 1:N
       zmat[i, kma[i]] = 1
     end
   end
   n_g = sum(zmat, dims = 1)
   pi_g = /(n_g, N)
   mu_g = muG(G, X, zmat)
   S_g = sigmaG(mu_g, X, zmat)
   L_g = init_LambdaG(q, G, S_g)
   psi_g = init_psi(G, S_g, L_g)
   B_g = init_dict0(G, q, p)
   T_g = init_dict0(G, q, q)

   conv = true
   iter = 1
   ll = zeros(100)
   ll[1] = 1e4

  # while not converged
  while(conv)

    ## update pi_g and mu_g
    n_g = sum(zmat, dims = 1)
    pi_g = /(n_g, N)
    mu_g = muG(G, X, zmat)
    if iter > 1
      ## update z_ig
      zmat = update_zmat(X, mu_g, L_g, psi_g, pi_g)
    end
    ## compute S_g, Beta_g, Theta_g
    S_g = sigmaG(mu_g, X, zmat)
    B_g = update_B(q, p, psi_g, L_g)
    T_g = update_T(q, B_g, L_g, S_g)

    ## update Lambda_g psi_g
    L_g_new = update_L(S_g, B_g, T_g)
    psi_g_new = update_psi(p, S_g, L_g, B_g)
    ## update z_ig
    zmat = update_zmat(X, mu_g, L_g_new, psi_g_new, pi_g)

    iter += 1

    if iter > maxit
          conv = false
          println("mixppca() while loop went past maxit parameter. iter = 
            $iter")
    else
      ## stores at most the 100 most recent ll values
      if iter <= 100
         ll[iter] = mppca_ll(N, p, n_g, pi_g, q, psi_g, L_g, S_g)
      else
         ll = circshift(ll, -1)
         ll[100] = mppca_ll(N, p, n_g, pi_g, q, psi_g, L_g, S_g)
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
    L_g = L_g_new
    psi_g = psi_g_new
  end ## while

  map_res = mapz(zmat)
  proj_res = mppca_proj(X, G, map_res, L_g)

  if iter <= 100
    resize!(ll, iter)
  end
  fp = mppca_fparams(p, q, G)

  bic_res = BiC(ll[end], N, q, fp)

  return Dict(
    "iter" => iter,
    "ll" => ll,
    "beta" => B_g,
    "theta" => T_g,
    "lambda" => L_g,
    "psi" => psi_g,
    "q" => q,
    "G" => G,
    "map" => map_res,
    "zmat" => zmat,
    "proj" => proj_res,
    "bic" => bic_res
  )
end

mixppca_12k = mixppca(cof_mat_c, q=1, G=2, maxit = 1e6, thresh = 1e-3, 
  init=2)
