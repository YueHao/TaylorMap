
function unitary_transform(indi::Integer,indj::Integer, ratiol::T, ratior::T, 
    mat::Matrix{T}, leftm::Matrix{T}, rightm::Matrix{T}) where {T<:Number}
    rightm[:, indj] += rightm[:, indi] * ratior
    leftm[indi, :] += leftm[indj, :] * ratiol

    temp1 = mat[ind_j, :] * ratiol
    temp2 = mat[:, ind_i] * ratior
    temp3 = mat[ind_j, ind_i] * ratiol * ratior

    mat[ind_i ,:] += temp1
    mat[:, indj] += temp2
    mat[indi, indj] += temp3
end

function sub_space(mat::LinearAlgebra.UpperTriangular, space_ind::Vector{Integer})

end
