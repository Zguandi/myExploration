function multiThreadRng(n::Int)
    rngs = [MersenneTwister() for i in 1:n]
    @threads for i in 1:n
        Random.seed!(rngs[i], i)
        println(rand(rngs[i]))
    end
end