using Test
using Revise
using TaylorMap

a=TaylorMapNd(Float64, 4, 5)
tmap=rand(4,4)

tmap*a
@test true


struct 