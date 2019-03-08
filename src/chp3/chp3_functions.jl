using MLLabelUtils

function onehot_encoding!(df::DataFrame, col::String; trace = false)

    tmp = df[Symbol(col)]
    lev = map(x -> isa(x, String) ? titlecase(x) : string(x), unique(tmp))
    colname = deepcopy(lev)
    nmiss = sum(convert(Array{Bool}, map(x -> ismissing(x), tmp)))

    if(trace)
        println("lev: $lev")
        println("typeof(colname): $(typeof(colname))")
        println("colname: $colname")
        println("nmiss: $nmiss")
    end

   if(nmiss >0)
       tmp = convert(Array{String,1}, map(x -> ismissing(x) ? "missing" : string(x), tmp))
   end

   if isa(colname, Array{Union{Missing, String},1}) || isa(colname, Array{String,1})
       colname = .*(col, map(x -> replace(x," " => "_"), colname))
   else
       colname = .*("V_", map(x -> string(x), 1:length(colname)))
   end

   for (i, v) in enumerate(lev)
       tf = convertlabel(LabelEnc.ZeroOne, tmp, LabelEnc.OneVsRest(v))
       df[Symbol(colname[i])] = tf
   end

end

# onehot_encoding!(tmp, "brew_method", trace=true)
