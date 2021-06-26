module TaylorMap

using TaylorSeries
export TaylorMapNd, getlinearmap, getsquarematrix

getcoeffs(a::Taylor1)=a.coeffs
getcoeffs(a::TaylorN)=reduce(vcat,[a.coeffs[i].coeffs for i=1:a.order+1])

struct TaylorMapNd{T <: Number} <: AbstractVector{T} 
    dim::UInt8
    max_order::UInt8
    tpsc::Vector{TaylorN{T}}  
end
TaylorMapNd(::Type{T}, d::Int, o::Int) where {T<:Number} =
        TaylorMapNd{T}(d, o, set_variables(T, "x", numvars=d, order=o))




Base.size(z::TaylorMapNd)=Base.size(z.tpsc)
Base.IndexStyle(::Type{<:TaylorMapNd})=IndexLinear()

Base.getindex(z::TaylorMapNd, i::Int)=Base.getindex(z.tpsc,i)
Base.setindex!(z::TaylorMapNd, v, i::Int)=(z.tpsc[i]=v)

Base.promote_rule(::Type{Vector{TaylorN{Complex}}}, ::Type{Vector{TaylorN{AbstractFloat}}}) = Vector{TaylorN{AbstractFloat}}
Base.convert(::Type{TaylorMapNd{T}}, a::TaylorMapNd) where {T<:Number} = 
    TaylorMapNd{T}(a.dim, a.max_order, [Base.convert(TaylorN{T}, a.tpsc[i]) for i=1:a.dim])
    

function getlinearmap(z::TaylorMapNd{T}) where {T}
    linmap=Array{T, 2}(undef, z.dim, z.dim)
    for i = 1:z.dim
        linmap[i,:]=z.tpsc[i].coeffs[2].coeffs
    end
    return linmap
end

function getsquarematrix(z::TaylorMapNd{T}) where {T}
    dim_sm=binomial(Int64(z.dim+z.max_order), Int64(z.max_order))
    println(dim_sm)
    sqrmat=Array{T, 2}(undef, dim_sm, dim_sm)
    powerindex=reduce(vcat, TaylorSeries.generate_tables(z.dim, z.max_order)[1])
    powers=[[z[i]^j for j=0:z.max_order] for i=1:z.dim]
    for i = 1:dim_sm
        value=reduce(*, [powers[l][j+1] for (l,j) in enumerate(powerindex[i])])
        sqrmat[i, :]=getcoeffs(value)       
    end
    return sqrmat
end



end # module
