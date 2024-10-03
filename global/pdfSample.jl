using Random
using Interpolations

# get length n cdf from pdf
function pdf2cdf(n::Int64,pdf::Function,interval::Tuple{Float64,Float64},args...)
    x = range(interval[1],stop=interval[2],length=n)
    cdf = zeros(n)
    cdf[1] = 0.0
    # integrate using 4th order Runge-Kutta method
    for i in 2:n
        h = x[i] - x[i-1]
        k1 = h*pdf(x[i-1],args...)
        k2 = h*pdf(x[i-1]+h/2,k1/2,args...)
        k3 = h*pdf(x[i-1]+h/2,k2/2,args...)
        k4 = h*pdf(x[i-1]+h,k3,args...)
        cdf[i] = cdf[i-1] + (k1 + 2*k2 + 2*k3 + k4)/6
    end
    # normalize the cdf
    cdf = cdf./cdf[end]
    return x,cdf
end

# save cdf to file
function cdf2cache(x,cdf,filename)
    open(filename, "w") do f
        for i in eachindex(x)
            println(f, x[i], " ", cdf[i])
        end
    end
end

# read cdf from file
function cache2cdf(n::Int64,filename)
    x = zeros(n)
    cdf = zeros(n)
    open(filename, "r") do f
        for i in eachindex(x)
            x[i], cdf[i] = split(readline(f), " ") |> x->parse.(Float64,x)
        end
    end
    return x,cdf
end

function cdfInverseInterp(x,cdf)
    return LinearInterpolation(cdf,x)
end

function pdf2random(n::Int64, pdf::Function, interval::Tuple{Float64,Float64})
    x,cdf = pdf2cdf(n,pdf,interval)
    cdf_inv = cdfInverseInterp(x,cdf)
    return cdf_inv(rand(n))
end

function cache2random(n::Int64,filename)
    x,cdf = cache2cdf(n,filename)
    cdf_inv = cdfInverseInterp(x,cdf)
    return cdf_inv(rand(n))
end

# test
pdf(x) = 2*x
interval = (0.0,1.0)
n = 1001
filename = "cdf.txt"
xs,cdfs = pdf2cdf(n,pdf,interval)
cdf2cache(xs,cdfs,filename)

println(sample[1:10])