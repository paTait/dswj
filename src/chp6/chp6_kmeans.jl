using DataFrames, Clustering, Gadfly, Random
Random.seed!(429)

mean_x2 = mean(x2_mat, dims=1)
## mean center the cols
x2_mat_c = x2_mat .- mean_x2
N = size(x2_mat_c)[1]

## kmeans() - each column of X is a sample - requires reshaping x2
x2_mat_t = reshape(x2_mat_c, (2,N))

## Create data for elbow plot
k = 2:8
df_elbow = DataFrame(k = Vector{Int64}(), tot_cost = Vector{Float64}())
for i in k
    tmp = [i, kmeans(x2_mat_t, i; maxiter=10, init=:kmpp).totalcost ]
    push!(df_elbow, tmp)
end

## create elbow plot
p_km_elbow = plot(df_elbow, x = :k, y = :tot_cost, Geom.point, Geom.line,
  Guide.xlabel("k"), Guide.ylabel("Total Within Cluster SS"),
  Coord.Cartesian(xmin = 1.95), Guide.xticks(ticks = collect(2:8)))
