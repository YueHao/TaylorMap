module TaylorMap

using TaylorSeries
using LinearAlgebra
export TaylorMapNd, getlinearmap, getsquarematrix
#include("unitary.jl")


getcoeffs(a::Taylor1)=a.coeffs
getcoeffs(a::TaylorN)=reduce(vcat,[a.coeffs[i].coeffs for i=1:a.order+1])

struct TaylorMapNd{T <: Number} <: AbstractVector{TaylorN{T}}
    dim::Int64
    max_order::Int64
    tpsc::Vector{TaylorN{T}} 
    dim_sm::Int64
    power_index::Vector{Vector{Int64}}
end
TaylorMapNd(::Type{T}, d::Int, o::Int) where {T<:Number} =
        TaylorMapNd{T}(d, o, set_variables(T, "x", numvars=d, order=o), 
        binomial((d+o), (d)),
        reduce(vcat, TaylorSeries.generate_tables(d, o)[1])
        )

function TaylorMapNd(temp::AbstractVector{TaylorN{T}}) where {T<:Number} 
    d=length(temp)
    o=temp[1].order
    return TaylorMapNd{T}(d, o, temp, binomial((d+o), (d)), reduce(vcat, TaylorSeries.generate_tables(d, o)[1]))
end



Base.size(z::TaylorMapNd)=Base.size(z.tpsc)
Base.IndexStyle(::Type{<:TaylorMapNd})=IndexLinear()
Base.eltype(::Type{<:TaylorMapNd{T}}) where {T<:Number} = TaylorN{T}

Base.getindex(z::TaylorMapNd, i::Int)=Base.getindex(z.tpsc,i)
Base.setindex!(z::TaylorMapNd{T}, v::TaylorN{T}, i::Int) where {T<:Number} = (z.tpsc[i]=v)

#Base.promote_rule(::Type{Vector{TaylorN{Complex}}}, ::Type{Vector{TaylorN{AbstractFloat}}}) = Vector{TaylorN{AbstractFloat}}
#Base.promote_rule(::Type{Vector{TaylorN}}, ::Type{TaylorMapNd})=Vector{TaylorN{T}}
    

function getlinearmap(z::TaylorMapNd{T}) where {T}
    linmap=Array{T, 2}(undef, z.dim, z.dim)
    for i = 1:z.dim
        linmap[i,:]=z.tpsc[i].coeffs[2].coeffs
    end
    return linmap
end

function getdegeneratelist(z::TaylorMapNd{T}, target::Int64, resonance::Vector{Vector{Int64}} = Nothing) where {T}
    hdim = z.dim >> 1
    fns = zeros(z.dim_sm, hdim)
    for i = 1:z.dim_sm
        for j= 1:hdim
            fns[i,j] = z.power_index[i][2*j-1] - z.power_index[i][2*j]
        end
        fns[i, target] -=1
    end

    if resonance != Nothing
        for res in resonance
            
        end
    end

    
end

function getsquarematrix(z::TaylorMapNd{T}) where {T}
    sqrmat=Array{T, 2}(undef, z.dim_sm, z.dim_sm)
    powers=[[z[i]^j for j=0:z.max_order] for i=1:z.dim]
    for i = 1:z.dim_sm
        value=reduce(*, [powers[l][j+1] for (l,j) in enumerate(z.power_index[i])])
        sqrmat[i, :]=getcoeffs(value)       
    end
    return sqrmat 
end

function diagonalize(z::TaylorMapNd{T}) where {T}
    linearmap=getlinearmap(z)
    
end



function jordan_decomposition(z::TaylorMapNd{T}, frequency_index=1, diagonalize_first=false) where {T}
    sqrmat=UpperTriangular(getsquarematrix(z))


end  

end # module
