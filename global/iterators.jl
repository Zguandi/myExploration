using Interpolations

function congruential_iterator(x, c, p)
    return (x * c) % p
end

function logistic_iterator(x, a)
    return a * x * (1 - x)
end

function congurential_generator(seed, c, p, n)
    sample = []
    x = seed
    for i in 1:n
        x = congruential_iterator(x, c, p)
        push!(sample, x)
    end
    return sample
end

function logistic_generator(seed, a, n)
    sample = []
    x = seed
    for i in 1:n
        x = logistic_iterator(x, a)
        push!(sample, x)
    end
    # open file cdf.txt
    x_list_cdf = zeros(1001)
    cdf = zeros(1001)
    open("./logisticCdf.txt", "r") do f
        for i in 1:1001
            x_list_cdf[i], cdf[i] = split(readline(f), " ") |> x->parse.(Float64,x)
        end
    end
    cdf_interp = LinearInterpolation(x_list_cdf, cdf)
    random_sample = cdf_interp.(sample)

    return random_sample
end

# println(congurential_generator(1, 3, 7, 10))
println(logistic_generator(0.21, 4.0, 10))