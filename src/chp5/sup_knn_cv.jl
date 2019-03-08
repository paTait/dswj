## Simulated data
df_3 = DataFrame(y = [0,1], size = [250,250], x1 =[2.,0.], x2 =[-1.,-2.])

df_knn =by(df_3, :y) do df
  DataFrame(x_1 = rand(Normal(df[1,:x1],1), df[1,:size]),
  x_2 = rand(Normal(df[1,:x2],1), df[1,:size]))
end

## set up parameters for cross-validation
N = size(df_knn)[1]
kcv = 5

## generate indices
a_ind = cvind(N, kcv)

## generate dictionary of dataframes
d_cv = kfolds(df_knn, a_ind, kcv)

## knn parameters
k = 15
knnres = zeros(k,3)

## loop through k train/test sets and calculate error metric
for i = 1:k
  cv_res = zeros(kcv)
  for j = 1:kcv
     tr_a = convert(Matrix, d_cv[j]["tr"][[:x_1, :x_2]])
     ytr_a = convert(Vector, d_cv[j]["tr"][:y])
     tst_a = convert(Matrix, d_cv[j]["tst"][[:x_1, :x_2]])
     ytst_a = convert(Vector, d_cv[j]["tst"][:y])
     pred = knn(tr_a, ytr_a, tst_a, i)[:,1]
     cv_res[j] = knnmcr(pred, ytst_a)
  end
  knnres[i, 1] = i
  knnres[i, 2] = mean(cv_res)
  knnres[i, 3] = /(std(cv_res), sqrt(kcv))
end
