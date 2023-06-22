
import CSV, DataFrames

function transform(d1, fr1::Integer, fr2::Integer)
    
    nd1 = length(d1)
    nd2 = Int(floor(nd1*fr2/fr1))
    λ   = (0:(nd2-1))*fr1/fr2
    ii1 = Int.(floor.(λ))
    λ  -= ii1
    d1  = vcat(deepcopy(d1), d1[end])

    return (1 .- λ) .* d1[1 .+ ii1] + λ .* d1[2 .+ ii1]
end

