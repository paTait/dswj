## A function with multiple options for return
function gt(g1, g2)
  if(g1 >g2)
     return("$g1 is largest")
  elseif(g1<g2)
    return("$g2  is largest")
  else
  return("$g1 and  $g2 are equal")
  end
end

gt(2,4)
# "4  is largest"
