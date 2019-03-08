## try/catch

for i in [1, 2, -1, "A"]
  try log(i)
  catch ex
    if isa(ex, DomainError)
      println("i: $i --- Domain Error")
      log(abs(i))
    else
      println("i: $i")
      println(ex)
      error("Not a DomainError")
    end
  end
end

# i: -1 --- Domain Error
# i: A
# MethodError(log, ("A",), 0x00000000000061f0)
# ERROR: Not a DomainError
# Stacktrace:
#  [1] top-level scope at ./none:10
