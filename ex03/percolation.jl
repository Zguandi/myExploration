using Random
using Threads

function generateLattice(L::Int)
    return rand(Bool, L, L)
end

function multiThreadGenerateLattice(L::Int)
    lattice_flatten = zeros(float,L*L)
    Threads.@thread for i in 1:L*L
        lattice_flatten[i] = rand()
    end
    lattice = reshape(lattice_flatten, L, L)
    return lattice
end