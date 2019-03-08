using RDatasets

## look for crabs in available datasets
rds = RDatasets.datasets()
filter(x -> occursin("crab", x[:Dataset]), rds)

crabs = dataset("MASS", "crabs")
print(crabs[1:5, :])
