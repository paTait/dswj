using LinearAlgebra

## function to do pca via SVD
function pca_svd(X)
    n,p = size(X)
    k = min(n,p)
    S = svd(X)
    D = S.S[1:k]
    V = transpose(S.Vt)[:,1:k]
    sD = /(D, sqrt(n-1))
    rotation = V
    projection = *(X, V)
    return(Dict(
      "sd" => sD,
      "rotation" => rotation,
      "projection" => projection
    ))
end

## crab_mat_c is a Float array with  5 continuous mearures
## each variable is mean centered
crab_mat = convert(Array{Float64}, df_crabs[[:FL, :RW, :CL, :CW, :BD]])
mean_crab = mean(crab_mat, dims = 1)
crab_mat_c = crab_mat .- mean_crab

pca1 = pca_svd(crab_mat)

## df for plotting
## label is the combination of sp and sex
pca_df2 = DataFrame(
  pc1 = pca1["projection"][:,1],
  pc2 = pca1["projection"][:,2],
  pc3 = pca1["projection"][:,3],
  pc4 = pca1["projection"][:,4],
  pc5 = pca1["projection"][:,5],
  label = map(string, repeat(1:4, inner = 50))
)
