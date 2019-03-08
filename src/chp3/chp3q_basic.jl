## Pseudo code for a generic Query.jl statement
## the query statements in <statements> are separated by \n
x_obj  = @from <range_var> in <data_source> begin
    <statements>
end

