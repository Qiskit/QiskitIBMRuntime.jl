using JuliaFormatter

if format(dirname(@__DIR__))
    println("All files are already formatted.")
else
    println("Some files were reformatted.")
end
